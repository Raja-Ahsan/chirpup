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
            'year_id' => $this->year_id,
            'game_id' => $this->game_id,
            'points' => $this->points,
            'sketch_image_url' => $this->sketch_image_path,
            'color_image_url' => $this->color_image_path,
            'description' => $this->description,
            'status' => $this->status,
            'year' => new YearResource($this->whenLoaded('year')),
            'category' => new GameCategoryResource($this->whenLoaded('gameCategory')),
            'game' => new GameResource($this->whenLoaded('game')),
            'sketches' => GameTypeSketchResource::collection($this->whenLoaded('sketches')),
        ];
    }
}
