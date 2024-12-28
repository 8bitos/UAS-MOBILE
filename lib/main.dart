import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_cookedex/account/acc_edit.dart';
import 'package:uas_cookedex/community/community.dart';
import 'package:uas_cookedex/community/detailed_recipe.dart';
import 'package:uas_cookedex/cookbook/edit_cookbook.dart';
import 'package:uas_cookedex/home/notification.dart';
import 'package:uas_cookedex/screens/splash_screen.dart';
import 'package:uas_cookedex/home/home.dart'; // Import HomePage
import 'package:uas_cookedex/account/acc_page.dart';
import 'package:uas_cookedex/account/acc_setting.dart';
import 'cookbook/cookbook_detailed.dart';
import 'community/review_page.dart';
import 'community/grocery_list.dart';
import 'community/edit_recipe.dart';
import 'community/add_recipe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookédex',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => const SplashScreen(), 
        '/home': (context) => const HomePage(),
        '/account': (context) => const AccountPage(),
        '/notification': (context) => const NotificationPage(),
        '/community-recipes': (context) => const CommunityPage(),
        '/acc-setting': (context) => const AccSettingPage(),
        '/edit-profile': (context) => EditProfilePage(
            initialData: {
              'name': 'Nararaya Kirana', // Replace with actual default data or variables
              'bio': 'Rajin menabung dan suka memasak',
              'profileImage': 'assets/images/profile.png',
              'coverImage': 'assets/images/profile_cover.png',
            },
          ),
        '/recipe-detail': (context) => const RecipeDetailPage(),
        '/add-recipe': (context) => const AddRecipePage(),
        '/cookbook-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CookbookDetailPage(
            title: args['title'],
            recipes: args['recipes'],
          );
        },
        '/cookbook-edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CookbookEditPage(
            photo: args['photo'],
            title: args['title'],
            description: args['description'],
          );
        },
        '/reviews': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
            final reviews = args.cast<Map<String, String>>(); // Safely cast to the correct type
            return ReviewsPage(reviews: reviews);
          },
        '/grocery-list': (context) {
            final ingredients = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;
            return GroceryListPage(initialIngredients: ingredients);
          },
        '/edit-recipe': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

              if (args == null || !args.containsKey('recipe')) {
                return const Center(
                  child: Text('No recipe data passed!'),
                );
              }

              return EditRecipePage(recipe: args['recipe']);
            },
      },
    );
  }
}
