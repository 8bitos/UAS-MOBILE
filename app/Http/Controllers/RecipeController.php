<?php
namespace App\Http\Controllers;
use App\Models\Image;
use App\Models\Recipe;
use Illuminate\Http\Request;

class RecipeController extends Controller
{
  // RecipeController.php

  public function index()
  {
      $userId = auth()->id();
      return Recipe::with('user')
          ->withCount(['likes', 'comments', 'savedByUsers as saved_by_count'])
          ->get()
          ->map(function ($recipe) use ($userId) {
              $recipe['is_liked'] = $recipe->likes->contains('user_id', $userId);
              $recipe['is_saved'] = $recipe->savedByUsers->contains('id', $userId);
              return $recipe;
          });
  }
  
  

  public function store(Request $request)
  {
      $validated = $request->validate([
          'title' => 'required|string',
          'description' => 'required|string',
          'ingredients' => 'required|string',
          'steps' => 'required|string',
          'image' => 'nullable|image|max:2048', // Validate that the file is an image
      ]);
  
      // Handle image upload if it exists
      $imagePath = null;
      if ($request->hasFile('image')) {
          $image = $request->file('image');
          $imageName = time() . '.' . $image->getClientOriginalExtension(); // Get original file extension
          $imagePath = $image->storeAs('images', $imageName, 'public'); // Store in 'public/images'
      }
  
      // Create the recipe record in the database
      $recipe = Recipe::create([
          'user_id' => auth()->id(),
          'title' => $validated['title'],
          'description' => $validated['description'],
          'ingredients' => $validated['ingredients'],
          'steps' => $validated['steps'],
          'image' => $imagePath, // Store the image path in the database
      ]);
  
      return response()->json($recipe, 201);
  }
  
  
  
  
  
  
  public function update(Request $request, Recipe $recipe)
  {
      if ($recipe->user_id !== auth()->id()) {
          return response()->json(['message' => 'Unauthorized'], 403);
      }
  
      $validated = $request->validate([
          'title' => 'sometimes|string',
          'description' => 'sometimes|string',
          'ingredients' => 'sometimes|string',
          'steps' => 'sometimes|string',
          'image' => 'nullable|image|max:2048', // Validasi gambar
      ]);
  
      if ($request->hasFile('image')) {
          $path = $request->file('image')->store('recipes', 'public');
          $validated['image'] = $path;
      }
  
      $recipe->update($validated);
      return response()->json($recipe);
  }
  

    public function destroy(Recipe $recipe)
    {
        if ($recipe->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $recipe->delete();
        return response()->json(['message' => 'Recipe deleted successfully']);
    }
}
