<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCategoryCollection;
use App\Http\Resources\GameCategoryResource;
use App\Models\GameCategory;
use Illuminate\Http\JsonResponse;

class GameCategoryController extends Controller
{
    public function index(): GameCategoryCollection
    {
        $categories = GameCategory::query()
            ->with(['moods' => function ($query) {
                $query->where('game_mood.status', 'active')
                    ->wherePivot('status', 'active');
            }])
            ->where('status', 'active')
            ->orderBy('id')
            ->get();

        return new GameCategoryCollection($categories);
    }

    public function show(GameCategory $gameCategory): JsonResponse
    {
        if ($gameCategory->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Game category not found.',
                'data' => null,
            ], 404);
        }

        $gameCategory->load(['moods' => function ($query) {
            $query->where('game_mood.status', 'active')
                ->wherePivot('status', 'active');
        }]);

        return response()->json([
            'success' => true,
            'message' => 'Game category fetched successfully.',
            'data' => [
                'category' => new GameCategoryResource($gameCategory),
            ],
        ]);
    }
}
