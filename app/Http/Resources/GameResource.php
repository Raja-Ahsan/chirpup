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
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'year_id' => $this->year_id,
            'game_category_id' => $this->game_category_id,
            'image_url' => $this->image_path,
            'cover_book_image' => $this->cover_book_image_path,
            'description' => $this->description,
            'status' => $this->status,
            'year' => new YearResource($this->whenLoaded('year')),
            'category' => new GameCategoryResource($this->whenLoaded('gameCategory')),
        ];
    }
}
