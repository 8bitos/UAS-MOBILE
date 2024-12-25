import 'package:flutter/material.dart';
import 'auth_screen.dart'; // Pastikan auth_screen.dart sudah ada

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "image": "assets/images/splash1.jpg",
      "title": "MAKE RECIPES YOUR OWN",
      "description":
          "With Cookédex recipe editor, you can easily edit recipes and save adjustments to ingredients.",
    },
    {
      "image": "assets/images/splash2.jpg",
      "title": "ALL IN ONE PLACE",
      "description":
          "Storing your recipes in Cookédex allows you to quickly search, find, and select what you want to cook.",
    },
    {
      "image": "assets/images/splash3.jpg",
      "title": "COOK FROM YOUR FAVORITE DEVICE",
      "description":
          "Cookédex stores your recipes in the cloud so you can access them anywhere, anytime.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background PageView
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              _pageController.position.moveTo(
                _pageController.position.pixels - details.delta.dx,
              );
            },
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: splashData.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  splashData[index]["image"]!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: const Alignment(0.78, 0.0),
                );
              },
            ),
          ),

          // White Box Content
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              ignoring: true, // Abaikan pointer agar PageView tetap menerima gesture
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      splashData[_currentPage]["title"]!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      splashData[_currentPage]["description"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Skip Button
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Membuat bold
                  color: Colors.orangeAccent,  // Warna tetap orange
                ),
              ),
            ),
          ),

          // Dots Indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.orangeAccent
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // Get Started Button (Last Page Only)
          if (_currentPage == splashData.length - 1)
            Positioned(
              bottom: 40,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Membuat tulisan bold
                    color: Colors.white,         // Warna tulisan putih
                    fontSize: 16,                // Ukuran font
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
