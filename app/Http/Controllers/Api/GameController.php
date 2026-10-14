<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCollection;
use App\Http\Resources\GameResource;
use App\Models\Game;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GameController extends Controller
{
    public function index(Request $request): GameCollection
    {
        $categoryId = $request->input('game_category_id');

        $games = Game::query()
            ->with('gameCategory')
            ->where('status', 'active')
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->orderBy('id')
            ->get();

        return new GameCollection($games);
    }

    public function show(Game $game): JsonResponse
    {
        if ($game->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Game not found.',
                'data' => null,
            ], 404);
        }

        $game->load('gameCategory');

        return response()->json([
            'success' => true,
            'message' => 'Game fetched successfully.',
            'data' => [
                'game' => new GameResource($game),
            ],
        ]);
    }
}
