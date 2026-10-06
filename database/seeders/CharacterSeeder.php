<?php

namespace Database\Seeders;

use App\Models\Character;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class CharacterSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $characters = [
            [
                'name' => 'Prince',
                'image_url' => 'character_prince.png',
                'description' => 'A friendly young prince ready for adventure.',
            ],
            [
                'name' => 'Princess',
                'image_url' => 'character_princes.png',
                'description' => 'A kind princess with a heart of gold.',
            ],
            [
                'name' => 'Knight',
                'image_url' => 'character_knight.png',
                'description' => 'A brave knight who protects the kingdom.',
            ],
            [
                'name' => 'Baby Dragon',
                'image_url' => 'character_babydragon.png',
                'description' => 'A playful baby dragon full of curiosity.',
            ],
        ];

        foreach ($characters as $character) {
            Character::query()->updateOrCreate(
                ['slug' => Str::slug($character['name'])],
                [
                    'name' => $character['name'],
                    'image_url' => $character['image_url'],
                    'description' => $character['description'],
                    'status' => 'active',
                ]
            );
        }
    }
}
