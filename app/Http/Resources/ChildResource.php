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
        $todayMoodEntry = $this->relationLoaded('todayMoodEntry') ? $this->todayMoodEntry : null;

        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'name' => $this->name,
            'slug' => $this->slug,
            'year_id' => $this->year_id,
            'character_id' => $this->character_id,
            'today_mood' => $todayMoodEntry?->mood_id,
            'mood_date' => optional($todayMoodEntry?->mood_date)?->format('Y-m-d'),
            'mood' => filled($todayMoodEntry),
            'progress' => [
                'stars' => 0,
                'coins' => 0,
                'progress_percent' => 0,
            ],
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
            'weekly_mood' => ChildMoodResource::collection($this->whenLoaded('weekMoods')),
        ];
    }
}
