import 'package:flutter/material.dart';
import '../provider/notification_service.dart';

class UserProvider with ChangeNotifier {
  String _name = "Nararaya Kirana";
  String _bio = "Rajin menabung dan suka memasak";
  String _profileImage = "assets/images/profile.png";

  // Data for cookbooks and recipes
  List<Map<String, dynamic>> _userCookbooks = [];
  List<Map<String, dynamic>> _userRecipes = [];
  
  // Tambahkan data untuk reviews dan notifications
  List<Map<String, dynamic>> _userReviews = [];
  List<Map<String, dynamic>> _notifications = [];

  // Getters yang sudah ada
  String get name => _name;
  String get bio => _bio;
  String get profileImage => _profileImage;
  List<Map<String, dynamic>> get userCookbooks => _userCookbooks;
  List<Map<String, dynamic>> get userRecipes => _userRecipes;
  
  // Tambahkan getter untuk reviews dan notifications
  List<Map<String, dynamic>> get userReviews => _userReviews;
  List<Map<String, dynamic>> get notifications => _notifications;

  // Semua fungsi yang sudah ada tetap sama
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

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void addCookbook(Map<String, dynamic> cookbook) {
    _userCookbooks.add({
      ...cookbook,
      "recipes": [],
    });
    notifyListeners();
  }

  void updateRecipe(String title, Map<String, dynamic> updatedRecipe) {
    final index = _userRecipes.indexWhere((recipe) => recipe['title'] == title);
    if (index != -1) {
      // Update resep dengan mempertahankan data yang tidak diubah
      _userRecipes[index] = {
        ..._userRecipes[index], // Pertahankan data lama
        'title': updatedRecipe['title'],
        'description': updatedRecipe['description'],
        'ingredients': updatedRecipe['ingredients'],
        'steps': updatedRecipe['steps'],
        'difficulty': updatedRecipe['difficulty'],
        'time': updatedRecipe['time'],
        'category': updatedRecipe['category'],
        'image': updatedRecipe['image'],
        'author': updatedRecipe['author'],
      };
      notifyListeners();
    }
  }


  void editCookbook(int index, Map<String, dynamic> updatedCookbook) {
    _userCookbooks[index] = updatedCookbook;
    notifyListeners();
  }

  void deleteCookbook(Map<String, dynamic> cookbook) {
    _userCookbooks.removeWhere((item) => item['title'] == cookbook['title']);
    notifyListeners();
  }

  void deleteRecipe(Map<String, dynamic> recipe) {
    _userRecipes.removeWhere((item) => 
      item['title'] == recipe['title'] && 
      item['description'] == recipe['description']
    );
    notifyListeners();
  }

  

  void addRecipe(Map<String, dynamic> recipe) {
    _userRecipes.add(recipe);
    notifyListeners();
  }

  void addRecipeToCookbook(String cookbookId, List<Map<String, dynamic>> recipesToAdd) {
    final index = _userCookbooks.indexWhere((cookbook) => cookbook['id'] == cookbookId);
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

  void deleteRecipeFromCookbook(int cookbookIndex, int recipeIndex) {
    _userCookbooks[cookbookIndex]['recipes'].removeAt(recipeIndex);
    notifyListeners();
  }

 void addReview(Map<String, dynamic> review) {
  _userReviews.add(review);
  
  _notifications.add({
    'type': 'review',
    'title': 'New Review Added',
    'message': 'You reviewed ${review['recipeTitle']} with ${review['rating']} stars',
    'timestamp': DateTime.now().toString(),
    'isRead': false,
  });
  
  NotificationService.showNotification(
    title: 'New Review Added',
    body: 'You reviewed ${review['recipeTitle']} with ${review['rating']} stars',
  );
  
  notifyListeners();
}

  void deleteReview(Map<String, dynamic> review) {
    _userReviews.removeWhere((item) => 
      item['recipeTitle'] == review['recipeTitle'] && 
      item['timestamp'] == review['timestamp']
    );
    notifyListeners();
  }

  // Tambahkan fungsi untuk notifications
  void markNotificationAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }

  void clearNotification(int index) {
    if (index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }
}