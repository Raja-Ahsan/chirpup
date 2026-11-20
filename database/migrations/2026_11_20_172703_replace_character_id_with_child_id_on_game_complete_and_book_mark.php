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
        foreach (['game_complete', 'book_mark'] as $tableName) {
            Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                if (! Schema::hasColumn($tableName, 'child_id')) {
                    $table->foreignId('child_id')
                        ->nullable()
                        ->after('user_id')
                        ->constrained('children')
                        ->cascadeOnDelete();
                }
            });

            $rows = DB::table($tableName)->whereNull('child_id')->orderBy('id')->get(['id', 'user_id', 'character_id']);
            foreach ($rows as $row) {
                $childId = DB::table('children')
                    ->where('user_id', $row->user_id)
                    ->where('character_id', $row->character_id)
                    ->whereNull('deleted_at')
                    ->orderBy('id')
                    ->value('id');

                if ($childId) {
                    DB::table($tableName)->where('id', $row->id)->update(['child_id' => $childId]);
                }
            }

            // Drop rows that cannot be mapped to a child so the FK can be required.
            DB::table($tableName)->whereNull('child_id')->delete();

            Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                if (Schema::hasColumn($tableName, 'character_id')) {
                    $table->dropConstrainedForeignId('character_id');
                }
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        foreach (['game_complete', 'book_mark'] as $tableName) {
            Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                if (! Schema::hasColumn($tableName, 'character_id')) {
                    $table->foreignId('character_id')
                        ->nullable()
                        ->after('user_id')
                        ->constrained('characters')
                        ->cascadeOnDelete();
                }
            });

            $rows = DB::table($tableName)->whereNull('character_id')->orderBy('id')->get(['id', 'child_id']);
            foreach ($rows as $row) {
                $characterId = DB::table('children')
                    ->where('id', $row->child_id)
                    ->value('character_id');

                if ($characterId) {
                    DB::table($tableName)->where('id', $row->id)->update(['character_id' => $characterId]);
                }
            }

            Schema::table($tableName, function (Blueprint $table) use ($tableName) {
                if (Schema::hasColumn($tableName, 'child_id')) {
                    $table->dropConstrainedForeignId('child_id');
                }
            });
        }
    }
};
