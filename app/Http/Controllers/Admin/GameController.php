<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\GameCategory;
use App\Models\Year;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameController extends Controller
{
    public function index(Request $request): View
    {
        $search = trim((string) $request->query('q', ''));

        $games = Game::query()
            ->with(['year', 'gameCategory'])
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.games.index', [
            'games' => $games,
            'search' => $search,
        ]);
    }

    public function create(): View
    {
        return view('screens.admin.games.create', [
            'years' => Year::query()->where('status', 'active')->orderBy('id')->get(),
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = collect($this->validated($request))->except(['image', 'cover_book_image_file'])->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request, 'image', 'game_');
        }

        if ($request->hasFile('cover_book_image_file')) {
            $data['cover_book_image'] = $this->storeImage($request, 'cover_book_image_file', 'cover_');
        }

        Game::query()->create($data);

        return redirect()
            ->route('admin.games.index')
            ->with('success', 'Game created successfully.');
    }

    public function edit(Game $game): View
    {
        return view('screens.admin.games.edit', [
            'game' => $game,
            'years' => Year::query()->where('status', 'active')->orderBy('id')->get(),
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
        ]);
    }

    public function update(Request $request, Game $game): RedirectResponse
    {
        $data = collect($this->validated($request, $game))->except(['image', 'cover_book_image_file'])->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($game->image_url);
            $data['image_url'] = $this->storeImage($request, 'image', 'game_');
        }

        if ($request->hasFile('cover_book_image_file')) {
            $this->deleteImageFile($game->cover_book_image);
            $data['cover_book_image'] = $this->storeImage($request, 'cover_book_image_file', 'cover_');
        }

        $game->update($data);

        return redirect()
            ->route('admin.games.index')
            ->with('success', 'Game updated successfully.');
    }

    public function destroy(Game $game): RedirectResponse
    {
        $this->deleteImageFile($game->image_url);
        $this->deleteImageFile($game->cover_book_image);
        $game->delete();

        return redirect()
            ->route('admin.games.index')
            ->with('success', 'Game deleted successfully.');
    }

    private function validated(Request $request, ?Game $game = null): array
    {
        return $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'year_id' => [
                'required',
                'integer',
                Rule::exists('years', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
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
            'cover_book_image_file' => [
                'nullable',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ]);
    }

    private function storeImage(Request $request, string $field, string $prefix): string
    {
        $directory = public_path('assets/games');
        File::ensureDirectoryExists($directory);

        $filename = uniqid($prefix, true).'.'.$request->file($field)->getClientOriginalExtension();
        $request->file($field)->move($directory, $filename);

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
