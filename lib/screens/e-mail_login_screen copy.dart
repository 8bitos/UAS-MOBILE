// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:uas_cookedex/screens/auth_screen.dart';
// import 'forgot_pass_screen.dart'; // Import ForgotPasswordScreen

// class EmailLoginScreen extends StatefulWidget {
//   const EmailLoginScreen({super.key});

//   @override
//   State<EmailLoginScreen> createState() => _EmailLoginScreenState();
// }

// class _EmailLoginScreenState extends State<EmailLoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isForgotPasswordHovered = false;
//   bool _isRegisterHereHovered = false;

//   void _login() {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       // Show error message if fields are empty
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Navigate to the home screen (replace '/home' with your home route)
//     Navigator.pushReplacementNamed(context, '/home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/auth1.jpg', // Ensure the path to the image is correct
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Login Form
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // App Title
//                   Text(
//                     'Cookédex',
//                     style: GoogleFonts.poppins(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Log-in with E-Mail',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                   // E-mail Field
//                   TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       hintText: 'E-mail address',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Password Field
//                   PasswordField(
//                     labelText: 'Password',
//                     controller: _passwordController,
//                   ),
//                   const SizedBox(height: 16),
//                   // Forgot Password Link
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const ForgotPasswordScreen()),
//                         );
//                       },
//                       onTapDown: (_) {
//                         setState(() {
//                           _isForgotPasswordHovered = true;
//                         });
//                       },
//                       onTapCancel: () {
//                         setState(() {
//                           _isForgotPasswordHovered = false;
//                         });
//                       },
//                       child: Text(
//                         'forgot password',
//                         style: TextStyle(
//                           color: _isForgotPasswordHovered
//                               ? Colors.orangeAccent
//                               : Colors.grey,
//                           fontWeight: _isForgotPasswordHovered
//                               ? FontWeight.bold
//                               : FontWeight.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Log In Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Log In',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Register Redirect
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AuthScreen(),
//                         ),
//                       );
//                     },
//                     onTapDown: (_) {
//                       setState(() {
//                         _isRegisterHereHovered = true;
//                       });
//                     },
//                     onTapCancel: () {
//                       setState(() {
//                         _isRegisterHereHovered = false;
//                       });
//                     },
//                     child: Text(
//                       "Haven't made an account? Register here.",
//                       style: TextStyle(
//                         color: _isRegisterHereHovered
//                             ? Colors.orangeAccent
//                             : Colors.grey,
//                         fontWeight: _isRegisterHereHovered
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PasswordField extends StatefulWidget {
//   const PasswordField({super.key, required this.labelText, required this.controller});

//   final String labelText;
//   final TextEditingController controller;

//   @override
//   State<PasswordField> createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<PasswordField> {
//   bool _isObscured = true;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: widget.controller,
//       obscureText: _isObscured,
//       decoration: InputDecoration(
//         labelText: widget.labelText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _isObscured ? Icons.visibility_off : Icons.visibility,
//           ),
//           onPressed: () {
//             setState(() {
//               _isObscured = !_isObscured;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
