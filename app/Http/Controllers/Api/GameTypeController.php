<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCollection;
use App\Http\Resources\GameTypeResource;
use App\Models\Game;
use App\Models\GameType;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GameTypeController extends Controller
{
    public function index(Request $request): GameCollection
    {
        $yearId = $request->input('year_id');
        $categoryId = $request->input('game_category_id');

        $games = Game::query()
            ->with([
                'gameCategory',
                'gameBooks' => function ($query) use ($yearId) {
                    $query->where('status', 'active')
                        ->when($yearId !== null && $yearId !== '', function ($q) use ($yearId) {
                            $q->where('year_id', (int) $yearId);
                        })
                        ->with(['book' => function ($bookQuery) {
                            $bookQuery->where('status', 'active');
                        }])
                        ->orderBy('id');
                },
            ])
            ->where('status', 'active')
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->when($yearId !== null && $yearId !== '', function ($query) use ($yearId) {
                $query->where(function ($q) use ($yearId) {
                    $q->whereHas('gameTypes', function ($sub) use ($yearId) {
                        $sub->where('year_id', (int) $yearId)->where('status', 'active');
                    })->orWhereHas('gameBookYears', function ($sub) use ($yearId) {
                        $sub->where('year_id', (int) $yearId)->where('status', 'active');
                    });
                });
            })
            ->orderBy('id')
            ->get();

        return new GameCollection($games);
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
            'gameBooks' => function ($query) {
                $query->where('status', 'active')
                    ->with(['book' => function ($bookQuery) {
                        $bookQuery->where('status', 'active');
                    }])
                    ->orderBy('id');
            },
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
