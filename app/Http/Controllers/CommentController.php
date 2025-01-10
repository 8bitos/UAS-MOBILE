<?php
namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Recipe;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function index($recipeId)
    {
        $recipe = Recipe::findOrFail($recipeId);
        $comments = $recipe->comments()->with('user')->get();

        return response()->json($comments);
    }

    public function store(Request $request, Recipe $recipe)
    {
        $validated = $request->validate([
            'content' => 'required|string',
        ]);

        $comment = $recipe->comments()->create([
            'user_id' => auth()->id(),
            'content' => $validated['content'],
        ]);

        return response()->json($comment, 201);
    }

    public function destroy(Comment $comment)
    {
        if ($comment->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $comment->delete();
        return response()->json(['message' => 'Comment deleted successfully']);
    }
    public function userCommentedRecipes()
{
    $userId = auth()->id();
    $commentedRecipes = Recipe::whereHas('comments', function ($query) use ($userId) {
        $query->where('user_id', $userId);
    })->withCount(['likes', 'comments', 'savedByUsers as saved_by_count'])->get();

    return response()->json($commentedRecipes);
}

}
