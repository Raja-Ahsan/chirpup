<?php

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\BookController as AdminBookController;
use App\Http\Controllers\Admin\CharacterController as AdminCharacterController;
use App\Http\Controllers\Admin\DashboardController as AdminDashboardController;
use App\Http\Controllers\Admin\GameBookYearController as AdminGameBookYearController;
use App\Http\Controllers\Admin\GameCategoryController as AdminGameCategoryController;
use App\Http\Controllers\Admin\GameController as AdminGameController;
use App\Http\Controllers\Admin\GameMoodController as AdminGameMoodController;
use App\Http\Controllers\Admin\GameTypeController as AdminGameTypeController;
use App\Http\Controllers\Admin\SketchController as AdminSketchController;
use App\Http\Controllers\Admin\UserController as AdminUserController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

// web routes
Route::get('/', function () {
    return view('welcome');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

// Admin auth (guest)
Route::prefix('admin')->middleware('guest')->group(function () {
    Route::get('login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
    Route::post('login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
});

// Admin panel (authenticated admin)
Route::prefix('admin')->middleware(['auth', 'admin'])->group(function () {
    Route::get('/', [AdminDashboardController::class, 'index'])->name('admin.dashboard');

    Route::get('users', [AdminUserController::class, 'index'])->name('admin.users.index');

    Route::get('characters', [AdminCharacterController::class, 'index'])->name('admin.characters.index');
    Route::get('characters/create', [AdminCharacterController::class, 'create'])->name('admin.characters.create');
    Route::post('characters', [AdminCharacterController::class, 'store'])->name('admin.characters.store');
    Route::get('characters/{character}/edit', [AdminCharacterController::class, 'edit'])->name('admin.characters.edit');
    Route::put('characters/{character}', [AdminCharacterController::class, 'update'])->name('admin.characters.update');
    Route::delete('characters/{character}', [AdminCharacterController::class, 'destroy'])->name('admin.characters.destroy');

    Route::get('game-moods', [AdminGameMoodController::class, 'index'])->name('admin.game-moods.index');
    Route::get('game-moods/create', [AdminGameMoodController::class, 'create'])->name('admin.game-moods.create');
    Route::post('game-moods', [AdminGameMoodController::class, 'store'])->name('admin.game-moods.store');
    Route::get('game-moods/{gameMood}/edit', [AdminGameMoodController::class, 'edit'])->name('admin.game-moods.edit');
    Route::put('game-moods/{gameMood}', [AdminGameMoodController::class, 'update'])->name('admin.game-moods.update');
    Route::delete('game-moods/{gameMood}', [AdminGameMoodController::class, 'destroy'])->name('admin.game-moods.destroy');

    Route::get('game-categories', [AdminGameCategoryController::class, 'index'])->name('admin.game-categories.index');
    Route::get('game-categories/create', [AdminGameCategoryController::class, 'create'])->name('admin.game-categories.create');
    Route::post('game-categories', [AdminGameCategoryController::class, 'store'])->name('admin.game-categories.store');
    Route::get('game-categories/{gameCategory}/edit', [AdminGameCategoryController::class, 'edit'])->name('admin.game-categories.edit');
    Route::put('game-categories/{gameCategory}', [AdminGameCategoryController::class, 'update'])->name('admin.game-categories.update');
    Route::delete('game-categories/{gameCategory}', [AdminGameCategoryController::class, 'destroy'])->name('admin.game-categories.destroy');

    Route::get('games', [AdminGameController::class, 'index'])->name('admin.games.index');
    Route::get('games/create', [AdminGameController::class, 'create'])->name('admin.games.create');
    Route::post('games', [AdminGameController::class, 'store'])->name('admin.games.store');
    Route::get('games/category/{gameCategory}', [AdminGameController::class, 'byCategory'])->name('admin.games.by-category');
    Route::get('games/category/{gameCategory}/games', [AdminGameController::class, 'categoryGames'])->name('admin.games.category-games');
    Route::get('games/{game}/edit', [AdminGameController::class, 'edit'])->name('admin.games.edit');
    Route::put('games/{game}', [AdminGameController::class, 'update'])->name('admin.games.update');
    Route::delete('games/{game}', [AdminGameController::class, 'destroy'])->name('admin.games.destroy');

    Route::get('games/category/{gameCategory}/book-years', [AdminGameBookYearController::class, 'index'])->name('admin.game-book-years.index');
    Route::get('games/category/{gameCategory}/book-years/create', [AdminGameBookYearController::class, 'create'])->name('admin.game-book-years.create');
    Route::post('games/category/{gameCategory}/book-years', [AdminGameBookYearController::class, 'store'])->name('admin.game-book-years.store');
    Route::get('games/category/{gameCategory}/book-years/{gameBookYear}/edit', [AdminGameBookYearController::class, 'edit'])->name('admin.game-book-years.edit');
    Route::put('games/category/{gameCategory}/book-years/{gameBookYear}', [AdminGameBookYearController::class, 'update'])->name('admin.game-book-years.update');
    Route::delete('games/category/{gameCategory}/book-years/{gameBookYear}', [AdminGameBookYearController::class, 'destroy'])->name('admin.game-book-years.destroy');

    Route::get('games/category/{gameCategory}/sketches', [AdminSketchController::class, 'index'])->name('admin.sketches.index');

    Route::get('game-types', [AdminGameTypeController::class, 'index'])->name('admin.game-types.index');
    Route::get('game-types/create', [AdminGameTypeController::class, 'create'])->name('admin.game-types.create');
    Route::post('game-types', [AdminGameTypeController::class, 'store'])->name('admin.game-types.store');
    Route::get('game-types/game/{game}', [AdminGameTypeController::class, 'byGame'])->name('admin.game-types.by-game');
    Route::get('game-types/{gameType}/edit', [AdminGameTypeController::class, 'edit'])->name('admin.game-types.edit');
    Route::put('game-types/{gameType}', [AdminGameTypeController::class, 'update'])->name('admin.game-types.update');
    Route::delete('game-types/{gameType}', [AdminGameTypeController::class, 'destroy'])->name('admin.game-types.destroy');

    Route::get('books', [AdminBookController::class, 'index'])->name('admin.books.index');
    Route::get('books/create', [AdminBookController::class, 'create'])->name('admin.books.create');
    Route::post('books', [AdminBookController::class, 'store'])->name('admin.books.store');
    Route::get('books/{book}/edit', [AdminBookController::class, 'edit'])->name('admin.books.edit');
    Route::put('books/{book}', [AdminBookController::class, 'update'])->name('admin.books.update');
    Route::delete('books/{book}', [AdminBookController::class, 'destroy'])->name('admin.books.destroy');

    Route::post('logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
});

require __DIR__.'/auth.php';
