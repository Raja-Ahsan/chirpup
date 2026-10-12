<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Character;
use App\Models\Child;
use App\Models\Game;
use App\Models\GameCategory;
use App\Models\GameMood;
use App\Models\GameType;
use App\Models\GameTypeSketch;
use App\Models\User;
use App\Models\Year;
use Illuminate\View\View;

class DashboardController extends Controller
{
    public function index(): View
    {
        $stats = [
            [
                'label' => 'Users',
                'value' => User::query()->where('role', 'user')->count(),
                'meta' => User::query()->where('role', 'user')->whereDate('created_at', today())->count().' new today',
                'route' => 'admin.users.index',
                'icon' => 'fa-solid fa-users',
            ],
            [
                'label' => 'Children',
                'value' => Child::query()->count(),
                'meta' => Child::query()->where('status', 'active')->count().' active',
                'route' => null,
                'icon' => 'fa-solid fa-child',
            ],
            [
                'label' => 'Characters',
                'value' => Character::query()->count(),
                'meta' => Character::query()->where('status', 'active')->count().' active',
                'route' => 'admin.characters.index',
                'icon' => 'fa-solid fa-dragon',
            ],
            [
                'label' => 'Years',
                'value' => Year::query()->count(),
                'meta' => Year::query()->where('status', 'active')->count().' active',
                'route' => null,
                'icon' => 'fa-regular fa-calendar',
            ],
            [
                'label' => 'Game Moods',
                'value' => GameMood::query()->count(),
                'meta' => GameMood::query()->where('status', 'active')->count().' active',
                'route' => 'admin.game-moods.index',
                'icon' => 'fa-regular fa-face-smile',
            ],
            [
                'label' => 'Game Categories',
                'value' => GameCategory::query()->count(),
                'meta' => GameCategory::query()->where('status', 'active')->count().' active',
                'route' => 'admin.game-categories.index',
                'icon' => 'fa-solid fa-layer-group',
            ],
            [
                'label' => 'Games',
                'value' => Game::query()->count(),
                'meta' => Game::query()->where('status', 'active')->count().' active',
                'route' => 'admin.games.index',
                'icon' => 'fa-solid fa-puzzle-piece',
            ],
            [
                'label' => 'Game Types',
                'value' => GameType::query()->count(),
                'meta' => GameTypeSketch::query()->count().' sketches',
                'route' => 'admin.game-types.index',
                'icon' => 'fa-solid fa-shapes',
            ],
        ];

        $gamesByYear = Year::query()
            ->withCount(['games' => function ($query) {
                $query->where('status', 'active');
            }])
            ->orderBy('id')
            ->get();

        $recentUsers = User::query()
            ->where('role', 'user')
            ->latest('id')
            ->limit(5)
            ->get(['id', 'name', 'email', 'created_at']);

        $recentGameTypes = GameType::query()
            ->with(['year:id,title', 'game:id,name'])
            ->withCount('sketches')
            ->latest('id')
            ->limit(5)
            ->get();

        return view('screens.admin.dashboard.index', [
            'stats' => $stats,
            'gamesByYear' => $gamesByYear,
            'recentUsers' => $recentUsers,
            'recentGameTypes' => $recentGameTypes,
            'sketchCount' => GameTypeSketch::query()->count(),
            'activeGameTypes' => GameType::query()->where('status', 'active')->count(),
        ]);
    }
}
