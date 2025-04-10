import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/bookinghistory.dart';
import 'package:workspace/bottomnav.dart';
import 'package:workspace/login.dart';

class ComplaintScreen extends StatefulWidget {
  final String bookingId;

  ComplaintScreen({required this.bookingId});

  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _complaintController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoadingReply = true;
  String? _complaintReply;
  String? _complaint;

  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _fetchComplaintReply(); // Fetch the complaint reply on screen load
  }

  // Method to fetch the complaint reply
  Future<void> _fetchComplaintReply() async {
    try {
      final response = await _dio.get(
        '$baseurl/api/viewreply/$lid',
      ); // Adjust the URL accordingly
      print(response);

      if (response.statusCode == 200) {
        // Check if the response data is a list and contains elements
        if (response.data is List && response.data.isNotEmpty) {
          setState(() {
            // Access the first item in the list and get the 'reply' and 'complaint' fields
            _complaintReply = response.data[0]['reply'];
            _complaint =
                response.data[0]['Complaint']; // Original complaint text
            _isLoadingReply = false;
          });
        } else {
          setState(() {
            _complaintReply = 'No reply yet.';
            _complaint =
                'No complaint details available.'; // In case there's no complaint
            _isLoadingReply = false;
          });
        }
      } else {
        setState(() {
          _isLoadingReply = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingReply = false;
      });
      print("Error fetching reply: $e");
    }
  }

  // Method to submit the complaint
  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Prepare the complaint data
        final complaintData = {
          "USERID":
              lid, // Assuming 'lid' is a global variable holding the user ID
          'WORKID': widget.bookingId,
          'Complaint': _complaintController.text,
        };

        // API endpoint (replace this with your actual API endpoint)
        final String apiUrl = '$baseurl/api/complaints';

        // Make the API call
        final response = await _dio.post(apiUrl, data: complaintData);

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            _isSubmitting = false;
          });

          // On success, show a success message
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Complaint Submitted'),
                content: Text(
                  'Your complaint for booking ID ${widget.bookingId} has been submitted.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(
                        context,
                      ); // Close the complaint screen and return to the previous screen
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle failure response
          setState(() {
            _isSubmitting = false;
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                  'Failed to submit the complaint. Please try again later.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the error dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });

        // Handle any errors (network errors, etc.)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                'An error occurred while submitting the complaint. Please try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the error dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Complaint for Booking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2D4436),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Complaint description input
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description for the complaint';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Submit button
              Center(
                child:
                    _isSubmitting
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: _submitComplaint,
                          child: Text('Submit Complaint'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
              ),
              SizedBox(height: 20),

              // Display both the original complaint and reply if fetched
              _isLoadingReply
                  ? CircularProgressIndicator() // Show a loading spinner while waiting for the reply
                  : Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display the Original Complaint
                          Text(
                            'Complaint:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            _complaint ?? 'No complaint available.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          // SizedBox(height: 20),
                          // Display the Complaint Reply
                          Text(
                            'Reply:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            _complaintReply ?? 'No reply yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
