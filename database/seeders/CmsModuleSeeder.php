<?php

namespace Database\Seeders;

use App\Models\CmsModule;
use App\Services\GameCategorySidebarSync;
use Illuminate\Database\Seeder;

class CmsModuleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * Uses updateOrCreate (not only firstOrCreate) so re-seeding repairs wrong parent_id
     * from old data where child route_names were left as top-level rows.
     *
     * Sidebar: only index / "all" listing routes — never create routes; add buttons live on those pages.
     * Game Management children are synced from game_categories (not static Game Type / Game links).
     */
    public function run(): void
    {
        CmsModule::updateOrCreate(
            ['route_name' => 'admin.dashboard'],
            [
                'name' => 'Dashboard',
                'icon' => 'fa-regular fa-house',
                'sort_order' => 1,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'admin.users.index'],
            [
                'name' => 'Users',
                'icon' => 'fa-solid fa-users',
                'sort_order' => 2,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'admin.characters.index'],
            [
                'name' => 'Characters',
                'icon' => 'fa-solid fa-dragon',
                'sort_order' => 3,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'admin.game-moods.index'],
            [
                'name' => 'Mood',
                'icon' => 'fa-regular fa-face-smile',
                'sort_order' => 4,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'admin.game-categories.index'],
            [
                'name' => 'Game Categories',
                'icon' => 'fa-solid fa-layer-group',
                'sort_order' => 5,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'admin.books.index'],
            [
                'name' => 'Books',
                'icon' => 'fa-solid fa-book',
                'sort_order' => 6,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        CmsModule::updateOrCreate(
            ['route_name' => 'game-management-module'],
            [
                'name' => 'Game Management',
                'icon' => 'fa-solid fa-gamepad',
                'sort_order' => 7,
                'status' => 'active',
                'parent_id' => 0,
            ]
        );

        GameCategorySidebarSync::syncAll();

        $allowed = [
            'admin.dashboard',
            'admin.users.index',
            'admin.characters.index',
            'admin.game-moods.index',
            'admin.game-categories.index',
            'admin.books.index',
            'game-management-module',
        ];

        CmsModule::query()
            ->where(function ($q) use ($allowed) {
                $q->whereNull('route_name')
                    ->orWhere(function ($inner) use ($allowed) {
                        $inner->whereNotIn('route_name', $allowed)
                            ->where('route_name', 'not like', GameCategorySidebarSync::ROUTE_PREFIX.'%');
                    });
            })
            ->delete();
    }
}
