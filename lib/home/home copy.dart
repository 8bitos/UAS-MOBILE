// import 'package:flutter/material.dart';
// import 'package:uas_cookedex/provider/user_provider.dart';
// import 'package:provider/provider.dart';

// class RecipeSearchDelegate extends SearchDelegate {
//   final List<String> recentSearches;
//   final List<Map<String, String>> lastSeenRecipes;

//   RecipeSearchDelegate({
//     required this.recentSearches,
//     required this.lastSeenRecipes,
//   });

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back, color: Colors.black),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear, color: Colors.black),
//         onPressed: () {
//           query = '';
//           showSuggestions(context);
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Recent Search",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (recentSearches.isEmpty)
//               const Text(
//                 "No recent searches yet.",
//                 style: TextStyle(color: Colors.grey),
//               )
//             else
//               Column(
//                 children: recentSearches.map((search) {
//                   return ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: Text(
//                       search,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () {
//                         recentSearches.remove(search);
//                         showSuggestions(context);
//                       },
//                     ),
//                     onTap: () {
//                       query = search;
//                       showResults(context);
//                     },
//                   );
//                 }).toList(),
//               ),
//             const SizedBox(height: 24),
//             const Text(
//               "Last Seen",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Column(
//               children: lastSeenRecipes.map((recipe) {
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.asset(
//                       recipe["image"]!,
//                       width: 60,
//                       height: 60,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   title: Text(
//                     recipe["title"]!,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Row(
//                     children: [
//                       Text(recipe["time"]!),
//                       const SizedBox(width: 8),
//                       const Icon(Icons.circle, size: 6, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Text(recipe["difficulty"]!),
//                     ],
//                   ),
//                   onTap: () {
//                     close(context, null);
//                     Navigator.pushNamed(
//                       context,
//                       '/recipe-detail',
//                       arguments: {
//                         "title": recipe["title"],
//                         "image": recipe["image"],
//                         "description": recipe["description"],
//                         "time": recipe["time"],
//                         "difficulty": recipe["difficulty"],
//                         "likes": recipe["likes"] ?? 0,
//                         "reviews": recipe["reviews"] ?? 0,
//                         "ingredients": recipe["ingredients"] ?? [],
//                         "steps": recipe["steps"] ?? [],
//                       },
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = recentSearches
//         .where((recipe) => recipe.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     if (query.isNotEmpty && !recentSearches.contains(query)) {
//       recentSearches.insert(0, query);
//     }

//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(results[index]),
//           onTap: () {
//             close(context, null);
//             Navigator.pushNamed(context, '/recipe-detail', arguments: results[index]);
//           },
//         );
//       },
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//   String? selectedCategory;

//   final List<String> _recentSearches = ["Sayur", "Ayam", "Gulai"];
//   final List<Map<String, String>> _lastSeenRecipes = [
//     {
//       "image": "assets/images/recipe1.jpg",
//       "title": "Resep Ayam Kuah Santan Pedas Lezat",
//       "time": "40 min",
//       "difficulty": "Easy",
//     },
//     {
//       "image": "assets/images/recipe2.jpg",
//       "title": "Sup Makaroni Daging Ayam Kampung",
//       "time": "45 min",
//       "difficulty": "Medium",
//     },
//     {
//       "image": "assets/images/recipe3.jpg",
//       "title": "Resep Ayam Geprek Jogja",
//       "time": "30 min",
//       "difficulty": "Easy",
//     },
//   ];

//   void _onItemTapped(int index) {
//     if (index == 1) {
//       showSearch(
//         context: context,
//         delegate: RecipeSearchDelegate(
//           recentSearches: _recentSearches,
//           lastSeenRecipes: _lastSeenRecipes,
//         ),
//       );
//     } else if (index == 3) {
//       Navigator.pushNamed(context, '/notification');
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _addCookbook(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     String? title;
//     String? description;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Add Cookbook"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: const InputDecoration(labelText: "Title"),
//                 onChanged: (value) {
//                   title = value;
//                 },
//               ),
//               TextField(
//                 decoration: const InputDecoration(labelText: "Description"),
//                 onChanged: (value) {
//                   description = value;
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (title != null && description != null) {
//                   userProvider.addCookbook({
//                     "id": DateTime.now().toString(),
//                     "image": "assets/images/cookbook.jpg",
//                     "fallbackImage": "assets/images/default_recipe.jpg",
//                     "title": title!,
//                     "description": description!,
//                     "recipes": [],
//                     "author": userProvider.name,
//                   });
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _onFabClick(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.book),
//               title: const Text("Add Cookbook"),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _addCookbook(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.receipt),
//               title: const Text("Add Recipe"),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushNamed(context, '/add-recipe');
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildNavItem(int index, IconData icon, String label) {
//     bool isSelected = _selectedIndex == index;
//     return InkWell(
//       onTap: () => _onItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.orangeAccent : Colors.grey,
//             size: 24,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: isSelected ? Colors.orangeAccent : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryItem(String imagePath, String title) {
//     bool isSelected = selectedCategory == title;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedCategory = isSelected ? null : title;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(right: 8.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: isSelected ? Colors.orangeAccent : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.asset(
//                   imagePath,
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: isSelected ? Colors.orangeAccent : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final recipes = userProvider.userRecipes;
//     final cookbooks = userProvider.userCookbooks;

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/account');
//                     },
//                     child: const CircleAvatar(
//                       backgroundImage: AssetImage('assets/images/profile.png'),
//                       radius: 25,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Consumer<UserProvider>(
//                     builder: (context, userProvider, child) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Hi ${userProvider.name}",
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           const Text(
//                             "What are you cooking today?",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 300,
//               child: Consumer<UserProvider>(
//                 builder: (context, userProvider, child) {
//                   final cookbooks = userProvider.userCookbooks;
//                   return cookbooks.isEmpty
//                       ? const Center(
//                           child: Text(
//                             "No cookbooks yet. Create one!",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         )
//                       : PageView.builder(
//                           controller: PageController(viewportFraction: 0.9),
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: cookbooks.length,
//                           itemBuilder: (context, index) {
//                             final cookbook = cookbooks[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 if (cookbook['id'] != null) {
//                                   Navigator.pushNamed(
//                                     context,
//                                     '/cookbook-detail',
//                                     arguments: {
//                                       'title': cookbook['title'] ?? 'Untitled',
//                                       'description':
//                                           cookbook['description'] ?? 'No description',
//                                       'photo': cookbook['image'] ??
//                                           "assets/images/cookbook1.jpg",
//                                       'cookbookId': cookbook['id'],
//                                     },
//                                   );
//                                 }
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   elevation: 4,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     children: [
//                                       Expanded(
//                                         child: ClipRRect(
//                                           borderRadius: const BorderRadius.vertical(
//                                             top: Radius.circular(16),
//                                           ),
//                                           child: Image.asset(
//                                             cookbook["image"] ??
//                                                 "assets/images/cookbook1.jpg",
//                                             fit: BoxFit.cover,
//                                             width: double.infinity,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(16.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               cookbook["title"] ?? "No Title",
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16,
//                                                 color: Colors.black,
//                                               ),
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             const SizedBox(height: 8),
//                                             Text(
//                                               cookbook["description"] ?? "No Description",
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.grey,
//                                               ),
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                             const SizedBox(height: 16),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     const Icon(
//                                                       Icons.book_outlined,
//                                                       size: 16,
//                                                       color: Colors.grey,
//                                                     ),
//                                                     const SizedBox(width: 4),
//                                                     Text(
//                                                       "${(cookbook['recipes'] as List?)?.length ?? 0} Recipes",
//                                                       style: const TextStyle(
//                                                         fontSize: 14,
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Text(
//                                                   "By ${cookbook['author'] ?? 'Unknown'}",
//                                                   style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: Colors.grey,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                 },
//               ),
//             ),
            
//             // Community Recipes Section
//             Padding(
//               padding: const EdgeInsets.only(top: 43.0, left: 16.0, right: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Featured Community Recipes",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Get lots of recipe inspiration from the community",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   ...recipes.where((recipe) {
//                     if (selectedCategory == null) return true;
//                     return recipe['category'] == selectedCategory;
//                   }).map((communityRecipe) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           '/recipe-detail',
//                           arguments: {
//                             'title': communityRecipe['title'],
//                             'image': communityRecipe['image'],
//                             'description': communityRecipe['description'],
//                             'time': communityRecipe['time'],
//                             'difficulty': communityRecipe['difficulty'],
//                             'ingredients': communityRecipe['ingredients'] ?? [],
//                             'steps': communityRecipe['steps'] ?? [],
//                             'category': communityRecipe['category'] ?? 'Everyday',
//                           },
//                         );
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.asset(
//                               communityRecipe["image"]!,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     communityRecipe["title"]!,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "by ${communityRecipe["author"]}",
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       Text(
//                                         "${communityRecipe["likes"]} Likes",
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/community-recipes');
//                     },
//                     child: const Text(
//                       "See All Recipes by Community",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.orangeAccent,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Category Section
//             Padding(
//               padding: const EdgeInsets.only(top: 43.0, left: 24.0, right: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Category",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 80.0),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           _buildCategoryItem('assets/images/category1.jpg', 'Seasonal'),
//                           _buildCategoryItem('assets/images/category2.jpg', 'Cakes'),
//                           _buildCategoryItem('assets/images/category3.jpg', 'Everyday'),
//                           _buildCategoryItem('assets/images/category4.jpg', 'Drinks'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _onFabClick(context),
//         backgroundColor: Colors.orangeAccent,
//         child: const Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8,
//         child: Container(
//           height: 60,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Left side
//               Row(
//                 children: [
//                   _buildNavItem(0, Icons.home_outlined, "Home"),
//                   const SizedBox(width: 32),
//                   _buildNavItem(1, Icons.search_outlined, "Search"),
//                 ],
//               ),
//               // Right side
//               Row(
//                 children: [
//                   _buildNavItem(3, Icons.notifications_outlined, "Notifications"),
//                   const SizedBox(width: 32),
//                   _buildNavItem(2, Icons.chat_bubble_outline, "Chat"),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }