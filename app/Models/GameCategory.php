<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class GameCategory extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'title',
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
        static::creating(function (GameCategory $category) {
            if (blank($category->slug)) {
                $category->slug = static::uniqueSlug($category->title);
            }
        });

        static::updating(function (GameCategory $category) {
            if ($category->isDirty('title')) {
                $category->slug = static::uniqueSlug($category->title, $category->id);
            }
        });

        static::saved(function (GameCategory $category) {
            \App\Services\GameCategorySidebarSync::sync($category);
        });

        static::deleted(function (GameCategory $category) {
            \App\Services\GameCategorySidebarSync::remove($category);
        });

        static::restored(function (GameCategory $category) {
            \App\Services\GameCategorySidebarSync::sync($category);
        });
    }

    public static function uniqueSlug(string $title, ?int $ignoreId = null): string
    {
        $base = Str::slug($title) ?: 'category';
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

            return asset('assets/game-categories/'.$this->image_url);
        });
    }

    public function categoryMoods(): HasMany
    {
        return $this->hasMany(GameCategoryMood::class);
    }

    public function games(): HasMany
    {
        return $this->hasMany(Game::class);
    }

    public function moods(): BelongsToMany
    {
        return $this->belongsToMany(GameMood::class, 'game_categories_mood', 'game_category_id', 'mood_id')
            ->withPivot(['id', 'status'])
            ->withTimestamps()
            ->wherePivotNull('deleted_at');
    }

    public function syncMoods(array $moodIds, string $status = 'active'): void
    {
        $moodIds = collect($moodIds)
            ->filter()
            ->map(fn ($id) => (int) $id)
            ->unique()
            ->values();

        $existing = $this->categoryMoods()->withTrashed()->get()->keyBy('mood_id');

        foreach ($existing as $moodId => $row) {
            if (! $moodIds->contains($moodId)) {
                if (! $row->trashed()) {
                    $row->delete();
                }
            }
        }

        foreach ($moodIds as $moodId) {
            $row = $existing->get($moodId);

            if ($row) {
                if ($row->trashed()) {
                    $row->restore();
                }
                $row->forceFill(['status' => $status])->save();
            } else {
                $this->categoryMoods()->create([
                    'mood_id' => $moodId,
                    'status' => $status,
                ]);
            }
        }
    }
}
