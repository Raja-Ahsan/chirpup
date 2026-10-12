<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class Game extends Model
{
    use SoftDeletes;

    protected $table = 'game';

    protected $fillable = [
        'name',
        'slug',
        'year_id',
        'game_category_id',
        'image_url',
        'cover_book_image',
        'description',
        'status',
    ];

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    protected static function booted(): void
    {
        static::creating(function (Game $game) {
            if (blank($game->slug)) {
                $game->slug = static::uniqueSlug($game->name);
            }
        });

        static::updating(function (Game $game) {
            if ($game->isDirty('name')) {
                $game->slug = static::uniqueSlug($game->name, $game->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'game';
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

            return asset('assets/games/'.$this->image_url);
        });
    }

    protected function coverBookImagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->cover_book_image) {
                return null;
            }

            return asset('assets/games/'.$this->cover_book_image);
        });
    }

    public function year(): BelongsTo
    {
        return $this->belongsTo(Year::class);
    }

    public function gameCategory(): BelongsTo
    {
        return $this->belongsTo(GameCategory::class);
    }

    public function gameTypes(): HasMany
    {
        return $this->hasMany(GameType::class);
    }
}
