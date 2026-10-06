<?php

namespace Database\Seeders;

use App\Models\Year;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class YearSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $years = [
            '1-2 Years',
            '3-4 Years',
            '5-6 Years',
            '7-8 Years',
            '9+ Years',
        ];

        foreach ($years as $title) {
            $slug = Str::slug($title);

            Year::query()->updateOrCreate(
                ['slug' => $slug],
                [
                    'title' => $title,
                    'status' => 'active',
                ]
            );
        }
    }
}
