<?php

namespace Database\Seeders;

use App\Models\GameCategory;
use App\Models\GameMood;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class GameCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'title' => 'Breathing',
                'image_url' => 'breathing.png',
                'description' => 'Calm your mind with guided breathing games.',
            ],
            [
                'title' => 'Creative',
                'image_url' => 'creative.png',
                'description' => 'Explore creativity through playful activities.',
            ],
            [
                'title' => 'Gratitude',
                'image_url' => 'graditude.png',
                'description' => 'Practice thankfulness with fun gratitude games.',
            ],
            [
                'title' => 'Music',
                'image_url' => 'music.png',
                'description' => 'Feel better through musical play and rhythm.',
            ],
        ];

        $moodIds = GameMood::query()
            ->where('status', 'active')
            ->pluck('id');

        foreach ($categories as $categoryData) {
            $category = GameCategory::query()->updateOrCreate(
                ['slug' => Str::slug($categoryData['title'])],
                [
                    'title' => $categoryData['title'],
                    'image_url' => $categoryData['image_url'],
                    'description' => $categoryData['description'],
                    'status' => 'active',
                ]
            );

            if ($moodIds->isEmpty()) {
                continue;
            }

            $randomMoodIds = $moodIds
                ->shuffle()
                ->take(random_int(1, min(3, $moodIds->count())))
                ->values()
                ->all();

            $category->syncMoods($randomMoodIds);
        }
    }
}
