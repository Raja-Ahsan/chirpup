<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ChildMoodResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'mood_date' => optional($this->mood_date)?->format('Y-m-d'),
            'mood' => $this->whenLoaded('mood', function () {
                return new GameMoodResource($this->mood);
            }),
        ];
    }
}
