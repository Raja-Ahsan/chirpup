<?php

namespace Database\Seeders;

use App\Models\Character;
use App\Models\GameCategory;
use App\Models\GameComplete;
use App\Models\GameMood;
use App\Models\GameTypeSketch;
use App\Models\User;
use App\Models\Year;
use Illuminate\Database\Seeder;

class GameCompleteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $user = User::query()->first();
        $character = Character::query()->where('status', 'active')->first();
        $year = Year::query()->where('status', 'active')->first();
        $gameCategory = GameCategory::query()->where('status', 'active')->first();
        $sketch = GameTypeSketch::query()->with('gameType')->where('status', 'active')->first();
        $mood = GameMood::query()->where('status', 'active')->first();

        if (! $user || ! $character || ! $year || ! $gameCategory || ! $sketch || ! $mood) {
            return;
        }

        GameComplete::query()->updateOrCreate(
            [
                'user_id' => $user->id,
                'character_id' => $character->id,
                'sketche_id' => $sketch->id,
                'play_date' => now()->toDateString(),
            ],
            [
                'year_id' => $year->id,
                'category_id' => null,
                'game_category_id' => $gameCategory->id,
                'sketche_image_id' => $sketch->id,
                'sketch_complete_image_url' => $sketch->image_url,
                'stars_rating' => min(5, max(1, (int) ($sketch->gameType?->points ?? 1))),
                'points' => (int) ($sketch->gameType?->points ?? 0),
                'mood_id' => $mood->id,
                'css_style_json' => [
                    'background' => '#0d2744',
                    'accent' => '#5eb4ef',
                ],
            ]
        );
    }
}
