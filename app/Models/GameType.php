<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class GameType extends Model
{
    use SoftDeletes;

    protected $table = 'games_type';

    protected $fillable = [
        'name',
        'slug',
        'game_category_id',
        'year_id',
        'game_id',
        'points',
        'sketch_image_url',
        'color_image_url',
        'description',
        'status',
    ];

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    protected static function booted(): void
    {
        static::creating(function (GameType $gameType) {
            if (blank($gameType->slug)) {
                $gameType->slug = static::uniqueSlug($gameType->name);
            }
        });

        static::updating(function (GameType $gameType) {
            if ($gameType->isDirty('name')) {
                $gameType->slug = static::uniqueSlug($gameType->name, $gameType->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'game-type';
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

    protected function sketchImagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->sketch_image_url) {
                return null;
            }

            return asset('assets/game-types/'.$this->sketch_image_url);
        });
    }

    protected function colorImagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->color_image_url) {
                return null;
            }

            return asset('assets/game-types/'.$this->color_image_url);
        });
    }

    public function gameCategory(): BelongsTo
    {
        return $this->belongsTo(GameCategory::class);
    }

    public function year(): BelongsTo
    {
        return $this->belongsTo(Year::class);
    }

    public function game(): BelongsTo
    {
        return $this->belongsTo(Game::class);
    }

    public function sketches(): HasMany
    {
        return $this->hasMany(GameTypeSketch::class, 'game_type_id');
    }
}
