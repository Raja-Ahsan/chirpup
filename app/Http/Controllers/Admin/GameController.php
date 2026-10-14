<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\GameBookYear;
use App\Models\GameCategory;
use App\Models\GameType;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameController extends Controller
{
    public function index(): View
    {
        $categories = GameCategory::query()
            ->withCount('games')
            ->orderBy('id')
            ->get();

        return view('screens.admin.games.index', [
            'categories' => $categories,
        ]);
    }

    public function byCategory(GameCategory $gameCategory): View|RedirectResponse
    {
        // Both hub widgets (Games + Game Book & Year) are Creative-only.
        if ($gameCategory->slug !== 'creative') {
            return redirect()->route('admin.games.category-games', $gameCategory);
        }

        $gamesCount = Game::query()
            ->where('game_category_id', $gameCategory->id)
            ->count();

        $bookYearCount = GameBookYear::query()
            ->whereHas('game', fn ($query) => $query->where('game_category_id', $gameCategory->id))
            ->count();

        $sketchesCount = GameType::query()
            ->where('game_category_id', $gameCategory->id)
            ->count();

        return view('screens.admin.games.hub', [
            'category' => $gameCategory,
            'gamesCount' => $gamesCount,
            'bookYearCount' => $bookYearCount,
            'sketchesCount' => $sketchesCount,
        ]);
    }

    public function categoryGames(Request $request, GameCategory $gameCategory): View
    {
        $search = trim((string) $request->query('q', ''));

        $games = Game::query()
            ->with('gameCategory')
            ->where('game_category_id', $gameCategory->id)
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.games.list', [
            'category' => $gameCategory,
            'games' => $games,
            'search' => $search,
        ]);
    }

    public function create(Request $request): View
    {
        $selectedCategoryId = old('game_category_id', $request->query('game_category_id'));
        $selectedCategory = $selectedCategoryId
            ? GameCategory::query()->find($selectedCategoryId)
            : null;

        return view('screens.admin.games.create', [
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedCategoryId' => $selectedCategory?->id ?? $selectedCategoryId,
            'selectedCategory' => $selectedCategory,
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $this->validated($request);
        $data = collect($validated)->except(['image'])->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request);
        }

        $game = Game::query()->create($data);

        $category = GameCategory::query()->find($game->game_category_id);

        return redirect()
            ->route(
                $category ? 'admin.games.category-games' : 'admin.games.index',
                $category ? ['gameCategory' => $category] : []
            )
            ->with('success', 'Game created successfully.');
    }

    public function edit(Game $game): View
    {
        $game->load('gameCategory');

        return view('screens.admin.games.edit', [
            'game' => $game,
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedCategoryId' => $game->game_category_id,
            'selectedCategory' => $game->gameCategory,
        ]);
    }

    public function update(Request $request, Game $game): RedirectResponse
    {
        $validated = $this->validated($request, $game);
        $data = collect($validated)->except(['image'])->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($game->image_url);
            $data['image_url'] = $this->storeImage($request);
        }

        $game->update($data);

        $category = GameCategory::query()->find($game->game_category_id);

        return redirect()
            ->route(
                $category ? 'admin.games.category-games' : 'admin.games.index',
                $category ? ['gameCategory' => $category] : []
            )
            ->with('success', 'Game updated successfully.');
    }

    public function destroy(Game $game): RedirectResponse
    {
        $category = GameCategory::query()->find($game->game_category_id);

        $this->deleteImageFile($game->image_url);
        $game->delete();

        return redirect()
            ->route(
                $category ? 'admin.games.category-games' : 'admin.games.index',
                $category ? ['gameCategory' => $category] : []
            )
            ->with('success', 'Game deleted successfully.');
    }

    private function validated(Request $request, ?Game $game = null): array
    {
        return $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('game', 'name')
                    ->whereNull('deleted_at')
                    ->ignore($game?->id),
            ],
            'game_category_id' => [
                'required',
                'integer',
                Rule::exists('game_categories', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $game ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/games');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('game_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $seedImages = [
            'magic_coloring.png',
            'castle.png',
            'book1.png',
            'book2.png',
            'book3.png',
        ];

        if (in_array($filename, $seedImages, true)) {
            return;
        }

        $path = public_path('assets/games/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
