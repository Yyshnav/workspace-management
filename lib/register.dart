// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:workspace/homescren.dart';
// import 'package:workspace/login.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   // Form controllers for each input field
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   // Dio instance for API requests
//   final Dio _dio = Dio();

//   // Registration function using Dio
//   Future<void> _registerUser() async {
//     String fullName = _fullNameController.text;
//     String email = _emailController.text;
//     String phone = _phoneController.text;
//     String address = _addressController.text;
//     String password = _passwordController.text;
//     String confirmPassword = _confirmPasswordController.text;

//     if (password != confirmPassword) {
//       _showErrorDialog("Passwords do not match.");
//       return;
//     }

//     try {
//       Response response = await _dio.post(
//         '$baseurl/api/reg',  // Replace with your backend API URL
//         data: {
//           'FullName': fullName,
//           'Email': email,
//           'username': email,  // Assuming UserName is the same as Email
//           'PhoneNumber': phone,
//           'Address': address,
//           'password': password,
//         },
//       );

//       if (response.statusCode == 200||response.statusCode == 201) {
//         // Successfully registered
//         _showSuccessDialog();
//       } else {
//         // Handle error if response status is not 200
//         _showErrorDialog("Registration failed. Please try again.");
//       }
//     } catch (e) {
//       // Handle Dio or other errors
//       _showErrorDialog("An error occurred. Please try again.");
//     }
//   }

//   // Show success dialog after successful registration
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Registration Successful"),
//         content: Text("You have successfully registered. Please log in."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => LoginScreen()),
//               );
//             },
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Show error dialog
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset('assets/pp.jpg', fit: BoxFit.cover),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30.0),
//             child: Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Register to find a place to work',
//                       style: TextStyle(
//                         fontSize: 32,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Create your account to get started',
//                       style: TextStyle(fontSize: 16, color: Colors.white70),
//                     ),
//                     SizedBox(height: 30),

//                     // Full Name Field
//                     TextFormField(
//                       controller: _fullNameController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Full Name',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 15),

//                     // Email Field
//                     TextFormField(
//                       controller: _emailController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                     SizedBox(height: 15),

//                     // Phone Number Field
//                     TextFormField(
//                       controller: _phoneController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Phone Number',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       keyboardType: TextInputType.phone,
//                     ),
//                     SizedBox(height: 15),

//                     // Address Field
//                     TextFormField(
//                       controller: _addressController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Address',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 15),

//                     // Password Field
//                     TextFormField(
//                       controller: _passwordController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Password',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                     SizedBox(height: 15),

//                     // Confirm Password Field
//                     TextFormField(
//                       controller: _confirmPasswordController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Confirm Password',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.7),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       obscureText: true,
//                     ),
//                     SizedBox(height: 30),

//                     // Sign Up Button
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Color(0xFF2D4436),
//                         backgroundColor: Colors.white,
//                         minimumSize: Size(double.infinity, 50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: _registerUser,
//                       child: Text('Sign Up'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => LoginScreen()),
//                         );
//                       },
//                       child: Text(
//                         'Already have an account? Log in',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/homescren.dart';
import 'package:workspace/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Dio _dio = Dio();

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    try {
      Response response = await _dio.post(
        '$baseurl/api/reg',
        data: {
          'FullName': fullName,
          'Email': email,
          'username': email,
          'PhoneNumber': phone,
          'Address': address,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog();
      } else {
        _showErrorDialog("Registration failed. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Registration Successful"),
            content: Text("You have successfully registered. Please log in."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/pp.jpg', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 80),
                    Text(
                      'Register to find a place to work',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Create your account to get started',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    SizedBox(height: 30),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      // style: TextStyle(color: Colors.white),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your full name'
                                  : null,
                      decoration: _inputDecoration('Full Name'),
                    ),
                    SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      // style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                          return 'Enter a valid email';
                        return null;
                      },
                      decoration: _inputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      // style: TextStyle(color: Colors.white),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your phone number'
                                  : null,
                      decoration: _inputDecoration('Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 15),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      // style: TextStyle(color: Colors.white),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? 'Please enter your address'
                                  : null,
                      decoration: _inputDecoration('Address'),
                    ),
                    SizedBox(height: 15),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      // style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty) return 'Please enter a password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                      decoration: _inputDecoration('Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 15),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      // style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please confirm your password';
                        if (value != _passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                      decoration: _inputDecoration('Confirm Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF2D4436),
                        backgroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
