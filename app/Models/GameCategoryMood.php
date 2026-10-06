<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class GameCategoryMood extends Model
{
    use SoftDeletes;

    protected $table = 'game_categories_mood';

    protected $fillable = [
        'game_category_id',
        'mood_id',
        'status',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(GameCategory::class, 'game_category_id');
    }

    public function mood(): BelongsTo
    {
        return $this->belongsTo(GameMood::class, 'mood_id');
    }
}
