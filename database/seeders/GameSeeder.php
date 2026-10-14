<?php

namespace Database\Seeders;

use App\Models\Game;
use App\Models\GameType;
use Illuminate\Database\Seeder;

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
                'slug' => 'magic-coloring',
                'game_category_id' => 2,
                'image_url' => 'magic_coloring.png',
                'description' => 'Choose your drawing from the magical colouring book.',
            ],
            [
                'name' => 'Castle Builder',
                'slug' => 'castle-builder',
                'game_category_id' => 2,
                'image_url' => 'castle.png',
                'description' => 'Build castles in this creative game.',
            ],
        ];

        foreach ($games as $gameData) {
            $game = Game::query()->updateOrCreate(
                ['slug' => $gameData['slug']],
                [
                    'name' => $gameData['name'],
                    'game_category_id' => $gameData['game_category_id'],
                    'image_url' => $gameData['image_url'],
                    'description' => $gameData['description'],
                    'status' => 'active',
                ]
            );

            // Merge legacy duplicate rows into the canonical game.
            Game::query()
                ->where('name', $gameData['name'])
                ->where('id', '!=', $game->id)
                ->get()
                ->each(function (Game $legacy) use ($game) {
                    GameType::query()
                        ->where('game_id', $legacy->id)
                        ->update(['game_id' => $game->id]);

                    $legacy->forceDelete();
                });
        }
    }
}
