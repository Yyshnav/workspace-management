import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Dio dio = Dio();

  // Profile data variables
  String fullName = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';
  String address = 'Loading...';

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      final response = await dio.get('$baseurl/api/profile/$lid');
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        setState(() {
          fullName = data['FullName'] ?? 'N/A';
          email = data['Email'] ?? 'N/A';
          phone = data['PhoneNumber'] ?? 'N/A';
          address = data['Address'] ?? 'N/A';
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load profile')));
      }
    } catch (e) {
      print('Profile fetch error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while loading profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D4436),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => EditProfileScreen(
                        fullName: fullName,
                        email: email,
                        phone: phone,
                        address: address,
                      ),
                ),
              );
              if (updated == true) {
                getProfile(); // Refresh after editing
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildProfileInfoCard('Full Name', fullName),
            SizedBox(height: 15),
            _buildProfileInfoCard('Email', email),
            SizedBox(height: 15),
            _buildProfileInfoCard('Phone', phone),
            SizedBox(height: 15),
            _buildProfileInfoCard('Address', address),
            SizedBox(height: 30),
            _buildActionButton('Log Out', Icons.exit_to_app),
          ],
        ),
      ),
    );
  }

  // Info Card Widget
  Widget _buildProfileInfoCard(String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info, color: Colors.green, size: 28),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    content,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logout Button
  Widget _buildActionButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String phone;
  final String address;

  EditProfileScreen({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Dio dio = Dio();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await dio.post(
          '$baseurl/api/profileupdate/$lid',
          data: {
            "FullName": nameController.text,
            "Email": emailController.text,
            "PhoneNumber": phoneController.text,
            "Address": addressController.text,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully")),
          );
          Navigator.pop(context, true); // Notify previous screen
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed to update profile")));
        }
      } catch (e) {
        print("Update error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating profile")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D4436),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Full Name", nameController),
              SizedBox(height: 15),
              _buildTextField(
                "Email",
                emailController,
                type: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),
              _buildTextField(
                "Phone",
                phoneController,
                type: TextInputType.phone,
              ),
              SizedBox(height: 15),
              _buildTextField("Address", addressController, maxLines: 2),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateProfile,
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D4436),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      validator:
          (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
