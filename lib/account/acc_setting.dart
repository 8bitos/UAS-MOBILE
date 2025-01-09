import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_cookedex/screens/e-mail_login_screen.dart';
import 'package:uas_cookedex/services/auth_service.dart';

class AccSettingPage extends StatefulWidget {
  const AccSettingPage({super.key});

  @override
  _AccSettingPageState createState() => _AccSettingPageState();
}

class _AccSettingPageState extends State<AccSettingPage> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Loading...';
      _userEmail = prefs.getString('user_email') ?? 'Loading...';
    });
  }

  // Function to logout the user
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Remove token on logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile Picture
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/images/profile.png'), // Replace with your profile image
                  ),
                  const SizedBox(width: 16),
                  // Profile Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName ?? "User Name",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail ?? "user@example.com",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "General",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add the "Account Profile" ListTile here
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.black),
                    title: const Text("Account Profile"),
                    onTap: () {
                      Navigator.pushNamed(context, '/acc-credentials');
                    },
                  ),

                  const SizedBox(height: 16),

                  // Keep the existing ListTiles
                  _buildListTile("About", Icons.info_outline, context),
                  _buildListTile("Help & Support", Icons.help_outline, context),
                  _buildListTile(
                      "Send Feedback", Icons.feedback_outlined, context),
                  _buildListTile("Rate Us", Icons.star_border, context),
                  _buildListTile(
                      "Check for Update", Icons.update_outlined, context),
                  // Logout Button
                  _buildListTile("Logout", Icons.logout, context,
                      onTap: _logout),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each ListTile
  Widget _buildListTile(String title, IconData icon, BuildContext context,
      {void Function()? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap ??
          () {
            // Add navigation logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title tapped')),
            );
          },
    );
  }
}
