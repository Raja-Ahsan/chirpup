<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GameMood;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameMoodController extends Controller
{
    public function index(Request $request): View
    {
        $search = trim((string) $request->query('q', ''));

        $moods = GameMood::query()
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.game-moods.index', [
            'moods' => $moods,
            'search' => $search,
        ]);
    }

    public function create(): View
    {
        return view('screens.admin.game-moods.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $data = collect($this->validated($request))->except('image')->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request);
        }

        GameMood::query()->create($data);

        return redirect()
            ->route('admin.game-moods.index')
            ->with('success', 'Game mood created successfully.');
    }

    public function edit(GameMood $gameMood): View
    {
        return view('screens.admin.game-moods.edit', [
            'mood' => $gameMood,
        ]);
    }

    public function update(Request $request, GameMood $gameMood): RedirectResponse
    {
        $data = collect($this->validated($request, $gameMood))->except('image')->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($gameMood->image_url);
            $data['image_url'] = $this->storeImage($request);
        }

        $gameMood->update($data);

        return redirect()
            ->route('admin.game-moods.index')
            ->with('success', 'Game mood updated successfully.');
    }

    public function destroy(GameMood $gameMood): RedirectResponse
    {
        $this->deleteImageFile($gameMood->image_url);
        $gameMood->delete();

        return redirect()
            ->route('admin.game-moods.index')
            ->with('success', 'Game mood deleted successfully.');
    }

    private function validated(Request $request, ?GameMood $mood = null): array
    {
        return $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $mood ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/game-moods');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('mood_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $seedImages = [
            'happy.png',
            'calm.png',
            'sleepy.png',
            'angry.png',
            'sad.png',
        ];

        if (in_array($filename, $seedImages, true)) {
            return;
        }

        $path = public_path('assets/game-moods/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
