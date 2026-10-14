<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Book;
use App\Models\Game;
use App\Models\GameBook;
use App\Models\GameBookYear;
use App\Models\GameCategory;
use App\Models\Year;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Validation\Rule;
use Illuminate\View\View;

class GameBookYearController extends Controller
{
    private const ALLOWED_CATEGORY_SLUG = 'creative';

    public function index(Request $request, GameCategory $gameCategory): View
    {
        $this->ensureCreativeCategory($gameCategory);

        $search = trim((string) $request->query('q', ''));

        $items = GameBookYear::query()
            ->with(['game', 'year'])
            ->whereHas('game', fn ($query) => $query->where('game_category_id', $gameCategory->id))
            ->when($search !== '', function ($query) use ($search) {
                $query->where(function ($inner) use ($search) {
                    $inner->whereHas('game', fn ($q) => $q->where('name', 'like', "%{$search}%"))
                        ->orWhereHas('year', fn ($q) => $q->where('title', 'like', "%{$search}%"))
                        ->orWhereExists(function ($exists) use ($search) {
                            $exists->selectRaw('1')
                                ->from('game_books')
                                ->join('books', 'books.id', '=', 'game_books.book_id')
                                ->whereColumn('game_books.game_id', 'game_book_year.game_id')
                                ->whereColumn('game_books.year_id', 'game_book_year.year_id')
                                ->whereNull('game_books.deleted_at')
                                ->where('books.title', 'like', "%{$search}%");
                        });
                });
            })
            ->orderByDesc('id')
            ->paginate(12)
            ->withQueryString();

        $items->getCollection()->transform(function (GameBookYear $item) {
            $item->setRelation(
                'relatedBooks',
                GameBook::query()
                    ->with('book')
                    ->where('game_id', $item->game_id)
                    ->where('year_id', $item->year_id)
                    ->orderBy('id')
                    ->get()
            );

            return $item;
        });

        return view('screens.admin.game-book-years.index', [
            'category' => $gameCategory,
            'items' => $items,
            'search' => $search,
        ]);
    }

    public function create(GameCategory $gameCategory): View
    {
        $this->ensureCreativeCategory($gameCategory);

        return view('screens.admin.game-book-years.create', array_merge(
            $this->formData($gameCategory),
            ['selectedBookIds' => array_map('intval', (array) old('book_ids', []))]
        ));
    }

    public function store(Request $request, GameCategory $gameCategory): RedirectResponse
    {
        $this->ensureCreativeCategory($gameCategory);

        $validated = $this->validated($request, $gameCategory);
        $bookIds = collect($validated['book_ids'] ?? [])->map(fn ($id) => (int) $id)->unique()->values()->all();
        unset($validated['book_ids'], $validated['image']);

        if ($request->hasFile('image')) {
            $validated['image_url'] = $this->storeImage($request);
        }

        DB::transaction(function () use ($validated, $bookIds) {
            $item = GameBookYear::withTrashed()->updateOrCreate(
                [
                    'game_id' => $validated['game_id'],
                    'year_id' => $validated['year_id'],
                ],
                [
                    'image_url' => $validated['image_url'] ?? null,
                    'description' => $validated['description'] ?? null,
                    'status' => $validated['status'],
                ]
            );

            if ($item->trashed()) {
                $item->restore();
            }

            $this->syncBooks($item, $bookIds, $validated['status']);
        });

        return redirect()
            ->route('admin.game-book-years.index', $gameCategory)
            ->with('success', 'Game Book & Year created successfully.');
    }

    public function edit(GameCategory $gameCategory, GameBookYear $gameBookYear): View
    {
        $this->ensureCreativeCategory($gameCategory);
        $this->ensureBelongsToCategory($gameCategory, $gameBookYear);

        $selectedBookIds = GameBook::query()
            ->where('game_id', $gameBookYear->game_id)
            ->where('year_id', $gameBookYear->year_id)
            ->pluck('book_id')
            ->all();

        return view('screens.admin.game-book-years.edit', array_merge(
            $this->formData($gameCategory),
            [
                'item' => $gameBookYear,
                'selectedBookIds' => array_map(
                    'intval',
                    (array) old('book_ids', $selectedBookIds)
                ),
            ]
        ));
    }

    public function update(Request $request, GameCategory $gameCategory, GameBookYear $gameBookYear): RedirectResponse
    {
        $this->ensureCreativeCategory($gameCategory);
        $this->ensureBelongsToCategory($gameCategory, $gameBookYear);

        $validated = $this->validated($request, $gameCategory, $gameBookYear);
        $bookIds = collect($validated['book_ids'] ?? [])->map(fn ($id) => (int) $id)->unique()->values()->all();
        unset($validated['book_ids'], $validated['image']);

        if ($request->hasFile('image')) {
            $this->deleteImageFile($gameBookYear->image_url);
            $validated['image_url'] = $this->storeImage($request);
        }

        $oldGameId = $gameBookYear->game_id;
        $oldYearId = $gameBookYear->year_id;

        DB::transaction(function () use ($gameBookYear, $validated, $bookIds, $oldGameId, $oldYearId) {
            $gameBookYear->update($validated);

            if (
                (int) $oldGameId !== (int) $validated['game_id']
                || (int) $oldYearId !== (int) $validated['year_id']
            ) {
                GameBook::query()
                    ->where('game_id', $oldGameId)
                    ->where('year_id', $oldYearId)
                    ->get()
                    ->each(fn (GameBook $row) => $row->delete());
            }

            $this->syncBooks($gameBookYear->fresh(), $bookIds, $validated['status']);
        });

        return redirect()
            ->route('admin.game-book-years.index', $gameCategory)
            ->with('success', 'Game Book & Year updated successfully.');
    }

    public function destroy(GameCategory $gameCategory, GameBookYear $gameBookYear): RedirectResponse
    {
        $this->ensureCreativeCategory($gameCategory);
        $this->ensureBelongsToCategory($gameCategory, $gameBookYear);

        DB::transaction(function () use ($gameBookYear) {
            GameBook::query()
                ->where('game_id', $gameBookYear->game_id)
                ->where('year_id', $gameBookYear->year_id)
                ->get()
                ->each(fn (GameBook $row) => $row->delete());

            $this->deleteImageFile($gameBookYear->image_url);
            $gameBookYear->delete();
        });

        return redirect()
            ->route('admin.game-book-years.index', $gameCategory)
            ->with('success', 'Game Book & Year deleted successfully.');
    }

    private function syncBooks(GameBookYear $item, array $bookIds, string $status): void
    {
        $bookIds = collect($bookIds)->map(fn ($id) => (int) $id)->unique()->values();

        $existing = GameBook::withTrashed()
            ->where('game_id', $item->game_id)
            ->where('year_id', $item->year_id)
            ->get()
            ->keyBy('book_id');

        foreach ($bookIds as $bookId) {
            $row = $existing->get($bookId);

            if ($row) {
                if ($row->trashed()) {
                    $row->restore();
                }
                $row->forceFill(['status' => $status])->save();
            } else {
                GameBook::query()->create([
                    'game_id' => $item->game_id,
                    'year_id' => $item->year_id,
                    'book_id' => $bookId,
                    'status' => $status,
                ]);
            }
        }

        foreach ($existing as $bookId => $row) {
            if (! $bookIds->contains($bookId) && ! $row->trashed()) {
                $row->delete();
            }
        }
    }

    private function formData(GameCategory $gameCategory): array
    {
        return [
            'category' => $gameCategory,
            'games' => Game::query()
                ->where('game_category_id', $gameCategory->id)
                ->where('status', 'active')
                ->orderBy('name')
                ->get(),
            'books' => Book::query()->where('status', 'active')->orderBy('title')->get(),
            'years' => Year::query()->where('status', 'active')->orderBy('id')->get(),
        ];
    }

    private function validated(Request $request, GameCategory $gameCategory, ?GameBookYear $item = null): array
    {
        return $request->validate([
            'game_id' => [
                'required',
                'integer',
                Rule::exists('game', 'id')->where(function ($query) use ($gameCategory) {
                    $query->where('game_category_id', $gameCategory->id)
                        ->where('status', 'active')
                        ->whereNull('deleted_at');
                }),
                Rule::unique('game_book_year', 'game_id')
                    ->where(fn ($query) => $query
                        ->where('year_id', (int) $request->input('year_id'))
                        ->whereNull('deleted_at'))
                    ->ignore($item?->id),
            ],
            'year_id' => [
                'required',
                'integer',
                Rule::exists('years', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'book_ids' => ['nullable', 'array'],
            'book_ids.*' => [
                'integer',
                Rule::exists('books', 'id')->where(function ($query) {
                    $query->where('status', 'active')->whereNull('deleted_at');
                }),
            ],
            'description' => ['nullable', 'string', 'max:10000'],
            'status' => ['required', 'string', Rule::in(['active', 'inactive'])],
            'image' => [
                $item ? 'nullable' : 'required',
                'image',
                'mimes:png,jpg,jpeg,webp',
                'max:4096',
            ],
        ], [
            'game_id.required' => 'Please select a game.',
            'game_id.unique' => 'This game and year combination already exists.',
            'year_id.required' => 'Please select a year.',
            'image.required' => 'Please upload an image.',
        ]);
    }

    private function storeImage(Request $request): string
    {
        $directory = public_path('assets/game-book-years');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('gby_', true).'.'.$request->file('image')->getClientOriginalExtension();
        $request->file('image')->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        $path = public_path('assets/game-book-years/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }

    private function ensureCreativeCategory(GameCategory $gameCategory): void
    {
        abort_unless($gameCategory->slug === self::ALLOWED_CATEGORY_SLUG, 404);
    }

    private function ensureBelongsToCategory(GameCategory $gameCategory, GameBookYear $gameBookYear): void
    {
        $gameBookYear->loadMissing('game');

        abort_unless(
            (int) $gameBookYear->game?->game_category_id === (int) $gameCategory->id,
            404
        );
    }
}
