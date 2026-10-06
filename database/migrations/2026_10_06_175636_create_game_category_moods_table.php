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
        Schema::create('game_categories_mood', function (Blueprint $table) {
            $table->id();
            $table->foreignId('game_category_id')->constrained('game_categories')->cascadeOnDelete();
            $table->foreignId('mood_id')->constrained('game_mood')->cascadeOnDelete();
            $table->string('status')->default('active');
            $table->timestamps();
            $table->softDeletes();

            $table->unique(['game_category_id', 'mood_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('game_categories_mood');
    }
};
