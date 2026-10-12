<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class GameTypeSketch extends Model
{
    use SoftDeletes;

    protected $table = 'games_type_sketches';

    protected $fillable = [
        'name',
        'slug',
        'game_type_id',
        'image_url',
        'status',
    ];

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    protected static function booted(): void
    {
        static::creating(function (GameTypeSketch $sketch) {
            if (blank($sketch->slug)) {
                $sketch->slug = static::uniqueSlug($sketch->name);
            }
        });

        static::updating(function (GameTypeSketch $sketch) {
            if ($sketch->isDirty('name')) {
                $sketch->slug = static::uniqueSlug($sketch->name, $sketch->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'sketch';
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

            return asset('assets/game-type-sketches/'.$this->image_url);
        });
    }

    public function gameType(): BelongsTo
    {
        return $this->belongsTo(GameType::class, 'game_type_id');
    }
}
