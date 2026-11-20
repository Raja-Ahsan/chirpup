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
        Schema::create('book_mark', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('character_id')->constrained('characters')->cascadeOnDelete();
            $table->foreignId('year_id')->constrained('years')->cascadeOnDelete();
            $table->unsignedBigInteger('category_id')->nullable()->index();
            $table->foreignId('game_category_id')->constrained('game_categories')->cascadeOnDelete();
            $table->foreignId('sketche_id')->constrained('games_type_sketches')->cascadeOnDelete();
            $table->unsignedBigInteger('sketche_image_id')->nullable()->index();
            $table->string('sketch_complete_image_url')->nullable();
            $table->date('play_date');
            $table->json('css_style_json')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['user_id', 'play_date']);
            $table->index(['user_id', 'character_id', 'play_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('book_mark');
    }
};
