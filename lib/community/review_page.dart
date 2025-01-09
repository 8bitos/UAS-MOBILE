import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class ReviewsPage extends StatefulWidget {
  final String recipeTitle;
  final double rating;
  final List<Map<String, dynamic>> reviews;

  const ReviewsPage({
    Key? key,
    required this.recipeTitle,
    required this.rating,
    required this.reviews,
  }) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Reviews (${widget.reviews.length})",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Recipe Rating Summary
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  widget.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                          size: 24,
                        );
                      }),
                    ),
                    Text(
                      "${widget.reviews.length} Reviews",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Add Review Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return IconButton(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        index < _userRating ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          _userRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    hintText: 'Write your review...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userRating > 0 &&
                          _reviewController.text.isNotEmpty) {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        // Buat review baru
                        final newReview = {
                          'recipeTitle': widget.recipeTitle,
                          'rating': _userRating,
                          'content': _reviewController.text,
                          'author': userProvider.name,
                          'authorImage': userProvider.profileImage,
                          'timestamp': DateTime.now().toString(),
                        };

                        // Tambah ke provider
                        userProvider.addReview(newReview);

                        // Tambah ke list lokal
                        setState(() {
                          widget.reviews.insert(0, newReview);
                        });

                        // Reset form
                        _reviewController.clear();
                        setState(() {
                          _userRating = 0;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Review added successfully!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Post Review'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Reviews List
          Expanded(
            child: ListView.separated(
              itemCount: widget.reviews.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final review = widget.reviews[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(review['authorImage'] ??
                                'assets/images/profile.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        review['author'] ?? 'Anonymous',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      review['timestamp'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (review['author'] ==
                                        Provider.of<UserProvider>(context).name)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          // Hapus dari provider
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .deleteReview(review);

                                          // Hapus dari list lokal
                                          setState(() {
                                            widget.reviews.removeWhere((r) =>
                                                r['timestamp'] ==
                                                    review['timestamp'] &&
                                                r['author'] ==
                                                    review['author']);
                                          });
                                        },
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < (review['rating'] ?? 0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 16,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 4),
                                Text(review['content'] ?? ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
