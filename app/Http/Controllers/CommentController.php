<?php
namespace App\Http\Controllers;

use App\Models\Comment;
use App\Models\Recipe;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function index(Recipe $recipe)
    {
        return $recipe->comments()->with('user')->get();
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
}
