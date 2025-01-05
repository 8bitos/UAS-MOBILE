<?php

namespace App\Http\Controllers;

use App\Models\Resep;
use Illuminate\Http\Request;

class ResepController extends Controller
{
    // Menampilkan daftar resep
    public function index()
    {
        $reseps = Resep::all();
        return response()->json($reseps, 200);
    }

    // Menambahkan resep baru
    public function store(Request $request)
    {
        $request->validate([
            'nama_makanan' => 'required|string|max:255',
            'resep' => 'required|string',
            'deskripsi' => 'required|string',
            'rating' => 'required|numeric|min:0|max:5',
        ]);

        $resep = Resep::create($request->all());

        return response()->json([
            'message' => 'Resep berhasil ditambahkan!',
            'data' => $resep
        ], 201);
    }

    // Menampilkan detail resep tertentu
    public function show($id)
    {
        $resep = Resep::find($id);

        if (!$resep) {
            return response()->json(['message' => 'Resep tidak ditemukan!'], 404);
        }

        return response()->json($resep, 200);
    }

    // Memperbarui resep
    public function update(Request $request, $id)
    {
        $resep = Resep::find($id);

        if (!$resep) {
            return response()->json(['message' => 'Resep tidak ditemukan!'], 404);
        }

        $request->validate([
            'nama_makanan' => 'required|string|max:255',
            'resep' => 'required|string',
            'deskripsi' => 'required|string',
            'rating' => 'required|numeric|min:0|max:5',
        ]);

        $resep->update($request->all());

        return response()->json([
            'message' => 'Resep berhasil diperbarui!',
            'data' => $resep
        ], 200);
    }

    // Menghapus resep
    public function destroy($id)
    {
        $resep = Resep::find($id);

        if (!$resep) {
            return response()->json(['message' => 'Resep tidak ditemukan!'], 404);
        }

        $resep->delete();

        return response()->json(['message' => 'Resep berhasil dihapus!'], 200);
    }
}