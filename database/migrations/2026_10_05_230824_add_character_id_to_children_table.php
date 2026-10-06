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
        Schema::table('children', function (Blueprint $table) {
            $table->foreignId('character_id')
                ->nullable()
                ->after('year_id')
                ->constrained('characters')
                ->cascadeOnDelete();
        });

        $defaultCharacterId = DB::table('characters')->orderBy('id')->value('id');

        if ($defaultCharacterId) {
            DB::table('children')
                ->whereNull('character_id')
                ->update(['character_id' => $defaultCharacterId]);
        }

        Schema::table('children', function (Blueprint $table) {
            $table->foreignId('character_id')->nullable(false)->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('children', function (Blueprint $table) {
            $table->dropConstrainedForeignId('character_id');
        });
    }
};
