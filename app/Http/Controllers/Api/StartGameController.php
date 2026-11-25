<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\GameCollection;
use App\Models\Game;
use App\Models\GameComplete;
use Illuminate\Http\Request;

class StartGameController extends Controller
{
    public function __invoke(Request $request): GameCollection
    {
        $categoryId = $request->input('game_category_id');
        $yearId = $request->input('year_id');
        $bookId = $request->input('book_id');

        $playedSketches = $this->playedSketches($request);
        $request->attributes->set('played_sketches', $playedSketches);

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

    /**
     * @return array<int, string|null> sketche_image_id => sketch_complete_image_url
     */
    private function playedSketches(Request $request): array
    {
        $user = $request->user('sanctum');

        if (! $user) {
            return [];
        }

        return GameComplete::query()
            ->where('user_id', $user->id)
            ->when($request->filled('child_id'), function ($query) use ($request) {
                $query->where('child_id', (int) $request->input('child_id'));
            })
            ->whereNotNull('sketche_image_id')
            ->orderByDesc('play_date')
            ->orderByDesc('id')
            ->get(['sketche_image_id', 'sketch_complete_image_url'])
            ->unique('sketche_image_id')
            ->mapWithKeys(fn (GameComplete $complete) => [
                (int) $complete->sketche_image_id => $complete->sketch_complete_image_path,
            ])
            ->all();
    }
}
