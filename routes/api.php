<?php

use App\Http\Controllers\ResepController;
use Illuminate\Support\Facades\Route;

// Route API untuk ResepController
Route::get('/reseps', [ResepController::class, 'index']); // Menampilkan semua resep
Route::post('/reseps', [ResepController::class, 'store']); // Menambahkan resep baru
Route::get('/reseps/{id}', [ResepController::class, 'show']); // Menampilkan detail resep berdasarkan ID
Route::put('/reseps/{id}', [ResepController::class, 'update']); // Memperbarui resep berdasarkan ID
Route::delete('/reseps/{id}', [ResepController::class, 'destroy']); // Menghapus resep berdasarkan ID