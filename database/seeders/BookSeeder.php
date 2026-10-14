<?php

namespace Database\Seeders;

use App\Models\Book;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class BookSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $directory = public_path('assets/books');
        File::ensureDirectoryExists($directory);

        $sourceDir = public_path('assets/games');

        $books = [
            [
                'title' => 'Magical Colouring Book',
                'image_url' => 'book1.png',
                'description' => 'Choose your drawing from the magical colouring book.',
            ],
            [
                'title' => 'Character Studio Book',
                'image_url' => 'book2.png',
                'description' => 'Explore characters in the Character Studio book.',
            ],
            [
                'title' => 'My Drawing Book',
                'image_url' => 'book3.png',
                'description' => 'A drawing book for creative play.',
            ],
        ];

        foreach ($books as $book) {
            $source = $sourceDir.DIRECTORY_SEPARATOR.$book['image_url'];
            $destination = $directory.DIRECTORY_SEPARATOR.$book['image_url'];

            if (File::exists($source) && ! File::exists($destination)) {
                File::copy($source, $destination);
            }

            Book::query()->updateOrCreate(
                ['slug' => Str::slug($book['title'])],
                [
                    'title' => $book['title'],
                    'image_url' => $book['image_url'],
                    'description' => $book['description'],
                    'status' => 'active',
                ]
            );
        }
    }
}
