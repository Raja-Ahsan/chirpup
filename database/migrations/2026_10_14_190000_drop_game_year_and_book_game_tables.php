<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::dropIfExists('book_game');
        Schema::dropIfExists('game_year');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
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
    }
};
