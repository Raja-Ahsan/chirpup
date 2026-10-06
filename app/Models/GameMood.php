<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class GameMood extends Model
{
    use SoftDeletes;

    protected $table = 'game_mood';

    protected $fillable = [
        'name',
        'slug',
        'image_url',
        'description',
        'status',
    ];

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    protected static function booted(): void
    {
        static::creating(function (GameMood $mood) {
            if (blank($mood->slug)) {
                $mood->slug = static::uniqueSlug($mood->name);
            }
        });

        static::updating(function (GameMood $mood) {
            if ($mood->isDirty('name')) {
                $mood->slug = static::uniqueSlug($mood->name, $mood->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'mood';
        $slug = $base;
        $counter = 2;

        while (
            static::withTrashed()
                ->where('slug', $slug)
                ->when($ignoreId, fn ($query) => $query->where('id', '!=', $ignoreId))
                ->exists()
        ) {
            $slug = "{$base}-{$counter}";
            $counter++;
        }

        return $slug;
    }

    protected function imagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->image_url) {
                return null;
            }

            return asset('assets/game-moods/'.$this->image_url);
        });
    }

    public function categories(): BelongsToMany
    {
        return $this->belongsToMany(GameCategory::class, 'game_categories_mood', 'mood_id', 'game_category_id')
            ->withPivot(['id', 'status'])
            ->withTimestamps()
            ->wherePivotNull('deleted_at');
    }
}
