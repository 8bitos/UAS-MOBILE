import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

void showReviewDialog(BuildContext context, String recipeTitle) {
  double rating = 0;
  String review = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Review $recipeTitle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating Stars
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.orangeAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 16),
            // Review Text Field
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                review = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
            ),
            onPressed: () {
              if (rating == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a rating')),
                );
                return;
              }
              if (review.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please write a review')),
                );
                return;
              }

              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final currentUser = userProvider.name;
              
              // Add review with user information
              userProvider.addReview({
                'recipeTitle': recipeTitle,
                'reviewText': review,
                'rating': rating,
                'timestamp': DateTime.now().toString(),
                'userName': currentUser,
                'userImage': 'assets/images/profile.png', // Use user's profile image
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Review added successfully')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}