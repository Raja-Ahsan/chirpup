<?php

use App\Models\CmsModule;
use App\Models\GameCategory;
use App\Services\GameCategorySidebarSync;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

function dynamic_sidebar()
{
    $roleId = Auth::user()?->role;

    if (! $roleId) {
        return collect();
    }

    return CmsModule::with(['children' => function ($q) use ($roleId) {
        $q->where('status', 'active')
            ->whereHas('permissions', function ($perm) use ($roleId) {
                $perm->where('role', $roleId)
                    ->where('is_view', 1);
            });
    }])
        ->where('parent_id', 0)
        ->where('status', 'active')
        ->whereHas('permissions', function ($q) use ($roleId) {
            $q->where('role', $roleId)
                ->where('is_view', 1);
        })
        ->orderBy('sort_order')
        ->get();
}

function sidebar_module_url(?string $routeName): string
{
    if (! $routeName) {
        return '#';
    }

    if (str_starts_with($routeName, GameCategorySidebarSync::ROUTE_PREFIX)) {
        $categoryId = (int) substr($routeName, strlen(GameCategorySidebarSync::ROUTE_PREFIX));
        $category = GameCategory::query()->find($categoryId);

        return $category
            ? route('admin.games.by-category', $category)
            : '#';
    }

    return Route::has($routeName) ? route($routeName) : '#';
}

function sidebar_route_is_active(?string $routeName): bool
{
    if (! $routeName) {
        return false;
    }

    if (str_starts_with($routeName, GameCategorySidebarSync::ROUTE_PREFIX)) {
        $categoryId = (int) substr($routeName, strlen(GameCategorySidebarSync::ROUTE_PREFIX));

        if (! request()->routeIs(
            'admin.games.by-category',
            'admin.games.category-games',
            'admin.games.create',
            'admin.games.edit',
            'admin.game-book-years.*',
            'admin.sketches.*'
        )) {
            return false;
        }

        $routeCategory = request()->route('gameCategory');
        if ($routeCategory instanceof GameCategory) {
            return (int) $routeCategory->id === $categoryId;
        }

        if (request()->routeIs('admin.games.create')) {
            return (int) request()->query('game_category_id') === $categoryId
                || (int) old('game_category_id') === $categoryId;
        }

        $game = request()->route('game');
        if ($game && isset($game->game_category_id)) {
            return (int) $game->game_category_id === $categoryId;
        }

        return false;
    }

    if (request()->routeIs($routeName)) {
        return true;
    }

    if (str_ends_with($routeName, '.index')) {
        $prefix = substr($routeName, 0, -strlen('.index'));

        return request()->routeIs($prefix.'.*');
    }

    return false;
}
