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
        if (! Schema::hasTable('game_books')) {
            Schema::create('game_books', function (Blueprint $table) {
                $table->id();
                $table->foreignId('game_id')->constrained('game')->cascadeOnDelete();
                $table->foreignId('year_id')->constrained('years')->cascadeOnDelete();
                $table->foreignId('book_id')->constrained('books')->cascadeOnDelete();
                $table->string('status')->default('active');
                $table->timestamps();
                $table->softDeletes();

                $table->unique(['game_id', 'year_id', 'book_id']);
            });
        }

        if (! Schema::hasColumn('game_book_year', 'book_id')) {
            return;
        }

        $rows = DB::table('game_book_year')->orderBy('id')->get();

        foreach ($rows as $row) {
            DB::table('game_books')->insertOrIgnore([
                'game_id' => $row->game_id,
                'year_id' => $row->year_id,
                'book_id' => $row->book_id,
                'status' => $row->status ?? 'active',
                'created_at' => $row->created_at ?? now(),
                'updated_at' => $row->updated_at ?? now(),
                'deleted_at' => $row->deleted_at,
            ]);
        }

        $keepIds = DB::table('game_book_year')
            ->select(DB::raw('MIN(id) as id'))
            ->groupBy('game_id', 'year_id')
            ->pluck('id')
            ->all();

        if ($keepIds !== []) {
            DB::table('game_book_year')
                ->whereNotIn('id', $keepIds)
                ->delete();
        }

        // game_id FK may rely on the composite unique index; add a dedicated index first.
        $indexes = collect(DB::select('SHOW INDEX FROM game_book_year'))
            ->pluck('Key_name')
            ->unique()
            ->all();

        if (! in_array('game_book_year_game_id_index', $indexes, true)) {
            Schema::table('game_book_year', function (Blueprint $table) {
                $table->index('game_id');
            });
        }

        // Drop leftover book_id index/constraint if present.
        if (in_array('game_book_year_book_id_foreign', $indexes, true)) {
            try {
                Schema::table('game_book_year', function (Blueprint $table) {
                    $table->dropForeign(['book_id']);
                });
            } catch (\Throwable) {
                DB::statement('ALTER TABLE game_book_year DROP INDEX game_book_year_book_id_foreign');
            }
        }

        Schema::table('game_book_year', function (Blueprint $table) {
            $table->dropUnique(['game_id', 'book_id', 'year_id']);
            $table->dropColumn('book_id');
        });

        Schema::table('game_book_year', function (Blueprint $table) {
            $table->unique(['game_id', 'year_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (! Schema::hasColumn('game_book_year', 'book_id')) {
            Schema::table('game_book_year', function (Blueprint $table) {
                $table->dropUnique(['game_id', 'year_id']);
            });

            Schema::table('game_book_year', function (Blueprint $table) {
                $table->foreignId('book_id')->nullable()->after('game_id')->constrained('books')->cascadeOnDelete();
            });

            $firstBooks = DB::table('game_books')
                ->select('game_id', 'year_id', DB::raw('MIN(book_id) as book_id'))
                ->whereNull('deleted_at')
                ->groupBy('game_id', 'year_id')
                ->get();

            foreach ($firstBooks as $row) {
                DB::table('game_book_year')
                    ->where('game_id', $row->game_id)
                    ->where('year_id', $row->year_id)
                    ->update(['book_id' => $row->book_id]);
            }

            Schema::table('game_book_year', function (Blueprint $table) {
                $table->unique(['game_id', 'book_id', 'year_id']);
            });
        }

        Schema::dropIfExists('game_books');
    }
};
