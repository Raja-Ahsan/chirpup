<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\CompleteGameRequest;
use App\Http\Resources\GameCompleteResource;
use App\Models\GameComplete;
use App\Models\GameType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class CompleteGameController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $records = GameComplete::query()
            ->with(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage', 'mood'])
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
            ->when($request->filled('sketche_image_id'), function ($query) use ($request) {
                $query->where('sketche_image_id', (int) $request->input('sketche_image_id'));
            })
            ->when($request->filled('mood_id'), function ($query) use ($request) {
                $query->where('mood_id', (int) $request->input('mood_id'));
            })
            ->when($request->filled('play_date'), function ($query) use ($request) {
                $query->whereDate('play_date', $request->string('play_date')->toString());
            })
            ->orderByDesc('play_date')
            ->orderByDesc('id')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Game completes fetched successfully.',
            'data' => GameCompleteResource::collection($records),
        ], 200);
    }

    public function view(Request $request): JsonResponse
    {
        $request->validate([
            'sketche_id' => ['required', 'integer'],
            'sketche_image_id' => ['required', 'integer'],
            'child_id' => ['nullable', 'integer'],
        ]);

        $gameComplete = GameComplete::query()
            ->with(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage', 'mood'])
            ->where('user_id', $request->user()->id)
            ->where('sketche_id', (int) $request->input('sketche_id'))
            ->where('sketche_image_id', (int) $request->input('sketche_image_id'))
            ->when($request->filled('child_id'), function ($query) use ($request) {
                $query->where('child_id', (int) $request->input('child_id'));
            })
            ->orderByDesc('play_date')
            ->orderByDesc('id')
            ->first();

        if (! $gameComplete) {
            return response()->json([
                'success' => false,
                'message' => 'Game complete not found for the given sketche_id and sketche_image_id.',
                'data' => null,
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Game complete fetched successfully.',
            'data' => new GameCompleteResource($gameComplete),
        ], 200);
    }

    public function show(Request $request, GameComplete $gameComplete): JsonResponse
    {
        if ($gameComplete->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Game complete not found.',
                'data' => null,
            ], 404);
        }

        $gameComplete->load(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage', 'mood']);

        return response()->json([
            'success' => true,
            'message' => 'Game complete fetched successfully.',
            'data' => new GameCompleteResource($gameComplete),
        ], 200);
    }

    public function store(CompleteGameRequest $request): JsonResponse
    {
        $existing = GameComplete::query()
            ->where('user_id', $request->integer('user_id'))
            ->where('child_id', $request->integer('child_id'))
            ->where('sketche_id', $request->integer('sketche_id'))
            ->where('sketche_image_id', $request->integer('sketche_image_id'))
            ->first();

        if ($existing) {
            $this->deleteCompletedImage($existing->sketch_complete_image_url);

            $existing->update([
                'sketch_complete_image_url' => $this->storeCompletedImage(
                    $request->file('sketch_complete_image_url')
                ),
            ]);

            $existing->load(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage', 'mood']);

            return response()->json([
                'success' => true,
                'message' => 'Game complete image updated successfully.',
                'is_update' => true,
                'data' => new GameCompleteResource($existing),
            ], 200);
        }

        $gameType = GameType::query()
            ->whereKey($request->integer('sketche_id'))
            ->firstOrFail();

        $points = (int) ($gameType->points ?? 0);
        $starsRating = $this->calculateStars($points);

        $gameComplete = GameComplete::query()->create([
            'user_id' => $request->integer('user_id'),
            'child_id' => $request->integer('child_id'),
            'year_id' => $request->integer('year_id'),
            'category_id' => $request->filled('category_id') ? $request->integer('category_id') : null,
            'game_category_id' => $request->integer('game_category_id'),
            'sketche_id' => $gameType->id,
            'sketche_image_id' => $request->integer('sketche_image_id'),
            'sketch_complete_image_url' => $this->storeCompletedImage(
                $request->file('sketch_complete_image_url')
            ),
            'stars_rating' => $starsRating,
            'points' => $points,
            'mood_id' => $request->integer('mood_id'),
            'play_date' => $request->string('play_date')->toString(),
            'css_style_json' => $request->input('css_style_json'),
        ]);

        $gameComplete->load(['user', 'child', 'year', 'gameCategory', 'gameType', 'sketchImage', 'mood']);

        return response()->json([
            'success' => true,
            'message' => 'Game completed successfully.',
            'is_update' => false,
            'data' => new GameCompleteResource($gameComplete),
        ], 200);
    }

    private function calculateStars(int $points): int
    {
        if ($points <= 0) {
            return 0;
        }

        return min(5, max(1, $points));
    }

    private function storeCompletedImage(UploadedFile $file): string
    {
        return $file->store('game-complete', 'public');
    }

    private function deleteCompletedImage(?string $path): void
    {
        if (! $path) {
            return;
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return;
        }

        // New storage path: game-complete/filename.ext
        if (str_contains($path, '/') && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);

            return;
        }

        // Legacy assets path fallback.
        $legacy = public_path('assets/game-complete/'.$path);
        if (is_file($legacy)) {
            @unlink($legacy);
        }
    }
}
