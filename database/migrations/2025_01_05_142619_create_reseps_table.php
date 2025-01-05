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
        Schema::create('reseps', function (Blueprint $table) {
            $table->id();
            $table->string('nama_makanan')->unique(); // Nama makanan harus unik
            $table->text('resep');
            $table->text('deskripsi')->nullable(); // Deskripsi boleh kosong
            $table->decimal('rating', 3, 1)->default(0) // Mengizinkan rating hingga 10 dengan satu angka desimal
                  ->check('rating >= 1.0 AND rating <= 5.0'); // Batas rating 1.0 - 5.0
            $table->timestamps();

            // Menambahkan indeks untuk kolom nama_makanan
            $table->index('nama_makanan');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reseps');
    }
};