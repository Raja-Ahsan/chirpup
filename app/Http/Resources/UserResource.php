<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'email' => $this->email,
            'role' => $this->role,
            'hasPin' => filled($this->user_pin),
            'email_verified_at' => $this->email_verified_at,
            'total_children_profiles' => $this->relationLoaded('children')
                ? $this->children->count()
                : ($this->children_count ?? $this->children()->count()),
            'children' => ChildResource::collection($this->whenLoaded('children')),
        ];
    }
}
