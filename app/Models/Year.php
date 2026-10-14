<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Year extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'title',
        'slug',
        'status',
    ];

    public function children(): HasMany
    {
        return $this->hasMany(Child::class);
    }

    public function gameTypes(): HasMany
    {
        return $this->hasMany(GameType::class);
    }
}
