<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\GameBook;
use App\Models\GameBookYear;
use App\Models\GameCategory;
use App\Models\GameType;
use App\Models\GameTypeSketch;
use App\Models\Year;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameTypeController extends Controller
{
    public function index(Request $request): View
    {
        $categoryId = $request->query('game_category_id');

        $games = Game::query()
            ->withCount('gameTypes')
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->orderBy('id')
            ->get();

        return view('screens.admin.game-types.index', [
            'games' => $games,
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedCategoryId' => $categoryId,
        ]);
    }

    public function byGame(Request $request, Game $game): View
    {
        $search = trim((string) $request->query('q', ''));
        $categoryId = $request->query('game_category_id');

        $gameTypes = GameType::query()
            ->with(['year', 'gameCategory', 'game'])
            ->withCount('sketches')
            ->where('game_id', $game->id)
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->where('name', 'like', "%{$search}%")
                        ->orWhere('slug', 'like', "%{$search}%");
                });
            })
            ->orderBy('id')
            ->paginate(12)
            ->withQueryString();

        return view('screens.admin.game-types.list', [
            'game' => $game,
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
            'selectedCategoryId' => $categoryId,
            'gameTypes' => $gameTypes,
            'search' => $search,
        ]);
    }

    public function create(Request $request): View
    {
        $selectedGameId = old('game_id', $request->query('game_id'));
        $selectedGame = $selectedGameId
            ? Game::query()->find($selectedGameId)
            : null;

        $selectedCategoryId = old(
            'game_category_id',
            $request->query('game_category_id', $selectedGame?->game_category_id)
        );
        $selectedCategory = $selectedCategoryId
            ? GameCategory::query()->find($selectedCategoryId)
            : null;

        return view('screens.admin.game-types.create', array_merge(
            $this->formOptions(),
            [
                'selectedGameId' => $selectedGame?->id,
                'selectedGame' => $selectedGame,
                'selectedCategoryId' => $selectedCategory?->id ?? $selectedCategoryId,
                'selectedCategory' => $selectedCategory,
            ]
        ));
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $this->validated($request);
        $data = collect($validated)->except(['sketch_image', 'color_image', 'sketches'])->all();

        if ($request->hasFile('sketch_image')) {
            $data['sketch_image_url'] = $this->storeUploadedFile(
                $request->file('sketch_image'),
                'game-types',
                'sketch_'
            );
        }

        if ($request->hasFile('color_image')) {
            $data['color_image_url'] = $this->storeUploadedFile(
                $request->file('color_image'),
                'game-types',
                'color_'
            );
        }

        $gameType = null;

        DB::transaction(function () use ($request, $data, &$gameType) {
            $gameType = GameType::query()->create($data);
            $this->syncSketches($gameType, $request->input('sketches', []), $request->file('sketches', []));
        });

        $parentGame = Game::query()->find($gameType?->game_id);

        return redirect()
            ->route(
                $parentGame ? 'admin.game-types.by-game' : 'admin.game-types.index',
                $parentGame ? ['game' => $parentGame] : []
            )
            ->with('success', 'Game created successfully.');
    }

    public function edit(GameType $gameType): View
    {
        $gameType->load('sketches');

        return view('screens.admin.game-types.edit', array_merge(
            $this->formOptions(),
            ['gameType' => $gameType]
        ));
    }

    public function update(Request $request, GameType $gameType): RedirectResponse
    {
        $validated = $this->validated($request, $gameType);
        $data = collect($validated)->except(['sketch_image', 'color_image', 'sketches'])->all();

        if ($request->hasFile('sketch_image')) {
            $this->deleteImageFile($gameType->sketch_image_url, 'game-types');
            $data['sketch_image_url'] = $this->storeUploadedFile(
                $request->file('sketch_image'),
                'game-types',
                'sketch_'
            );
        }

        if ($request->hasFile('color_image')) {
            $this->deleteImageFile($gameType->color_image_url, 'game-types');
            $data['color_image_url'] = $this->storeUploadedFile(
                $request->file('color_image'),
                'game-types',
                'color_'
            );
        }

        DB::transaction(function () use ($request, $gameType, $data) {
            $gameType->update($data);
            $this->syncSketches($gameType, $request->input('sketches', []), $request->file('sketches', []));
        });

        $parentGame = Game::query()->find($gameType->game_id);

        return redirect()
            ->route(
                $parentGame ? 'admin.game-types.by-game' : 'admin.game-types.index',
                $parentGame ? ['game' => $parentGame] : []
            )
            ->with('success', 'Game updated successfully.');
    }

    public function destroy(GameType $gameType): RedirectResponse
    {
        $parentGame = Game::query()->find($gameType->game_id);
        $gameType->load('sketches');

        foreach ($gameType->sketches as $sketch) {
            $this->deleteImageFile($sketch->image_url, 'game-type-sketches');
            $sketch->delete();
        }

        $this->deleteImageFile($gameType->sketch_image_url, 'game-types');
        $this->deleteImageFile($gameType->color_image_url, 'game-types');
        $gameType->delete();

        return redirect()
            ->route(
                $parentGame ? 'admin.game-types.by-game' : 'admin.game-types.index',
                $parentGame ? ['game' => $parentGame] : []
            )
            ->with('success', 'Game deleted successfully.');
    }

    private function formOptions(): array
    {
        $games = Game::query()
            ->where('status', 'active')
            ->orderBy('id')
            ->get();

        $yearsByGame = GameBookYear::query()
            ->whereIn('game_id', $games->pluck('id'))
            ->get(['game_id', 'year_id'])
            ->groupBy('game_id')
            ->map(fn ($rows) => $rows->pluck('year_id')->unique()->values()->all());

        $games->each(function (Game $game) use ($yearsByGame) {
            $game->setAttribute(
                'book_year_ids',
                $yearsByGame->get($game->id, [])
            );
        });

        return [
            'years' => Year::query()->where('status', 'active')->orderBy('id')->get(),
            'categories' => GameCategory::query()->where('status', 'active')->orderBy('id')->get(),
            'games' => $games,
            'gameBooks' => GameBook::query()
                ->with('book')
                ->whereIn('game_id', $games->pluck('id'))
                ->where('status', 'active')
                ->orderBy('id')
                ->get(),
        ];
    }

    private function validated(Request $request, ?GameType $gameType = null): array
    {
        return $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'game_category_id' => [
                'required',
                'integer',
                Rule::exists('game_categories', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'year_id' => [
                'required',
                'integer',
                Rule::exists('years', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
                Rule::exists('game_book_year', 'year_id')->where(function ($query) use ($request) {
                    $query->where('game_id', (int) $request->input('game_id'))
                        ->whereNull('deleted_at');
                }),
            ],
            'game_id' => [
                'required',
                'integer',
                Rule::exists('game', 'id')->where(function ($query) use ($request) {
                    $query->where('status', 'active')
                        ->whereNull('deleted_at')
                        ->where('game_category_id', (int) $request->input('game_category_id'));
                }),
            ],
            'book_id' => [
                'nullable',
                'integer',
                Rule::exists('game_books', 'book_id')->where(function ($query) use ($request) {
                    $query->where('game_id', (int) $request->input('game_id'))
                        ->where('year_id', (int) $request->input('year_id'))
                        ->where('status', 'active')
                        ->whereNull('deleted_at');
                }),
            ],
            'points' => ['required', 'integer', 'min:0', 'max:999999'],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'sketch_image' => [
                $gameType ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
            'color_image' => [
                'nullable',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
            'sketches' => ['nullable', 'array'],
            'sketches.*.id' => $gameType
                ? [
                    'nullable',
                    'integer',
                    Rule::exists('games_type_sketches', 'id')->where(function ($query) use ($gameType) {
                        $query->where('game_type_id', $gameType->id)->whereNull('deleted_at');
                    }),
                ]
                : ['prohibited'],
            'sketches.*.name' => ['required_with:sketches.*.image', 'nullable', 'string', 'max:255'],
            'sketches.*.image' => [
                'nullable',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ], [
            'year_id.exists' => 'Please select a year that was added for this game in Game Book & Year.',
        ]);
    }

    /**
     * @param  array<int, array<string, mixed>>  $sketchesInput
     * @param  array<int, array<string, UploadedFile|null>|UploadedFile|null>  $sketchFiles
     */
    private function syncSketches(GameType $gameType, array $sketchesInput, array $sketchFiles): void
    {
        $keptIds = [];

        foreach ($sketchesInput as $index => $sketchData) {
            $name = trim((string) ($sketchData['name'] ?? ''));
            $sketchId = isset($sketchData['id']) ? (int) $sketchData['id'] : null;
            $imageFile = data_get($sketchFiles, $index.'.image');

            if ($name === '' && ! $imageFile && ! $sketchId) {
                continue;
            }

            if ($name === '') {
                continue;
            }

            if ($sketchId) {
                $sketch = $gameType->sketches()->whereKey($sketchId)->first();
                if (! $sketch) {
                    continue;
                }

                $payload = [
                    'name' => $name,
                    'status' => 'active',
                ];

                if ($imageFile instanceof UploadedFile) {
                    $this->deleteImageFile($sketch->image_url, 'game-type-sketches');
                    $payload['image_url'] = $this->storeUploadedFile($imageFile, 'game-type-sketches', 'type_sketch_');
                }

                $sketch->update($payload);
                $keptIds[] = $sketch->id;

                continue;
            }

            if (! $imageFile instanceof UploadedFile) {
                continue;
            }

            $sketch = $gameType->sketches()->create([
                'name' => $name,
                'image_url' => $this->storeUploadedFile($imageFile, 'game-type-sketches', 'type_sketch_'),
                'status' => 'active',
            ]);

            $keptIds[] = $sketch->id;
        }

        $deleteQuery = $gameType->sketches();
        if (count($keptIds) > 0) {
            $deleteQuery->whereNotIn('id', $keptIds);
        }

        $deleteQuery->get()->each(function (GameTypeSketch $sketch) {
            $this->deleteImageFile($sketch->image_url, 'game-type-sketches');
            $sketch->delete();
        });
    }

    private function storeUploadedFile(UploadedFile $file, string $folder, string $prefix): string
    {
        $directory = public_path('assets/'.$folder);
        File::ensureDirectoryExists($directory);

        $filename = uniqid($prefix, true).'.'.$file->getClientOriginalExtension();
        $file->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename, string $folder): void
    {
        if (! $filename) {
            return;
        }

        $path = public_path('assets/'.$folder.'/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
