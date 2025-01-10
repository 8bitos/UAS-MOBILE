<?php
namespace App\Http\Controllers;

use App\Models\Like;
use App\Models\Recipe;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    public function store(Request $request, $id)
    {
        $recipe = Recipe::findOrFail($id);
    
        // Menambahkan like hanya jika belum ada
        $like = Like::firstOrCreate([
            'user_id' => auth()->id(),
            'recipe_id' => $recipe->id,
        ]);
    
        return response()->json(['message' => 'Recipe liked successfully']);
    }
    
    public function destroy($id)
    {
        $recipe = Recipe::findOrFail($id);
    
        $like = Like::where('user_id', auth()->id())
            ->where('recipe_id', $recipe->id)
            ->first();
    
        if (!$like) {
            return response()->json(['message' => 'Like not found'], 404);
        }
    
        $like->delete();
        return response()->json(['message' => 'Like removed successfully']);
    }
    public function userLikedRecipes()
{
    $userId = auth()->id();
    $likedRecipes = Recipe::whereHas('likes', function ($query) use ($userId) {
        $query->where('user_id', $userId);
    })->withCount(['likes', 'comments', 'savedByUsers as saved_by_count'])->get();

    return response()->json($likedRecipes);
}

}
