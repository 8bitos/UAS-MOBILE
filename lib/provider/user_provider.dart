import 'package:flutter/material.dart';
import '../provider/notification_service.dart';

class UserProvider with ChangeNotifier {
  String _name = "Nararaya Kirana";
  String _bio = "Rajin menabung dan suka memasak";
  final String _profileImage = "assets/images/profile.png";

  // Data for cookbooks and recipes
  final List<Map<String, dynamic>> _userCookbooks = [];
  final List<Map<String, dynamic>> _userRecipes = [];

  // Tambahkan data untuk reviews dan notifications
  final List<Map<String, dynamic>> _userReviews = [];
  final List<Map<String, dynamic>> _notifications = [];

  // Getters
  String get name => _name;
  String get bio => _bio;
  String get profileImage => _profileImage;
  List<Map<String, dynamic>> get userCookbooks => _userCookbooks;
  List<Map<String, dynamic>> get userRecipes => _userRecipes;
  List<Map<String, dynamic>> get userReviews => _userReviews;
  List<Map<String, dynamic>> get notifications => _notifications;

  // Function to get cookbook by id
  Map<String, dynamic>? getCookbookById(String cookbookId) {
    try {
      final cookbook = _userCookbooks.firstWhere(
        (cookbook) => cookbook['id'] == cookbookId,
        orElse: () => {},
      );
      return cookbook.isEmpty ? null : cookbook;
    } catch (e) {
      return null;
    }
  }

  // Update name and bio
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
    if (cookbook.isNotEmpty) {
      _userCookbooks.add({
        ...cookbook,
        "recipes": [],
      });
      notifyListeners();
    }
  }

  // Update recipe
  void updateRecipe(String title, Map<String, dynamic> updatedRecipe) {
    final index = _userRecipes.indexWhere((recipe) => recipe['title'] == title);
    if (index != -1) {
      // Update recipe, ensuring no missing fields
      _userRecipes[index] = {
        ..._userRecipes[index],
        'title': updatedRecipe['title'] ?? _userRecipes[index]['title'],
        'description':
            updatedRecipe['description'] ?? _userRecipes[index]['description'],
        'ingredients':
            updatedRecipe['ingredients'] ?? _userRecipes[index]['ingredients'],
        'steps': updatedRecipe['steps'] ?? _userRecipes[index]['steps'],
        'difficulty':
            updatedRecipe['difficulty'] ?? _userRecipes[index]['difficulty'],
        'time': updatedRecipe['time'] ?? _userRecipes[index]['time'],
        'category':
            updatedRecipe['category'] ?? _userRecipes[index]['category'],
        'image': updatedRecipe['image'] ?? _userRecipes[index]['image'],
        'author': updatedRecipe['author'] ?? _userRecipes[index]['author'],
      };
      notifyListeners();
    }
  }

  // Edit cookbook
  void editCookbook(int index, Map<String, dynamic> updatedCookbook) {
    if (index >= 0 && index < _userCookbooks.length) {
      _userCookbooks[index] = updatedCookbook;
      notifyListeners();
    }
  }

  // Delete a cookbook
  void deleteCookbook(Map<String, dynamic> cookbook) {
    _userCookbooks.removeWhere((item) => item['title'] == cookbook['title']);
    notifyListeners();
  }

  // Delete a recipe
  void deleteRecipe(Map<String, dynamic> recipe) {
    _userRecipes.removeWhere((item) =>
        item['title'] == recipe['title'] &&
        item['description'] == recipe['description']);
    notifyListeners();
  }

  // Add a recipe
  void addRecipe(Map<String, dynamic> recipe) {
    if (recipe.isNotEmpty) {
      _userRecipes.add(recipe);
      notifyListeners();
    }
  }

  // Add recipe to cookbook
  void addRecipeToCookbook(
      String cookbookId, List<Map<String, dynamic>> recipesToAdd) {
    final index =
        _userCookbooks.indexWhere((cookbook) => cookbook['id'] == cookbookId);
    if (index != -1) {
      Map<String, dynamic> updatedCookbook = Map.from(_userCookbooks[index]);
      if (!updatedCookbook.containsKey('recipes')) {
        updatedCookbook['recipes'] = [];
      }
      List<Map<String, dynamic>> currentRecipes =
          List<Map<String, dynamic>>.from(updatedCookbook['recipes']);
      currentRecipes.addAll(recipesToAdd);
      updatedCookbook['recipes'] = currentRecipes;
      _userCookbooks[index] = updatedCookbook;
      notifyListeners();
    }
  }

  // Delete a recipe from cookbook
  void deleteRecipeFromCookbook(int cookbookIndex, int recipeIndex) {
    if (cookbookIndex >= 0 && cookbookIndex < _userCookbooks.length) {
      var recipes = _userCookbooks[cookbookIndex]['recipes'];
      if (recipeIndex >= 0 && recipeIndex < recipes.length) {
        recipes.removeAt(recipeIndex);
        notifyListeners();
      }
    }
  }

  // Add a review and trigger a notification
  void addReview(Map<String, dynamic> review) {
    if (review.isNotEmpty) {
      _userReviews.add(review);

      _notifications.add({
        'type': 'review',
        'title': 'New Review Added',
        'message':
            'You reviewed ${review['recipeTitle']} with ${review['rating']} stars',
        'timestamp': DateTime.now().toString(),
        'isRead': false,
      });

      NotificationService.showNotification(
        title: 'New Review Added',
        body:
            'You reviewed ${review['recipeTitle']} with ${review['rating']} stars',
      );

      notifyListeners();
    }
  }

  // Delete a review
  void deleteReview(Map<String, dynamic> review) {
    _userReviews.removeWhere((item) =>
        item['recipeTitle'] == review['recipeTitle'] &&
        item['timestamp'] == review['timestamp']);
    notifyListeners();
  }

  // Mark a notification as read
  void markNotificationAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }

  // Clear a notification
  void clearNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }
}
