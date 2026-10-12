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
        if (Schema::hasColumn('game', 'cover_book_image')) {
            return;
        }

        Schema::table('game', function (Blueprint $table) {
            $table->string('cover_book_image')->nullable()->after('image_url');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (! Schema::hasColumn('game', 'cover_book_image')) {
            return;
        }

        Schema::table('game', function (Blueprint $table) {
            $table->dropColumn('cover_book_image');
        });
    }
};
