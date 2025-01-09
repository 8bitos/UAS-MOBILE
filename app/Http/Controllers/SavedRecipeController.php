<?php
namespace App\Http\Controllers;

use App\Models\Recipe;
use Illuminate\Http\Request;

class SavedRecipeController extends Controller
{
    public function index()
    {
        return auth()->user()->savedRecipes()->with('user')->get();
    }

    public function store(Request $request, $id)
{
    $recipe = Recipe::findOrFail($id);
    auth()->user()->savedRecipes()->syncWithoutDetaching($recipe->id);

    return response()->json(['message' => 'Recipe saved successfully']);
}

public function destroy($id)
{
    $recipe = Recipe::findOrFail($id);
    auth()->user()->savedRecipes()->detach($recipe->id);

    return response()->json(['message' => 'Recipe unsaved successfully']);
}

}
