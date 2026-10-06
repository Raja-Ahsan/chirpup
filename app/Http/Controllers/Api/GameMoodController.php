<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCategoryResource;
use App\Http\Resources\GameMoodCollection;
use App\Http\Resources\GameMoodResource;
use App\Models\GameMood;
use Illuminate\Http\JsonResponse;

class GameMoodController extends Controller
{
    public function index(): GameMoodCollection
    {
        $moods = GameMood::query()
            ->where('status', 'active')
            ->orderBy('id')
            ->get();

        return new GameMoodCollection($moods);
    }

    public function show(GameMood $mood): JsonResponse
    {
        if ($mood->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Mood not found.',
                'data' => null,
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Mood fetched successfully.',
            'data' => [
                'mood' => new GameMoodResource($mood),
            ],
        ]);
    }

    public function categories(GameMood $mood): JsonResponse
    {
        if ($mood->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Mood not found.',
                'data' => null,
            ], 404);
        }

        $categories = $mood->categories()
            ->where('game_categories.status', 'active')
            ->wherePivot('status', 'active')
            ->orderBy('game_categories.id')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Categories fetched successfully for this mood.',
            'data' => [
                'mood' => new GameMoodResource($mood),
                'categories' => GameCategoryResource::collection($categories),
            ],
        ]);
    }
}
