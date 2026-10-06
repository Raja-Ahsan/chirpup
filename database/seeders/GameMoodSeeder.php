<?php

namespace Database\Seeders;

use App\Models\GameMood;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class GameMoodSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $moods = [
            [
                'name' => 'Happy',
                'image_url' => 'happy.png',
                'description' => 'Feeling joyful and bright.',
            ],
            [
                'name' => 'Calm',
                'image_url' => 'calm.png',
                'description' => 'Feeling peaceful and relaxed.',
            ],
            [
                'name' => 'Sleepy',
                'image_url' => 'sleepy.png',
                'description' => 'Feeling tired and ready to rest.',
            ],
            [
                'name' => 'Angry',
                'image_url' => 'angry.png',
                'description' => 'Feeling upset or frustrated.',
            ],
            [
                'name' => 'Sad',
                'image_url' => 'sad.png',
                'description' => 'Feeling down or tearful.',
            ],
        ];

        foreach ($moods as $mood) {
            GameMood::query()->updateOrCreate(
                ['slug' => Str::slug($mood['name'])],
                [
                    'name' => $mood['name'],
                    'image_url' => $mood['image_url'],
                    'description' => $mood['description'],
                    'status' => 'active',
                ]
            );
        }
    }
}
