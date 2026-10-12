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
        Schema::create('games_type', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->foreignId('game_category_id')->constrained('game_categories')->cascadeOnDelete();
            $table->foreignId('year_id')->constrained('years')->cascadeOnDelete();
            $table->foreignId('game_id')->constrained('game')->cascadeOnDelete();
            $table->unsignedInteger('points')->default(0);
            $table->string('sketch_image_url')->nullable();
            $table->string('color_image_url')->nullable();
            $table->text('description')->nullable();
            $table->string('status')->default('active');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('games_type');
    }
};
