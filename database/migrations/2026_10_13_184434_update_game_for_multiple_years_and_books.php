<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('game_year', function (Blueprint $table) {
            $table->id();
            $table->foreignId('game_id')->constrained('game')->cascadeOnDelete();
            $table->foreignId('year_id')->constrained('years')->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['game_id', 'year_id']);
        });

        Schema::create('book_game', function (Blueprint $table) {
            $table->id();
            $table->foreignId('book_id')->constrained('books')->cascadeOnDelete();
            $table->foreignId('game_id')->constrained('game')->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['book_id', 'game_id']);
        });

        $now = now();

        DB::table('game')
            ->whereNotNull('year_id')
            ->orderBy('id')
            ->get(['id', 'year_id'])
            ->each(function ($game) use ($now) {
                DB::table('game_year')->insertOrIgnore([
                    'game_id' => $game->id,
                    'year_id' => $game->year_id,
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            });

        Schema::table('game', function (Blueprint $table) {
            $table->dropConstrainedForeignId('year_id');
            $table->dropColumn('cover_book_image');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('game', function (Blueprint $table) {
            $table->foreignId('year_id')->nullable()->after('slug')->constrained('years')->cascadeOnDelete();
            $table->string('cover_book_image')->nullable()->after('image_url');
        });

        $firstYears = DB::table('game_year')
            ->select('game_id', DB::raw('MIN(year_id) as year_id'))
            ->groupBy('game_id')
            ->get();

        foreach ($firstYears as $row) {
            DB::table('game')
                ->where('id', $row->game_id)
                ->update(['year_id' => $row->year_id]);
        }

        Schema::dropIfExists('book_game');
        Schema::dropIfExists('game_year');
    }
};
