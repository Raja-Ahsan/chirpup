<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BookmarkResource extends JsonResource
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
            'user_id' => $this->user_id,
            'child_id' => $this->child_id,
            'year_id' => $this->year_id,
            'category_id' => $this->category_id,
            'game_category_id' => $this->game_category_id,
            'sketche_id' => $this->sketche_id,
            'sketche_image_id' => $this->sketche_image_id,
            'sketch_complete_image_url' => $this->sketch_complete_image_path,
            'play_date' => optional($this->play_date)?->format('Y-m-d'),
            'css_style_json' => $this->css_style_json,
            'user' => $this->whenLoaded('user', fn () => new UserResource($this->user)),
            'child' => $this->whenLoaded('child', fn () => new ChildResource($this->child)),
            'year' => $this->whenLoaded('year', fn () => new YearResource($this->year)),
            'game_category' => $this->whenLoaded('gameCategory', fn () => new GameCategoryResource($this->gameCategory)),
            'game_type' => $this->whenLoaded('gameType', fn () => new GameTypeResource($this->gameType)),
            'sketch' => $this->whenLoaded('sketchImage', fn () => new GameTypeSketchResource($this->sketchImage)),
        ];
    }
}
