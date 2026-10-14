<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCollection;
use App\Models\Game;
use Illuminate\Http\Request;

class StartGameController extends Controller
{
    public function __invoke(Request $request): GameCollection
    {
        $categoryId = $request->input('game_category_id');
        $yearId = $request->input('year_id');
        $bookId = $request->input('book_id');

        $games = Game::query()
            ->with([
                'gameCategory',
                'gameBooks' => function ($query) use ($yearId, $bookId) {
                    $query->where('status', 'active')
                        ->when($yearId !== null && $yearId !== '', function ($q) use ($yearId) {
                            $q->where('year_id', (int) $yearId);
                        })
                        ->when($bookId !== null && $bookId !== '', function ($q) use ($bookId) {
                            $q->where('book_id', (int) $bookId);
                        })
                        ->with(['book' => function ($bookQuery) {
                            $bookQuery->where('status', 'active');
                        }])
                        ->orderBy('id');
                },
                'gameTypes' => function ($query) use ($categoryId, $yearId, $bookId) {
                    $query->where('status', 'active')
                        ->when($categoryId !== null && $categoryId !== '', function ($q) use ($categoryId) {
                            $q->where('game_category_id', (int) $categoryId);
                        })
                        ->when($yearId !== null && $yearId !== '', function ($q) use ($yearId) {
                            $q->where('year_id', (int) $yearId);
                        })
                        ->when($bookId !== null && $bookId !== '', function ($q) use ($bookId) {
                            $q->where('book_id', (int) $bookId);
                        })
                        ->with(['sketches' => function ($sketchQuery) {
                            $sketchQuery->where('status', 'active')->orderBy('id');
                        }])
                        ->orderBy('id');
                },
            ])
            ->where('status', 'active')
            ->when($categoryId !== null && $categoryId !== '', function ($query) use ($categoryId) {
                $query->where('game_category_id', (int) $categoryId);
            })
            ->whereHas('gameTypes', function ($query) use ($categoryId, $yearId, $bookId) {
                $query->where('status', 'active')
                    ->when($categoryId !== null && $categoryId !== '', function ($q) use ($categoryId) {
                        $q->where('game_category_id', (int) $categoryId);
                    })
                    ->when($yearId !== null && $yearId !== '', function ($q) use ($yearId) {
                        $q->where('year_id', (int) $yearId);
                    })
                    ->when($bookId !== null && $bookId !== '', function ($q) use ($bookId) {
                        $q->where('book_id', (int) $bookId);
                    })
                    ->whereHas('sketches', function ($sketchQuery) {
                        $sketchQuery->where('status', 'active');
                    });
            })
            ->orderBy('id')
            ->get();

        return new GameCollection($games);
    }
}
