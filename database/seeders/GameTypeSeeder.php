<?php

namespace Database\Seeders;

use App\Models\Game;
use App\Models\GameCategory;
use App\Models\GameType;
use App\Models\GameTypeSketch;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class GameTypeSeeder extends Seeder
{
    /**
     * Year folder name => years.id
     *
     * @var array<string, int>
     */
    private array $yearFolders = [
        '1-2 PNG' => 1,
        '3-4 PNG' => 2,
        '5-6 PNG' => 3,
        '7-8 PNG' => 4,
        '9 PNG' => 5,
    ];

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $sourceRoot = database_path('seeders/assets/magic-coloring-sketches');

        if (! File::isDirectory($sourceRoot)) {
            $this->command?->warn("Magic Coloring sketches folder not found: {$sourceRoot}");

            return;
        }

        $categoryId = GameCategory::query()
            ->where('slug', 'creative')
            ->value('id');

        if (! $categoryId) {
            $this->command?->warn('Creative game category not found. Seed GameCategorySeeder first.');

            return;
        }

        $typeDir = public_path('assets/game-types');
        $sketchDir = public_path('assets/game-type-sketches');
        File::ensureDirectoryExists($typeDir);
        File::ensureDirectoryExists($sketchDir);

        foreach ($this->yearFolders as $folderName => $yearId) {
            $yearPath = $sourceRoot.DIRECTORY_SEPARATOR.$folderName;

            if (! File::isDirectory($yearPath)) {
                $this->command?->warn("Year folder missing: {$folderName}");

                continue;
            }

            $game = Game::query()
                ->where('name', 'Magic Coloring')
                ->where('game_category_id', $categoryId)
                ->whereHas('gameBookYears', fn ($query) => $query->where('year_id', $yearId))
                ->first();

            if (! $game) {
                // Fall back to the game itself when Game Book & Year is not seeded yet.
                $game = Game::query()
                    ->where('name', 'Magic Coloring')
                    ->where('game_category_id', $categoryId)
                    ->first();
            }

            if (! $game) {
                $this->command?->warn("Magic Coloring game missing for year_id={$yearId}");

                continue;
            }

            foreach (File::directories($yearPath) as $typePath) {
                $typeName = basename($typePath);
                $images = $this->imageFiles($typePath);

                if ($images === []) {
                    $this->command?->warn("No images found for {$folderName}/{$typeName}");

                    continue;
                }

                $sketchSource = $images[array_rand($images)];
                $sketchFilename = $this->copyImage(
                    $sketchSource,
                    $typeDir,
                    'type_'.$yearId.'_'.Str::slug($typeName).'_sketch_'
                );

                $gameType = GameType::query()->updateOrCreate(
                    [
                        'year_id' => $yearId,
                        'game_id' => $game->id,
                        'name' => $typeName,
                    ],
                    [
                        'slug' => Str::slug($typeName).'-'.$yearId,
                        'game_category_id' => $categoryId,
                        'points' => random_int(10, 100),
                        'sketch_image_url' => $sketchFilename,
                        'color_image_url' => null,
                        'description' => null,
                        'status' => 'active',
                    ]
                );

                $this->syncSketches($gameType, $images, $sketchDir, $yearId, $typeName);
            }
        }
    }

    /**
     * @return array<int, string>
     */
    private function imageFiles(string $directory): array
    {
        return collect(File::files($directory))
            ->filter(function ($file) {
                return in_array(strtolower($file->getExtension()), ['png', 'jpg', 'jpeg', 'webp'], true);
            })
            ->map(fn ($file) => $file->getPathname())
            ->values()
            ->all();
    }

    /**
     * @param  array<int, string>  $images
     */
    private function syncSketches(
        GameType $gameType,
        array $images,
        string $sketchDir,
        int $yearId,
        string $typeName
    ): void {
        $keptIds = [];

        foreach ($images as $index => $sourcePath) {
            $baseName = pathinfo($sourcePath, PATHINFO_FILENAME);
            $sketchName = trim(Str::title(str_replace(['_', '-'], ' ', $baseName))) ?: ($typeName.' '.($index + 1));
            $filename = $this->copyImage(
                $sourcePath,
                $sketchDir,
                'sketch_'.$yearId.'_'.Str::slug($typeName).'_'.($index + 1).'_'
            );

            $sketch = GameTypeSketch::query()->updateOrCreate(
                [
                    'game_type_id' => $gameType->id,
                    'name' => $sketchName,
                ],
                [
                    'slug' => Str::slug($sketchName).'-'.$gameType->id.'-'.($index + 1),
                    'image_url' => $filename,
                    'status' => 'active',
                ]
            );

            $keptIds[] = $sketch->id;
        }

        $gameType->sketches()
            ->when($keptIds !== [], fn ($query) => $query->whereNotIn('id', $keptIds))
            ->get()
            ->each(function (GameTypeSketch $sketch) use ($sketchDir) {
                if ($sketch->image_url) {
                    $path = $sketchDir.DIRECTORY_SEPARATOR.$sketch->image_url;
                    if (File::exists($path)) {
                        File::delete($path);
                    }
                }
                $sketch->delete();
            });
    }

    private function copyImage(string $sourcePath, string $destinationDir, string $prefix): string
    {
        $extension = strtolower(pathinfo($sourcePath, PATHINFO_EXTENSION) ?: 'png');
        $filename = uniqid($prefix, true).'.'.$extension;
        File::copy($sourcePath, $destinationDir.DIRECTORY_SEPARATOR.$filename);

        return $filename;
    }
}
