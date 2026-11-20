<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * sketche_id = games_type id (parent)
     * sketche_image_id = games_type_sketches id (nested sketch)
     */
    public function up(): void
    {
        foreach (['game_complete', 'book_mark'] as $tableName) {
            if (! Schema::hasTable($tableName)) {
                continue;
            }

            $this->dropForeignIfExists($tableName, 'sketche_id');
            $this->dropForeignIfExists($tableName, 'sketche_image_id');

            // Migrate old rows where sketche_id pointed at a nested sketch.
            $rows = DB::table($tableName)->orderBy('id')->get(['id', 'sketche_id', 'sketche_image_id']);
            foreach ($rows as $row) {
                $sketch = DB::table('games_type_sketches')->where('id', $row->sketche_id)->first();
                if (! $sketch) {
                    continue;
                }

                $imageId = $row->sketche_image_id ?: $sketch->id;
                DB::table($tableName)->where('id', $row->id)->update([
                    'sketche_id' => $sketch->game_type_id,
                    'sketche_image_id' => $imageId,
                ]);
            }

            Schema::table($tableName, function (Blueprint $table) {
                $table->foreign('sketche_id')
                    ->references('id')
                    ->on('games_type')
                    ->cascadeOnDelete();

                $table->foreign('sketche_image_id')
                    ->references('id')
                    ->on('games_type_sketches')
                    ->nullOnDelete();
            });
        }
    }

    public function down(): void
    {
        foreach (['game_complete', 'book_mark'] as $tableName) {
            if (! Schema::hasTable($tableName)) {
                continue;
            }

            $this->dropForeignIfExists($tableName, 'sketche_id');
            $this->dropForeignIfExists($tableName, 'sketche_image_id');

            $rows = DB::table($tableName)->orderBy('id')->get(['id', 'sketche_id', 'sketche_image_id']);
            foreach ($rows as $row) {
                if ($row->sketche_image_id) {
                    DB::table($tableName)->where('id', $row->id)->update([
                        'sketche_id' => $row->sketche_image_id,
                    ]);
                }
            }

            Schema::table($tableName, function (Blueprint $table) {
                $table->foreign('sketche_id')
                    ->references('id')
                    ->on('games_type_sketches')
                    ->cascadeOnDelete();
            });
        }
    }

    private function dropForeignIfExists(string $tableName, string $column): void
    {
        $database = Schema::getConnection()->getDatabaseName();
        $constraints = DB::select(
            'SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
             WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND COLUMN_NAME = ?
             AND REFERENCED_TABLE_NAME IS NOT NULL',
            [$database, $tableName, $column]
        );

        foreach ($constraints as $constraint) {
            $name = $constraint->CONSTRAINT_NAME;
            Schema::table($tableName, function (Blueprint $table) use ($name) {
                $table->dropForeign($name);
            });
        }
    }
};
