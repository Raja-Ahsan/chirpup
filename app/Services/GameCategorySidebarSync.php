<?php

namespace App\Services;

use App\Models\CmsModule;
use App\Models\CmsModulePermission;
use App\Models\GameCategory;

class GameCategorySidebarSync
{
    public const ROUTE_PREFIX = 'game-category.';

    public static function routeNameFor(GameCategory $category): string
    {
        return self::ROUTE_PREFIX.$category->id;
    }

    public static function sync(GameCategory $category): void
    {
        $parent = CmsModule::query()
            ->where('route_name', 'game-management-module')
            ->first();

        if (! $parent) {
            return;
        }

        $module = CmsModule::query()->updateOrCreate(
            ['route_name' => self::routeNameFor($category)],
            [
                'name' => $category->title,
                'icon' => 'fa-solid fa-layer-group',
                'sort_order' => (int) $category->id,
                'status' => $category->status === 'active' && ! $category->trashed()
                    ? 'active'
                    : 'inactive',
                'parent_id' => $parent->id,
            ]
        );

        CmsModulePermission::query()->updateOrCreate(
            [
                'module_id' => $module->id,
                'role' => 'admin',
            ],
            [
                'is_view' => 1,
                'is_add' => 1,
                'is_update' => 1,
                'is_delete' => 1,
                'status' => 'active',
            ]
        );
    }

    public static function remove(GameCategory $category): void
    {
        $module = CmsModule::query()
            ->where('route_name', self::routeNameFor($category))
            ->first();

        if (! $module) {
            return;
        }

        $module->permissions()->delete();
        $module->delete();
    }

    public static function syncAll(): void
    {
        $parent = CmsModule::query()
            ->where('route_name', 'game-management-module')
            ->first();

        if (! $parent) {
            return;
        }

        $categories = GameCategory::query()
            ->orderBy('id')
            ->get();

        $keepRouteNames = $categories
            ->map(fn (GameCategory $category) => self::routeNameFor($category))
            ->all();

        $orphanModules = CmsModule::query()
            ->where('parent_id', $parent->id)
            ->where('route_name', 'like', self::ROUTE_PREFIX.'%')
            ->when(
                $keepRouteNames !== [],
                fn ($query) => $query->whereNotIn('route_name', $keepRouteNames)
            )
            ->get();

        foreach ($orphanModules as $module) {
            $module->permissions()->delete();
            $module->delete();
        }

        foreach ($categories as $category) {
            self::sync($category);
        }
    }
}
