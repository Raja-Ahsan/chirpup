<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GameCategory;
use App\Models\GameMood;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameCategoryController extends Controller
{
    public function index(Request $request): View
    {
        $search = trim((string) $request->query('q', ''));

        $categories = GameCategory::query()
            ->withCount(['categoryMoods as moods_count' => function ($query) {
                $query->where('status', 'active');
            }])
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('title', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.game-categories.index', [
            'categories' => $categories,
            'search' => $search,
        ]);
    }

    public function create(): View
    {
        return view('screens.admin.game-categories.create', [
            'moods' => GameMood::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedMoodIds' => old('mood_ids', []),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = collect($this->validated($request))->except(['image', 'mood_ids'])->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request);
        }

        $category = GameCategory::query()->create($data);
        $category->syncMoods($request->input('mood_ids', []));

        return redirect()
            ->route('admin.game-categories.index')
            ->with('success', 'Game category created successfully.');
    }

    public function edit(GameCategory $gameCategory): View
    {
        $gameCategory->load('categoryMoods');

        return view('screens.admin.game-categories.edit', [
            'category' => $gameCategory,
            'moods' => GameMood::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedMoodIds' => old(
                'mood_ids',
                $gameCategory->categoryMoods->pluck('mood_id')->all()
            ),
        ]);
    }

    public function update(Request $request, GameCategory $gameCategory): RedirectResponse
    {
        $data = collect($this->validated($request, $gameCategory))->except(['image', 'mood_ids'])->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($gameCategory->image_url);
            $data['image_url'] = $this->storeImage($request);
        }

        $gameCategory->update($data);
        $gameCategory->syncMoods($request->input('mood_ids', []));

        return redirect()
            ->route('admin.game-categories.index')
            ->with('success', 'Game category updated successfully.');
    }

    public function destroy(GameCategory $gameCategory): RedirectResponse
    {
        $this->deleteImageFile($gameCategory->image_url);
        $gameCategory->categoryMoods()->delete();
        $gameCategory->delete();

        return redirect()
            ->route('admin.game-categories.index')
            ->with('success', 'Game category deleted successfully.');
    }

    private function validated(Request $request, ?GameCategory $category = null): array
    {
        return $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $category ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
            'mood_ids' => ['nullable', 'array'],
            'mood_ids.*' => [
                'integer',
                Rule::exists('game_mood', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/game-categories');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('category_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $path = public_path('assets/game-categories/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
