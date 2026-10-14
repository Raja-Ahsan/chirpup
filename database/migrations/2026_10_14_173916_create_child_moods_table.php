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
        Schema::create('children_mood', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('child_id')->constrained('children')->cascadeOnDelete();
            $table->foreignId('mood_id')->constrained('game_mood')->cascadeOnDelete();
            $table->date('mood_date');
            $table->string('status')->default('active');
            $table->timestamps();
            $table->softDeletes();

            $table->index(['child_id', 'mood_date']);
        });

        $now = now();

        DB::table('children')
            ->whereNotNull('today_mood')
            ->whereNotNull('mood_date')
            ->orderBy('id')
            ->get(['id', 'user_id', 'today_mood', 'mood_date'])
            ->each(function ($child) use ($now) {
                DB::table('children_mood')->insert([
                    'user_id' => $child->user_id,
                    'child_id' => $child->id,
                    'mood_id' => $child->today_mood,
                    'mood_date' => $child->mood_date,
                    'status' => 'active',
                    'created_at' => $now,
                    'updated_at' => $now,
                ]);
            });

        Schema::table('children', function (Blueprint $table) {
            $table->dropConstrainedForeignId('today_mood');
            $table->dropColumn('mood_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('children', function (Blueprint $table) {
            $table->foreignId('today_mood')
                ->nullable()
                ->after('character_id')
                ->constrained('game_mood')
                ->nullOnDelete();
            $table->date('mood_date')->nullable()->after('today_mood');
        });

        $latestMoods = DB::table('children_mood')
            ->select('child_id', DB::raw('MAX(id) as id'))
            ->whereNull('deleted_at')
            ->groupBy('child_id')
            ->pluck('id');

        DB::table('children_mood')
            ->whereIn('id', $latestMoods)
            ->orderBy('id')
            ->get()
            ->each(function ($mood) {
                DB::table('children')
                    ->where('id', $mood->child_id)
                    ->update([
                        'today_mood' => $mood->mood_id,
                        'mood_date' => $mood->mood_date,
                    ]);
            });

        Schema::dropIfExists('children_mood');
    }
};
