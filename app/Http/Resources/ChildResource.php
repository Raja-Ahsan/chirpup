<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ChildResource extends JsonResource
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
            'name' => $this->name,
            'slug' => $this->slug,
            'year_id' => $this->year_id,
            'character_id' => $this->character_id,
            'today_mood' => $this->today_mood,
            'mood_date' => optional($this->mood_date)?->format('Y-m-d'),
            'mood' => filled($this->mood_date) && $this->mood_date->isToday(),
            'level' => 0,
            'progressPercent' => 0,
            'status' => $this->status,
            'user' => $this->whenLoaded('user', function () {
                return new UserResource($this->user);
            }),
            'year' => $this->whenLoaded('year', function () {
                return new YearResource($this->year);
            }),
            'character' => $this->whenLoaded('character', function () {
                return new CharacterResource($this->character);
            }),
            'todayMood' => $this->whenLoaded('todayMood', function () {
                return new GameMoodResource($this->todayMood);
            }),
        ];
    }
}
