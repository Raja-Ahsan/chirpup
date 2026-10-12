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
        if (Schema::hasColumn('game', 'game_category_id')) {
            return;
        }

        Schema::table('game', function (Blueprint $table) {
            $table->foreignId('game_category_id')
                ->nullable()
                ->after('year_id')
                ->constrained('game_categories')
                ->cascadeOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (! Schema::hasColumn('game', 'game_category_id')) {
            return;
        }

        Schema::table('game', function (Blueprint $table) {
            $table->dropConstrainedForeignId('game_category_id');
        });
    }
};
