<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GameResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $yearId = $request->input('year_id');
        $bookId = $request->input('book_id');

        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'game_category_id' => $this->game_category_id,
            'image_url' => $this->image_path,
            'description' => $this->description,
            'status' => $this->status,
            'is_book' => false,
            'category' => new GameCategoryResource($this->whenLoaded('gameCategory')),
            'books' => $this->when(
                $this->relationLoaded('gameBooks'),
                function () use ($yearId, $bookId) {
                    $books = $this->gameBooks;

                    if ($yearId !== null && $yearId !== '') {
                        $books = $books->where('year_id', (int) $yearId);
                    }

                    if ($bookId !== null && $bookId !== '') {
                        $books = $books->where('book_id', (int) $bookId);
                    }

                    return $books
                        ->pluck('book')
                        ->filter()
                        ->unique('id')
                        ->values()
                        ->map(fn ($book) => [
                            'id' => $book->id,
                            'name' => $book->title,
                            'slug' => $book->slug,
                            'game_category_id' => $this->game_category_id,
                            'image_url' => $book->image_path,
                            'description' => $book->description,
                            'status' => $book->status,
                            'is_book' => true,
                            'category' => $this->relationLoaded('gameCategory')
                                ? (new GameCategoryResource($this->gameCategory))->resolve()
                                : null,
                        ]);
                }
            ),
            'sketches' => $this->when(
                $this->relationLoaded('gameTypes'),
                function () use ($request, $yearId, $bookId) {
                    $categoryId = $request->input('game_category_id');
                    $gameTypes = $this->gameTypes;

                    if ($categoryId !== null && $categoryId !== '') {
                        $gameTypes = $gameTypes->where('game_category_id', (int) $categoryId);
                    }

                    if ($yearId !== null && $yearId !== '') {
                        $gameTypes = $gameTypes->where('year_id', (int) $yearId);
                    }

                    if ($bookId !== null && $bookId !== '') {
                        $gameTypes = $gameTypes->where('book_id', (int) $bookId);
                    }

                    return $gameTypes->values()->map(fn ($gameType) => [
                        'id' => $gameType->id,
                        'name' => $gameType->name,
                        'slug' => $gameType->slug,
                        'game_category_id' => $gameType->game_category_id,
                        'year_id' => $gameType->year_id,
                        'book_id' => $gameType->book_id,
                        'game_id' => $gameType->game_id,
                        'points' => $gameType->points,
                        'image_url' => $gameType->sketch_image_path,
                        'sketch_image_url' => $gameType->sketch_image_path,
                        'color_image_url' => $gameType->color_image_path,
                        'description' => $gameType->description,
                        'status' => $gameType->status,
                        'sketches' => GameTypeSketchResource::collection(
                            $gameType->relationLoaded('sketches')
                                ? $gameType->sketches
                                : collect()
                        ),
                    ]);
                }
            ),
        ];
    }
}
