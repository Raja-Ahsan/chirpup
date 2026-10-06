<?php

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\CharacterController as AdminCharacterController;
use App\Http\Controllers\Admin\GameCategoryController as AdminGameCategoryController;
use App\Http\Controllers\Admin\GameMoodController as AdminGameMoodController;
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
    Route::get('/', function () {
        return view('screens.admin.dashboard.index');
    })->name('admin.dashboard');

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

    Route::post('logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
});

require __DIR__.'/auth.php';
