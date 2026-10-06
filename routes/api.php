<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CharacterController;
use App\Http\Controllers\Api\ChildController;
use App\Http\Controllers\Api\GameCategoryController;
use App\Http\Controllers\Api\GameMoodController;
use App\Http\Controllers\Api\OtpController;
use App\Http\Controllers\Api\YearController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/auth/verify-email', [OtpController::class, 'verify']);
Route::post('/auth/resend-otp', [OtpController::class, 'resend']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

Route::get('/years', [YearController::class, 'index']);
Route::get('/years/{year}', [YearController::class, 'show']);

Route::get('/characters', [CharacterController::class, 'index']);
Route::get('/characters/{character:slug}', [CharacterController::class, 'show']);

Route::get('/moods', [GameMoodController::class, 'index']);
Route::get('/moods/{mood:slug}/categories', [GameMoodController::class, 'categories']);
Route::get('/moods/{mood:slug}', [GameMoodController::class, 'show']);

Route::get('/game-categories', [GameCategoryController::class, 'index']);
Route::get('/game-categories/{gameCategory:slug}', [GameCategoryController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/change-password', [AuthController::class, 'changePassword']);
    Route::post('/update-profile', [AuthController::class, 'updateProfile']);
    Route::post('/parent-pin', [AuthController::class, 'parentPin']);
    Route::post('/parent-pin/verify', [AuthController::class, 'verifyParentPin']);

    Route::get('/children', [ChildController::class, 'index']);
    Route::post('/children', [ChildController::class, 'store']);
    Route::get('/children/{child:slug}', [ChildController::class, 'show']);
    Route::put('/children/{child:slug}', [ChildController::class, 'update']);
    Route::patch('/children/{child:slug}', [ChildController::class, 'update']);
    Route::post('/children/{child:slug}/mood', [ChildController::class, 'updateMood']);
    Route::delete('/children/{child:slug}', [ChildController::class, 'destroy']);
});
