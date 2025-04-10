import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/complaint.dart';
import 'package:workspace/login.dart';
import 'package:workspace/payment.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Dio _dio;
  List<Map<String, dynamic>> bookingHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    fetchBookingHistory();
  }

  // Function to fetch booking history from the API
  Future<void> fetchBookingHistory() async {
    try {
      final response = await _dio.get('$baseurl/api/bookings/$lid');
      print(response);

      if (response.statusCode == 200) {
        setState(() {
          // Ensure response is a List<dynamic> and convert it properly to List<Map<String, dynamic>>
          if (response.data is List) {
            bookingHistory = List<Map<String, dynamic>>.from(
              response.data.map(
                (item) => Map<String, dynamic>.from(item as Map),
              ),
            );
          } else {
            errorMessage = 'Unexpected response format';
          }

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Function to return color based on status
  Color _getStatusColor(String status) {
    if (status == 'Accepted') {
      return Colors.green; // Accepted should be green
    } else if (status == 'Pending') {
      return Colors.orange;
    } else if (status == 'Rejected') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Booking History', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D4436),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              )
            else if (bookingHistory.isEmpty)
              Center(child: Text('No booking history available'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: bookingHistory.length,
                  itemBuilder: (context, index) {
                    final booking = bookingHistory[index];

                    // Fetch the price directly from the booking data and ensure it's a double
                    double price =
                        (booking['Price'] is int)
                            ? (booking['Price'] as int).toDouble()
                            : booking['Price'] ?? 0.0;

                    // Debugging to check if 'status' is 'Accepted' and price is greater than 0
                    print('Booking Status: ${booking['status']}');
                    print('Booking Price: $price');

                    return Card(
                      margin: EdgeInsets.only(bottom: 15),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Workspace Name and Place
                            Text(
                              '${booking['workspace']['spaceName']} - ${booking['workspace']['place']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Date and Status
                            Row(
                              children: [
                                Text(
                                  'Date: ${booking['bookingdate']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Status: ${booking['status']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            // Display Slots (Without slotid and slotstatus)
                            for (var slot in booking['slots']) ...[
                              // Slot details (without slotid and slotstatus)
                              Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color:
                                      booking['status'] == 'Accepted'
                                          ? Colors
                                              .green // If booking status is Accepted, color is green
                                          : _getStatusColor(
                                            slot['slotstatus'],
                                          ), // Else use the slot status color
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Slot location
                                    Text(
                                      'Location: ${slot['slotlocation']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    // Slot time
                                    Row(
                                      children: [
                                        Text(
                                          'Start: ${slot['start']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          'End: ${slot['end']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Only show "Pay Now" button if the booking status is "Accepted" and price > 0
                            if (booking['status'] == 'Accepted' && price > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => PaymentScreen(
                                                  workspaceName:
                                                      booking['workspace']['spaceName'],
                                                  place:
                                                      booking['workspace']['place'],
                                                  bookingDate:
                                                      booking['bookingdate'],
                                                  price: price,
                                                  bookingId:
                                                      booking['id']
                                                          .toString(), // Price of the booking
                                                ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.blue, // Button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text('Pay Now'),
                                    ),
                                  ],
                                ),
                              )
                            else if (booking['status'] == 'Paid' &&
                                price == 0.0)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Payment Completed',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (booking['status'] == 'Paid' && price > 0.0)
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Handle complaint logic here
                                        // Navigate to a complaint form or screen
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: Text("Complaint"),
                                                content: Text(
                                                  "Are you sure you want to file a complaint for this booking?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => ComplaintScreen(
                                                                bookingId:
                                                                    booking['workspace']['Work_id']
                                                                        .toString(),
                                                              ),
                                                        ),
                                                      );
                                                      // Implement your complaint submission logic here
                                                    },
                                                    child: Text("Ok"),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors
                                                .red, // Complaint button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text('File Complaint'),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
