<?php

namespace Database\Seeders;

use App\Models\Game;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class GameSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $games = [
            [
                'name' => 'Magic Coloring',
                'year_id' => 1,
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'cover_book_image' => 'book1.png',
            ],
            [
                'name' => 'Magic Coloring',
                'year_id' => 2,
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'cover_book_image' => 'book1.png',
            ],
            [
                'name' => 'Magic Coloring',
                'year_id' => 3,
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'cover_book_image' => 'book1.png',
            ],
            [
                'name' => 'Magic Coloring',
                'year_id' => 4,
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'cover_book_image' => 'book1.png',
            ],
            [
                'name' => 'Magic Coloring',
                'year_id' => 5,
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'cover_book_image' => 'book1.png',
            ],
            [
                'name' => 'Castle Builder',
                'year_id' => 1,
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'cover_book_image' => 'book3.png',
            ],
            [
                'name' => 'Castle Builder',
                'year_id' => 2,
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'cover_book_image' => 'book3.png',
            ],
            [
                'name' => 'Castle Builder',
                'year_id' => 3,
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'cover_book_image' => 'book3.png',
            ],
            [
                'name' => 'Castle Builder',
                'year_id' => 4,
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'cover_book_image' => 'book3.png',
            ],
            [
                'name' => 'Castle Builder',
                'year_id' => 5,
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'cover_book_image' => 'book3.png',
            ],
        ];

        foreach ($games as $game) {
            Game::query()->updateOrCreate(
                [
                    'year_id' => $game['year_id'],
                    'name' => $game['name'],
                ],
                [
                    'slug' => Str::slug($game['name']).'-'.$game['year_id'],
                    'game_category_id' => $game['game_category_id'],
                    'image_url' => $game['image_url'],
                    'cover_book_image' => $game['cover_book_image'],
                    'description' => null,
                    'status' => 'active',
                ]
            );
        }
    }
}
