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
        Schema::table('children', function (Blueprint $table) {
            $table->foreignId('today_mood')
                ->nullable()
                ->after('character_id')
                ->constrained('game_mood')
                ->nullOnDelete();
            $table->date('mood_date')->nullable()->after('today_mood');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('children', function (Blueprint $table) {
            $table->dropConstrainedForeignId('today_mood');
            $table->dropColumn('mood_date');
        });
    }
};
