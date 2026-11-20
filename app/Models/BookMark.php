<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class BookMark extends Model
{
    use SoftDeletes;

    protected $table = 'book_mark';

    protected $fillable = [
        'user_id',
        'child_id',
        'year_id',
        'category_id',
        'game_category_id',
        'sketche_id',
        'sketche_image_id',
        'sketch_complete_image_url',
        'play_date',
        'css_style_json',
    ];

    protected function casts(): array
    {
        return [
            'play_date' => 'date',
            'css_style_json' => 'array',
        ];
    }

    protected function sketchCompleteImagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->sketch_complete_image_url) {
                return null;
            }

            if (str_starts_with($this->sketch_complete_image_url, 'http://')
                || str_starts_with($this->sketch_complete_image_url, 'https://')) {
                return $this->sketch_complete_image_url;
            }

            // Legacy assets path fallback.
            if (! str_contains($this->sketch_complete_image_url, '/')) {
                return asset('assets/book-mark/'.$this->sketch_complete_image_url);
            }

            return Storage::disk('public')->url($this->sketch_complete_image_url);
        });
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function child(): BelongsTo
    {
        return $this->belongsTo(Child::class);
    }

    public function year(): BelongsTo
    {
        return $this->belongsTo(Year::class);
    }

    public function gameCategory(): BelongsTo
    {
        return $this->belongsTo(GameCategory::class, 'game_category_id');
    }

    public function gameType(): BelongsTo
    {
        return $this->belongsTo(GameType::class, 'sketche_id');
    }

    public function sketchImage(): BelongsTo
    {
        return $this->belongsTo(GameTypeSketch::class, 'sketche_image_id');
    }
}
