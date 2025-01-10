import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_cookedex/home/tes.dart';
import 'provider/user_provider.dart'; // Alias for main UserProvider
import 'package:provider/provider.dart';
import 'package:uas_cookedex/account/acc_credentials_edit.dart';
import 'package:uas_cookedex/account/acc_edit.dart';
import 'package:uas_cookedex/community/community.dart';
import 'package:uas_cookedex/community/detailed_recipe.dart';
import 'package:uas_cookedex/cookbook/edit_cookbook.dart';
import 'package:uas_cookedex/home/notification.dart';
import 'package:uas_cookedex/screens/splash_screen.dart';
import 'package:uas_cookedex/home/home.dart';
import 'package:uas_cookedex/account/acc_page.dart';
import 'package:uas_cookedex/account/acc_setting.dart';
import 'cookbook/cookbook_detailed.dart'; // Alias for cookbook_detailed
import 'community/review_page.dart';
import 'community/grocery_list.dart';
import 'community/edit_recipe.dart';
import 'community/add_recipe.dart';
import 'screens/auth_screen.dart';
import 'screens/forgot_pass_screen.dart';
import 'provider/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookédex',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/authscreen': (context) => const AuthScreen(),
        '/home': (context) => HomePage(),
        '/account': (context) => AccountPage(),
        '/notification': (context) => const NotificationPage(),
        '/community-recipes': (context) => const CommunityPage(),
        '/acc-setting': (context) => const AccSettingPage(),
        '/acc-credentials': (context) => AccountCredentialsPage(),
        '/forgot-pass': (context) => const ForgotPasswordScreen(),
        '/edit-profile': (context) => const EditProfilePage(
              initialData: {
                'name': 'Nararaya Kirana',
                'bio': 'Rajin menabung dan suka memasak',
                'profileImage': 'assets/images/profile.png',
                'coverImage': 'assets/images/profile_cover.png',
              },
            ),
        '/add-recipe': (context) => const AddRecipePage(),
        '/cookbook-edit': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return CookbookEditPage(
            photo: args['photo'],
            title: args['title'],
            description: args['description'],
          );
        },
        '/reviews': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          return ReviewsPage(
            recipeTitle: args['recipeTitle'] as String,
            rating: args['rating'] as double,
            reviews: List<Map<String, dynamic>>.from(args['reviews']),
          );
        },
        '/grocery-list': (context) {
          final ingredients = ModalRoute.of(context)!.settings.arguments
              as List<Map<String, dynamic>>;
          return GroceryListPage(initialIngredients: ingredients);
        },
        '/edit-recipe': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          if (args == null || !args.containsKey('recipe')) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: const Center(
                child: Text(
                  "No recipe data passed!",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          }

          return EditRecipePage(recipe: args['recipe']);
        },
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/recipe-detail':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null ||
                !args.containsKey('title') ||
                !args.containsKey('image') ||
                !args.containsKey('description') ||
                !args.containsKey('time') ||
                !args.containsKey('difficulty') ||
                !args.containsKey('ingredients') ||
                !args.containsKey('steps')) {
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text(
                      "Invalid recipe data provided!",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                ),
              );
            }
            return MaterialPageRoute(
              builder: (context) => RecipeDetailPage(
                title: args['title'] as String,
                image: args['image'] as String,
                description: args['description'] as String,
                time: args['time'] as String,
                difficulty: args['difficulty'] as String,
                ingredients: List<String>.from(args['ingredients']),
                steps: List<String>.from(args['steps']),
                category: args['category'] as String? ?? 'Everyday',
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text("Page not found"),
                ),
              ),
            );
        }
      },
    );
  }
}
