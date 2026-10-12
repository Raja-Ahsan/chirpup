<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameTypeCollection;
use App\Http\Resources\GameTypeResource;
use App\Models\GameType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GameTypeController extends Controller
{
    public function index(Request $request): GameTypeCollection
    {
        $yearId = $request->input('year_id');
        $categoryId = $request->input('game_category_id');
        $gameId = $request->input('game_id');

        $gameTypes = GameType::query()
            ->with([
                'year',
                'gameCategory',
                'game',
                'sketches' => function ($query) {
                    $query->where('status', 'active')->orderBy('id');
                },
            ])
            ->where('status', 'active')
            ->when($yearId !== null && $yearId !== '', function ($query) use ($yearId) {
                $query->where('year_id', (int) $yearId);
            })
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->when($gameId !== null && $gameId !== '', function ($query) use ($gameId) {
                $query->where('game_id', (int) $gameId);
            })
            ->orderBy('id')
            ->get();

        return new GameTypeCollection($gameTypes);
    }

    public function show(GameType $gameType): JsonResponse
    {
        if ($gameType->status !== 'active') {
            return response()->json([
                'success' => false,
                'message' => 'Game type not found.',
                'data' => null,
            ], 404);
        }

        $gameType->load([
            'year',
            'gameCategory',
            'game',
            'sketches' => function ($query) {
                $query->where('status', 'active')->orderBy('id');
            },
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Game type fetched successfully.',
            'data' => [
                'game_type' => new GameTypeResource($gameType),
            ],
        ]);
    }
}
