<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class Child extends Model
{
    use SoftDeletes;

    protected $table = 'children';

    protected $fillable = [
        'user_id',
        'name',
        'slug',
        'year_id',
        'character_id',
        'today_mood',
        'mood_date',
        'pin_code',
        'status',
    ];

    protected $hidden = [
        'pin_code',
    ];

    protected function casts(): array
    {
        return [
            'pin_code' => 'hashed',
            'mood_date' => 'date',
        ];
    }

    public function getRouteKeyName(): string
    {
        return 'slug';
    }

    protected static function booted(): void
    {
        static::creating(function (Child $child) {
            if (blank($child->slug)) {
                $child->slug = static::uniqueSlug($child->name);
            }
        });

        static::updating(function (Child $child) {
            if ($child->isDirty('name')) {
                $child->slug = static::uniqueSlug($child->name, $child->id);
            }
        });
    }

    public static function uniqueSlug(string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug($name) ?: 'child';
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

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function year(): BelongsTo
    {
        return $this->belongsTo(Year::class);
    }

    public function character(): BelongsTo
    {
        return $this->belongsTo(Character::class);
    }

    public function todayMood(): BelongsTo
    {
        return $this->belongsTo(GameMood::class, 'today_mood');
    }
}
