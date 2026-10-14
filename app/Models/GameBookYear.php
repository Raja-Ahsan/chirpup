<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class GameBookYear extends Model
{
    use SoftDeletes;

    protected $table = 'game_book_year';

    protected $fillable = [
        'game_id',
        'year_id',
        'image_url',
        'description',
        'status',
    ];

    protected function imagePath(): Attribute
    {
        return Attribute::get(function (): ?string {
            if (! $this->image_url) {
                return null;
            }

            return asset('assets/game-book-years/'.$this->image_url);
        });
    }

    public function game(): BelongsTo
    {
        return $this->belongsTo(Game::class);
    }

    public function year(): BelongsTo
    {
        return $this->belongsTo(Year::class);
    }

    public function gameBooks(): HasMany
    {
        return $this->hasMany(GameBook::class, 'game_id', 'game_id');
    }

    public function booksForYear()
    {
        return $this->gameBooks()->where('year_id', $this->year_id)->with('book');
    }
}
