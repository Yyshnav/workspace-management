// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:workspace/bottomnav.dart';
// import 'package:workspace/register.dart';

// final baseurl = "http://192.168.1.58:5000";
// int? lid;

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // Create text editing controllers for email and password
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Dio instance for making API calls
//   final Dio dio = Dio();

//   // Login function to call the API
//   Future<void> _loginUser() async {
//     String email = emailController.text;
//     String password = passwordController.text;

//     if (email.isEmpty || password.isEmpty) {
//       // Show error if fields are empty
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter email and password')),
//       );
//       return;
//     }

//     try {
//       // Replace this URL with your API endpoint
//       String apiUrl = '$baseurl/api/login';

//       Response response = await dio.post(
//         apiUrl,
//         data: {'username': email, 'password': password},
//       );
//       print(response);

//       // Check if the login was successful
//       if (response.statusCode == 200) {
//         lid = response.data['login_id'];
//         // Login successful, navigate to the home screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => BottomNavigationScreen()),
//         );
//       } else {
//         // Show error if login failed
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
//       }
//     } catch (e) {
//       // Handle error, such as network issues
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred. Please try again later')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/pp.jpg', fit: BoxFit.cover),
//           Container(color: Colors.black.withOpacity(0.4)),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 30),
//                 Text(
//                   'Find place to work',
//                   style: TextStyle(
//                     fontSize: 32,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'No matter where you are',
//                   style: TextStyle(fontSize: 16, color: Colors.white70),
//                 ),
//                 SizedBox(height: 100),

//                 // Email TextField
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(color: Colors.white70),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 15),

//                 // Password TextField
//                 TextFormField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     labelStyle: TextStyle(color: Colors.white70),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.7),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 Spacer(), // This ensures the buttons stay at the bottom
//                 // Login Button
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Color(0xFF2D4436),
//                     backgroundColor: Colors.white,
//                     minimumSize: Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: _loginUser, // Call the login function
//                   child: Text('Login'),
//                 ),
//                 // Register Button (Navigates to RegisterScreen)
//                 Center(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => RegisterScreen()),
//                       );
//                     },
//                     child: Text(
//                       'Don\'t have an account? Register',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/bottomnav.dart';
import 'package:workspace/register.dart';

final baseurl = "http://192.168.1.58:5000";
int? lid;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Dio dio = Dio();

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate())
      return; // Don't proceed if form is invalid

    String email = emailController.text;
    String password = passwordController.text;

    try {
      String apiUrl = '$baseurl/api/login';

      Response response = await dio.post(
        apiUrl,
        data: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        lid = response.data['login_id'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigationScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/pp.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find place to work',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No matter where you are',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 100),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: _inputDecoration('Email'),
                    // keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                        return 'Enter a valid email';
                      return null;
                    },
                  ),
                  SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    decoration: _inputDecoration('Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your password';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color(0xFF2D4436),
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _loginUser,
                    child: Text('Login'),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Register',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF2D4436)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
