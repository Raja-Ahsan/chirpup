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
        Schema::table('games_type', function (Blueprint $table) {
            if (! Schema::hasColumn('games_type', 'book_id')) {
                $table->foreignId('book_id')
                    ->nullable()
                    ->after('year_id')
                    ->constrained('books')
                    ->nullOnDelete();
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('games_type', function (Blueprint $table) {
            if (Schema::hasColumn('games_type', 'book_id')) {
                $table->dropConstrainedForeignId('book_id');
            }
        });
    }
};
