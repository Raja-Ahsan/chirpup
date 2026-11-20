<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreBookmarkRequest;
use App\Http\Requests\Api\UpdateBookmarkRequest;
use App\Http\Resources\BookmarkResource;
use App\Models\BookMark;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\File;

class BookmarkController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $records = BookMark::query()
            ->with(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage'])
            ->where('user_id', $request->user()->id)
            ->when($request->filled('child_id'), function ($query) use ($request) {
                $query->where('child_id', (int) $request->input('child_id'));
            })
            ->when($request->filled('year_id'), function ($query) use ($request) {
                $query->where('year_id', (int) $request->input('year_id'));
            })
            ->when($request->filled('category_id'), function ($query) use ($request) {
                $query->where('category_id', (int) $request->input('category_id'));
            })
            ->when($request->filled('game_category_id'), function ($query) use ($request) {
                $query->where('game_category_id', (int) $request->input('game_category_id'));
            })
            ->when($request->filled('sketche_id'), function ($query) use ($request) {
                $query->where('sketche_id', (int) $request->input('sketche_id'));
            })
            ->orderByDesc('play_date')
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Bookmarks fetched successfully.',
            'data' => BookmarkResource::collection($records),
        ], 200);
    }

    public function store(StoreBookmarkRequest $request): JsonResponse
    {
        $bookmark = BookMark::query()->create([
            'user_id' => $request->integer('user_id'),
            'child_id' => $request->integer('child_id'),
            'year_id' => $request->integer('year_id'),
            'category_id' => $request->filled('category_id') ? $request->integer('category_id') : null,
            'game_category_id' => $request->integer('game_category_id'),
            'sketche_id' => $request->integer('sketche_id'),
            'sketche_image_id' => $request->integer('sketche_image_id'),
            'sketch_complete_image_url' => $this->storeImage($request->file('sketch_complete_image_url')),
            'play_date' => $request->string('play_date')->toString(),
            'css_style_json' => $request->input('css_style_json'),
        ]);

        $bookmark->load(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage']);

        return response()->json([
            'success' => true,
            'message' => 'Bookmark added successfully.',
            'data' => new BookmarkResource($bookmark),
        ], 200);
    }

    public function update(UpdateBookmarkRequest $request, BookMark $bookmark): JsonResponse
    {
        if ($bookmark->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Bookmark not found.',
                'data' => null,
            ], 404);
        }

        $data = $request->only([
            'child_id',
            'year_id',
            'category_id',
            'game_category_id',
            'sketche_id',
            'sketche_image_id',
            'play_date',
            'css_style_json',
        ]);

        if ($request->hasFile('sketch_complete_image_url')) {
            $this->deleteImageFile($bookmark->sketch_complete_image_url);
            $data['sketch_complete_image_url'] = $this->storeImage(
                $request->file('sketch_complete_image_url')
            );
        }

        $bookmark->fill($data);
        $bookmark->save();
        $bookmark->load(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage']);

        return response()->json([
            'success' => true,
            'message' => 'Bookmark updated successfully.',
            'data' => new BookmarkResource($bookmark),
        ], 200);
    }

    public function destroy(Request $request, BookMark $bookmark): JsonResponse
    {
        if ($bookmark->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Bookmark not found.',
                'data' => null,
            ], 404);
        }

        $this->deleteImageFile($bookmark->sketch_complete_image_url);
        $bookmark->delete();

        return response()->json([
            'success' => true,
            'message' => 'Bookmark deleted successfully.',
            'data' => null,
        ], 200);
    }

    private function storeImage(UploadedFile $file): string
    {
        $directory = public_path('assets/book-mark');
        File::ensureDirectoryExists($directory);

        $filename = uniqid('bookmark_', true).'.'.$file->getClientOriginalExtension();
        $file->move($directory, $filename);

        return $filename;
    }

    private function deleteImageFile(?string $filename): void
    {
        if (! $filename) {
            return;
        }

        if (str_starts_with($filename, 'http://') || str_starts_with($filename, 'https://')) {
            return;
        }

        $path = public_path('assets/book-mark/'.$filename);
        if (File::exists($path)) {
            File::delete($path);
        }
    }
}
