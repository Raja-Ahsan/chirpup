<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class ChildMood extends Model
{
    use SoftDeletes;

    protected $table = 'children_mood';

    protected $fillable = [
        'user_id',
        'child_id',
        'mood_id',
        'mood_date',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'mood_date' => 'date',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function child(): BelongsTo
    {
        return $this->belongsTo(Child::class);
    }

    public function mood(): BelongsTo
    {
        return $this->belongsTo(GameMood::class, 'mood_id');
    }
}
