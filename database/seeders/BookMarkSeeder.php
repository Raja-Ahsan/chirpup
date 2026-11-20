<?php

namespace Database\Seeders;

use App\Models\BookMark;
use App\Models\Child;
use App\Models\GameCategory;
use App\Models\GameTypeSketch;
use Illuminate\Database\Seeder;

class BookMarkSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $child = Child::query()->first();
        $gameCategory = GameCategory::query()->where('status', 'active')->first();
        $sketch = GameTypeSketch::query()->where('status', 'active')->first();

        if (! $child || ! $gameCategory || ! $sketch) {
            return;
        }

        BookMark::query()->updateOrCreate(
            [
                'user_id' => $child->user_id,
                'child_id' => $child->id,
                'sketche_id' => $sketch->id,
                'play_date' => now()->toDateString(),
            ],
            [
                'year_id' => $child->year_id,
                'category_id' => null,
                'game_category_id' => $gameCategory->id,
                'sketche_image_id' => $sketch->id,
                'sketch_complete_image_url' => $sketch->image_url,
                'css_style_json' => [
                    'background' => '#0d2744',
                    'accent' => '#5eb4ef',
                ],
            ]
        );
    }
}
