<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RecipeController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\LikeController;
use App\Http\Controllers\SavedRecipeController;

// Auth Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

// Authenticated Routes
Route::middleware(['auth:sanctum'])->group(function () {
    Route::resource('recipes', RecipeController::class);
    Route::resource('recipes.comments', CommentController::class)->shallow();
    Route::post('recipes/{id}/like', [LikeController::class, 'store']);
    Route::delete('recipes/{id}/like', [LikeController::class, 'destroy']);
    Route::post('recipes/{id}/save', [SavedRecipeController::class, 'store']);
    Route::delete('recipes/{id}/save', [SavedRecipeController::class, 'destroy']);
});

Route::get('/user', function (Request $request) {
    return $request->user()->load('likes', 'savedRecipes', 'comments');
})->middleware('auth:sanctum');

Route::middleware(['auth:sanctum'])->group(function () {
    // User-specific data
    Route::get('user/created-recipes', [RecipeController::class, 'userCreatedRecipes']);
    Route::get('user/liked-recipes', [LikeController::class, 'userLikedRecipes']);
    Route::get('user/saved-recipes', [SavedRecipeController::class, 'userSavedRecipes']);
    Route::get('user/commented-recipes', [CommentController::class, 'userCommentedRecipes']);
});

