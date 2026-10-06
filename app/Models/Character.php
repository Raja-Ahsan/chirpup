<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class Character extends Model
{
    use SoftDeletes;

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
        static::creating(function (Character $character) {
            if (blank($character->slug)) {
                $character->slug = static::uniqueSlug($character->name);
            }
        });

        static::updating(function (Character $character) {
            if ($character->isDirty('name')) {
                $character->slug = static::uniqueSlug($character->name, $character->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'character';
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

            return asset('assets/characters/'.$this->image_url);
        });
    }

    public function children(): HasMany
    {
        return $this->hasMany(Child::class);
    }
}
