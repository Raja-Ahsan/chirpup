<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GameTypeSketchResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $playedSketches = $request->attributes->get('played_sketches', []);
        $sketchId = (int) $this->id;
        $isPlay = array_key_exists($sketchId, $playedSketches);

        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'game_type_id' => $this->game_type_id,
            'image_url' => $this->image_path,
            'status' => $this->status,
            'is_play' => $isPlay,
            'sketch_complete_image_url' => $isPlay ? ($playedSketches[$sketchId] ?? null) : null,
        ];
    }
}
