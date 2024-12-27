import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedCategory = -1; // Default: none selected
  int _selectedSort = -1; // Default: none selected
  bool _isFiltered = false;

  final List<String> categories = ['Seasonal', 'Cakes', 'Everyday', 'Drinks'];
  final List<String> categoryImages = [
    'assets/images/category1.jpg',
    'assets/images/category2.jpg',
    'assets/images/category3.jpg',
    'assets/images/category4.jpg',
  ];

  final List<String> sortOptions = [
    'Relevancy',
    'Popular',
    'Commented',
    'Preparation Time',
    'Appreciation'
  ];

  final List<Map<String, String>> communityItems = [
    {
      'title': 'Resep Sayur Asem Betawi En',
      'author': 'Susanti',
      'reviews': '103 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Resep Tumis Bunga Pepaya...',
      'author': 'Maharani',
      'reviews': '453 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Resep Sayur Bebanci...',
      'author': 'Anindya',
      'reviews': '34 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Resep Sayur Labu Kuning...',
      'author': 'Cyntia',
      'reviews': '586 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Resep Kembang Kol Masak...',
      'author': 'Mulyani',
      'reviews': '123 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
    {
      'title': 'Resep Brokoli Saus Tiram',
      'author': 'Dea Putri',
      'reviews': '207 Reviews',
      'image': 'https://via.placeholder.com/150'
    },
  ];

  void _showFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Options',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Category Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(categories.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = index; // Update the selected category
                              });
                              setStateModal(() {
                                _selectedCategory = index; // Update for popup
                              });
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(categoryImages[index]),
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: _selectedCategory == index
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.orangeAccent,
                                              width: 3,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  categories[index],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: _selectedCategory == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: _selectedCategory == index
                                        ? Colors.orangeAccent
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sort By Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      DropdownButton<int>(
                        value: _selectedSort >= 0 ? _selectedSort : null,
                        isExpanded: true,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSort = newValue!;
                          });
                          setStateModal(() {
                            _selectedSort = newValue!;
                          });
                        },
                        items: List.generate(sortOptions.length, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text(
                              sortOptions[index],
                              style: TextStyle(
                                fontWeight: _selectedSort == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedSort == index
                                    ? Colors.orangeAccent
                                    : Colors.black,
                              ),
                            ),
                          );
                        }),
                        hint: const Text('Select Sort Option'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Apply Filter Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isFiltered = true;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filter'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Community', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: _isFiltered ? Colors.orangeAccent : Colors.black,
            ),
            onPressed: () => _showFilterPopup(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: communityItems.length,
          itemBuilder: (context, index) {
            final item = communityItems[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      item['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['author']} · ${item['reviews']}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
