class Recipe {
  final int id;
  final String title;
  final String description;
  final String ingredients;
  final String steps;
  // Assuming this is part of the response

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  // Factory method to convert JSON to Recipe
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      ingredients: json['ingredients'],
      steps: json['steps'],

      // Handle null if image_url is not in response
    );
  }
}
