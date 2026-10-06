<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Character;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class CharacterController extends Controller
{
    public function index(Request $request): View
    {
        $search = trim((string) $request->query('q', ''));

        $characters = Character::query()
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.characters.index', [
            'characters' => $characters,
            'search' => $search,
        ]);
    }

    public function create(): View
    {
        return view('screens.admin.characters.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $data = collect($this->validated($request))->except('image')->all();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->storeImage($request);
        }

        Character::query()->create($data);

        return redirect()
            ->route('admin.characters.index')
            ->with('success', 'Character created successfully.');
    }

    public function edit(Character $character): View
    {
        return view('screens.admin.characters.edit', [
            'character' => $character,
        ]);
    }

    public function update(Request $request, Character $character): RedirectResponse
    {
        $data = collect($this->validated($request, $character))->except('image')->all();

        if ($request->hasFile('image')) {
            $this->deleteImageFile($character->image_url);
            $data['image_url'] = $this->storeImage($request);
        }

        $character->update($data);

        return redirect()
            ->route('admin.characters.index')
            ->with('success', 'Character updated successfully.');
    }

    public function destroy(Character $character): RedirectResponse
    {
        $this->deleteImageFile($character->image_url);
        $character->delete();

        return redirect()
            ->route('admin.characters.index')
            ->with('success', 'Character deleted successfully.');
    }

    private function validated(Request $request, ?Character $character = null): array
    {
        return $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $character ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/characters');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('character_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $seedImages = [
            'character_prince.png',
            'character_princes.png',
            'character_knight.png',
            'character_babydragon.png',
        ];

        if (in_array($filename, $seedImages, true)) {
            return;
        }

        $path = public_path('assets/characters/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
