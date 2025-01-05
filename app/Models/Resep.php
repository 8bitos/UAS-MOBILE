<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Resep extends Model
{
    // Properti yang dapat diisi (mass-assignable)
    protected $fillable = [
        'nama_makanan',
        'resep',
        'deskripsi',
        'rating',
    ];
}