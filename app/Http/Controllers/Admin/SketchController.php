<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GameCategory;
use App\Models\GameType;
use Illuminate\Http\Request;
use Illuminate\View\View;

class SketchController extends Controller
{
    private const ALLOWED_CATEGORY_SLUG = 'creative';

    public function index(Request $request, GameCategory $gameCategory): View
    {
        abort_unless($gameCategory->slug === self::ALLOWED_CATEGORY_SLUG, 404);

        $search = trim((string) $request->query('q', ''));

        $gameTypes = GameType::query()
            ->with(['game', 'year', 'book'])
            ->withCount('sketches')
            ->where('game_category_id', $gameCategory->id)
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%")
                        ->orWhereHas('game', fn ($q) => $q->where('name', 'like', "%{$search}%"))
                        ->orWhereHas('book', fn ($q) => $q->where('title', 'like', "%{$search}%"));
                });
            })
            ->orderByDesc('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.sketches.index', [
            'category' => $gameCategory,
            'gameTypes' => $gameTypes,
            'search' => $search,
        ]);
    }
}
