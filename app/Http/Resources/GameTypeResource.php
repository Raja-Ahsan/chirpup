<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GameTypeResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'game_category_id' => $this->game_category_id,
            'image_url' => $this->sketch_image_path,
            'description' => $this->description,
            'status' => $this->status,
            'is_book' => false,
            'category' => new GameCategoryResource($this->whenLoaded('gameCategory')),
            'books' => $this->when(
                $this->relationLoaded('gameBooks'),
                fn () => $this->gameBooks
                    ->where('year_id', $this->year_id)
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
                    ])
            ),
        ];
    }
}
