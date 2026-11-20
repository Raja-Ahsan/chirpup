<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
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

    public function moods(): HasMany
    {
        return $this->hasMany(ChildMood::class);
    }

    public function gameCompletes(): HasMany
    {
        return $this->hasMany(GameComplete::class, 'character_id', 'character_id');
    }

    /**
     * @return array{stars: int, coins: int, progress_percent: int}
     */
    public function progressStats(): array
    {
        $completes = $this->relationLoaded('gameCompletes')
            ? $this->gameCompletes->where('user_id', $this->user_id)->values()
            : GameComplete::query()
                ->where('user_id', $this->user_id)
                ->where('character_id', $this->character_id)
                ->get();

        $stars = (int) $completes->sum('stars_rating');
        $coins = (int) $completes->sum('points');

        $completedSketchIds = $completes->pluck('sketche_id')->unique()->filter()->count();

        $totalSketches = GameTypeSketch::query()
            ->where('status', 'active')
            ->whereHas('gameType', function ($query) {
                $query->where('status', 'active')
                    ->whereNull('deleted_at')
                    ->when($this->year_id, function ($q) {
                        $q->where('year_id', $this->year_id);
                    });
            })
            ->count();

        $progressPercent = $totalSketches > 0
            ? (int) min(100, round(($completedSketchIds / $totalSketches) * 100))
            : 0;

        return [
            'stars' => $stars,
            'coins' => $coins,
            'progress_percent' => $progressPercent,
        ];
    }

    public function weekMoods(): HasMany
    {
        // Current calendar week: Sunday → next Sunday (inclusive)
        $weekStart = today()->copy()->startOfWeek(Carbon::SUNDAY);
        $weekEnd = $weekStart->copy()->addWeek();

        return $this->hasMany(ChildMood::class)
            ->where('status', 'active')
            ->whereDate('mood_date', '>=', $weekStart->toDateString())
            ->whereDate('mood_date', '<=', $weekEnd->toDateString())
            ->orderBy('mood_date');
    }

    public function todayMoodEntry(): HasOne
    {
        return $this->hasOne(ChildMood::class)->ofMany(
            ['id' => 'max'],
            function ($query) {
                $query->whereDate('mood_date', today())
                    ->where('status', 'active');
            }
        );
    }
}
