import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = "Nararaya Kirana";
  String _bio = "Rajin menabung dan suka memasak";

  // Data for cookbooks and recipes
  List<Map<String, dynamic>> _userCookbooks = [];
  List<Map<String, dynamic>> _userRecipes = [];

  // Getters for name, bio, cookbooks, and recipes
  String get name => _name;
  String get bio => _bio;
  List<Map<String, dynamic>> get userCookbooks => _userCookbooks;
  List<Map<String, dynamic>> get userRecipes => _userRecipes;

Map<String, dynamic>? getCookbookById(String cookbookId) {
  try {
    // Use firstWhere with a fallback empty map instead of null
    final cookbook = _userCookbooks.firstWhere(
      (cookbook) => cookbook['id'] == cookbookId,
      orElse: () => {}, // Return an empty map if no cookbook is found
    );

    // If cookbook is empty (not found), return null
    if (cookbook.isEmpty) {
      return null;
    }
    return cookbook;
  } catch (e) {
    return null; // Return null in case of any unexpected error
  }
}


  // Update profile
  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  
  // Add a new cookbook
  void addCookbook(Map<String, dynamic> cookbook) {
    _userCookbooks.add({
      ...cookbook,
      "recipes": [], // Add an empty list of recipes for this cookbook
    });
    notifyListeners();
  }

  // Update a recipe
  void updateRecipe(Map<String, dynamic> oldRecipe, Map<String, dynamic> updatedRecipe) {
    final index = _userRecipes.indexOf(oldRecipe);
    if (index != -1) {
      _userRecipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  // Edit a cookbook (update title, description, or image)
  void editCookbook(int index, Map<String, dynamic> updatedCookbook) {
    _userCookbooks[index] = updatedCookbook;
    notifyListeners();
  }

   void deleteCookbook(Map<String, dynamic> cookbook) {
    _userCookbooks.removeWhere((item) => item['title'] == cookbook['title']);
    notifyListeners();
  }

  void deleteRecipe(Map<String, dynamic> recipe) {
    // Try to match by title and description
    _userRecipes.removeWhere((item) => 
      item['title'] == recipe['title'] && 
      item['description'] == recipe['description']
    );
    notifyListeners();
  }
  

  // Add a new recipe
  void addRecipe(Map<String, dynamic> recipe) {
    _userRecipes.add(recipe);
    notifyListeners();
  }

void addRecipeToCookbook(String cookbookId, List<Map<String, dynamic>> recipesToAdd) {
  final index = _userCookbooks.indexWhere((cookbook) => cookbook['id'] == cookbookId);
  if (index != -1) {
    // Create a new map to avoid reference issues
    Map<String, dynamic> updatedCookbook = Map.from(_userCookbooks[index]);
    
    // Ensure recipes exist
    if (!updatedCookbook.containsKey('recipes')) {
      updatedCookbook['recipes'] = [];
    }
    
    // Get current recipes and add new ones
    List<Map<String, dynamic>> currentRecipes = 
        List<Map<String, dynamic>>.from(updatedCookbook['recipes']);
    currentRecipes.addAll(recipesToAdd);
    
    // Update the cookbook
    updatedCookbook['recipes'] = currentRecipes;
    _userCookbooks[index] = updatedCookbook;
    
    notifyListeners();
    print('Added ${recipesToAdd.length} recipes to cookbook. Total recipes: ${currentRecipes.length}');
  } else {
    print('Cookbook with ID $cookbookId not found');
  }
}


  // Delete a recipe from a specific cookbook
  void deleteRecipeFromCookbook(int cookbookIndex, int recipeIndex) {
    _userCookbooks[cookbookIndex]['recipes'].removeAt(recipeIndex);
    notifyListeners();
  }
}

