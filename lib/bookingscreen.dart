// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // Import Dio for API requests
// import 'package:workspace/bottomnav.dart';
// import 'package:workspace/login.dart';

// class BookingScreen extends StatefulWidget {
//   final dynamic details; // The actual data passed here
//   BookingScreen({Key? key, required this.details}) : super(key: key);

//   @override
//   _BookingScreenState createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   int numberOfPeople = 1;

//   List<Map<String, dynamic>> availableSlots =
//       []; // Using dynamic to handle diverse API response data
//   List<String> selectedSlots = []; // List to store selected slot IDs

//   // Dio instance for API requests
//   final Dio _dio = Dio();

//   // Method to handle the date picker
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked =
//         await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2100),
//         ) ??
//         selectedDate;

//     if (picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   // Method to handle the time picker
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay picked =
//         await showTimePicker(context: context, initialTime: selectedTime) ??
//         selectedTime;

//     if (picked != selectedTime) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   // Fetch available slots from API
//   Future<void> fetchAvailableSlots() async {
//     try {
//       var details = widget.details;
//       String workspaceId =
//           details['id']
//               .toString(); // Assuming workspace ID is passed in the details

//       // Make a GET request to fetch available slots
//       final response = await _dio.get('$baseurl/api/viewslot/$workspaceId');
//       print(
//         "API Response: ${response.data}",
//       ); // Check API response in the console

//       if (response.statusCode == 200) {
//         List<dynamic> slots = response.data; // This should be a list of slots

//         setState(() {
//           // Filter the slots to only include those with 'slotstatus' = 'pending'
//           availableSlots =
//               slots
//                   .where(
//                     (slot) => slot['slotstatus'] == 'pending',
//                   ) // Filter condition
//                   .map((slot) {
//                     return {
//                       'slotid': slot['slotid'],
//                       'start': slot['start'],
//                       'end': slot['end'],
//                       'id': slot['id'], // Ensure id is included
//                       'slotDetail': "${slot['start']} - ${slot['end']}",
//                     };
//                   })
//                   .toList();
//         });

//         print(
//           "Available Slots (Pending): $availableSlots",
//         ); // Print available slots for debugging
//       } else {
//         throw Exception('Failed to load available slots');
//       }
//     } catch (e) {
//       print("Error fetching slots: $e");
//       showDialog(
//         context: context,
//         builder:
//             (context) => AlertDialog(
//               title: Text("Error"),
//               content: Text(
//                 "Failed to load available slots. Please try again.",
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchAvailableSlots(); // Fetch slots when the screen is loaded
//   }

//   // Method to handle slot booking
//   Future<void> bookSlot() async {
//     try {
//       var details = widget.details;

//       String selectedSlotIds = selectedSlots
//           .map((slotid) {
//             var slot = availableSlots.firstWhere(
//               (s) =>
//                   s['slotid'] ==
//                   slotid, // Match the slotid to get the correct slot
//               orElse: () => {'id': null},
//             ); // Return slot with `id` field if found
//             return slot['id']?.toString() ??
//                 ''; // Return the `id` of the slot, ensure it's not null
//           })
//           .join(', '); // Join them into a comma-separated string

//       print(
//         "Selected Slot IDs: $selectedSlotIds",
//       ); // Print the selected slot ids for debugging

//       var data = {
//         "user_id":
//             lid, // Assuming lid is defined globally or passed in some way
//         'workspaceId':
//             details['id'].toString(), // Use the workspace ID here (not slotid)
//         'booking_date': selectedDate.toIso8601String(),
//         'selectedTime': selectedTime.format(context),
//         'slot_ids': selectedSlotIds, // Send the selected slot ids
//         'numberOfPeople': numberOfPeople,
//       };

//       print("Booking request payload: $data");

//       // Make the POST request to book the slot
//       final response = await _dio.post('$baseurl/api/bookslot', data: data);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Booking successful, show confirmation
//         showDialog(
//           context: context,
//           builder:
//               (context) => AlertDialog(
//                 title: Text("Booking Confirmed"),
//                 content: Text(
//                   "You have successfully booked the following slots: $selectedSlotIds.",
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BottomNavigationScreen(),
//                         ),
//                       );
//                     },
//                     child: Text("OK"),
//                   ),
//                 ],
//               ),
//         );
//       } else {
//         throw Exception('Failed to book slot');
//       }
//     } catch (e) {
//       print("Error booking slot: $e");
//       showDialog(
//         context: context,
//         builder:
//             (context) => AlertDialog(
//               title: Text("Error"),
//               content: Text("Failed to book the slot. Please try again."),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text("OK"),
//                 ),
//               ],
//             ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var details = widget.details;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book Appointment', style: TextStyle(color: Colors.white)),
//         backgroundColor: Color(0xFF2D4436),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: ListView(
//           children: [
//             // Location Image
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(baseurl + details['workspaceImage']),
//                   fit: BoxFit.cover,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Location and Price Details
//             Text(
//               details['spaceName'], // Dynamically load space name
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               details['Facilities'], // Dynamically load place
//               style: TextStyle(color: Colors.grey[700], fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               details['Place'], // Dynamically load place
//               style: TextStyle(color: Colors.grey[700], fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '\$${details['Price']}/mo', // Dynamically load price
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             SizedBox(height: 20),

//             // Date Selection
//             Text(
//               'Select Date',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: () => _selectDate(context),
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.calendar_today, color: Colors.black54),
//                     SizedBox(width: 10),
//                     Text(
//                       "${selectedDate.toLocal()}".split(' ')[0],
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Time Slot Selection (Horizontal Scrolling)
//             Text(
//               'Select Time Slot(s)',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             availableSlots.isEmpty
//                 ? Center(
//                   child: CircularProgressIndicator(),
//                 ) // Show loading indicator while fetching slots
//                 : SingleChildScrollView(
//                   child: Container(
//                     height: 60,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: availableSlots.length,
//                       itemBuilder: (context, index) {
//                         var slot = availableSlots[index]; // Slot is a map
//                         String slotDetail = slot['slotDetail'];

//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               if (selectedSlots.contains(slot['slotid'])) {
//                                 selectedSlots.remove(slot['slotid']);
//                               } else {
//                                 selectedSlots.add(slot['slotid']);
//                               }
//                               print(
//                                 "Selected Slots: $selectedSlots",
//                               ); // Print the selected slots
//                             });
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(right: 12),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color:
//                                   selectedSlots.contains(slot['slotid'])
//                                       ? Color(0xFF2D4436)
//                                       : Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color:
//                                     selectedSlots.contains(slot['slotid'])
//                                         ? Colors.white
//                                         : Colors.grey,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 slotDetail, // Display the combined time slot
//                                 style: TextStyle(
//                                   color:
//                                       selectedSlots.contains(slot['slotid'])
//                                           ? Colors.white
//                                           : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//             SizedBox(height: 20),

//             // Number of People Selection
//             // Text(
//             //   'Number of People',
//             //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             // ),
//             // SizedBox(height: 10),
//             // Row(
//             //   children: [
//             //     IconButton(
//             //       icon: Icon(Icons.remove, color: Colors.black54),
//             //       onPressed: () {
//             //         setState(() {
//             //           if (numberOfPeople > 1) {
//             //             numberOfPeople--;
//             //           }
//             //         });
//             //       },
//             //     ),
//             //     Text('$numberOfPeople', style: TextStyle(fontSize: 18)),
//             //     IconButton(
//             //       icon: Icon(Icons.add, color: Colors.black54),
//             //       onPressed: () {
//             //         setState(() {
//             //           numberOfPeople++;
//             //         });
//             //       },
//             //     ),
//             //   ],
//             // ),
//             SizedBox(height: 20),

//             // Book Now Button
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedSlots.isEmpty) {
//                   // Show an alert if no time slot selected
//                   showDialog(
//                     context: context,
//                     builder:
//                         (context) => AlertDialog(
//                           title: Text("Error"),
//                           content: Text(
//                             "Please select at least one time slot.",
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text("OK"),
//                             ),
//                           ],
//                         ),
//                   );
//                 } else {
//                   // Call the function to book the slot
//                   bookSlot();
//                 }
//               },
//               child: Text('Book Now', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF2D4436),
//                 padding: EdgeInsets.symmetric(vertical: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/bottomnav.dart';
import 'package:workspace/login.dart';

class BookingScreen extends StatefulWidget {
  final dynamic details;

  BookingScreen({Key? key, required this.details}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int numberOfPeople = 1;

  List<Map<String, dynamic>> availableSlots = [];
  List<String> selectedSlots = [];

  final Dio _dio = Dio();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked =
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        ) ??
        selectedDate;

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime) ??
        selectedTime;

    if (picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> fetchAvailableSlots() async {
    try {
      var details = widget.details;
      String workspaceId = details['id'].toString();

      final response = await _dio.get('$baseurl/api/viewslot/$workspaceId');
      if (response.statusCode == 200) {
        List<dynamic> slots = response.data;

        setState(() {
          availableSlots =
              slots.map((slot) {
                return {
                  'slotid': slot['slotid'],
                  'start': slot['start'],
                  'end': slot['end'],
                  'id': slot['id'],
                  'slotstatus': slot['slotstatus'],
                  'slotDetail': "${slot['start']} - ${slot['end']}",
                };
              }).toList();
        });
      } else {
        throw Exception('Failed to load available slots');
      }
    } catch (e) {
      print("Error fetching slots: $e");
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Error"),
              content: Text(
                "Failed to load available slots. Please try again.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
  }

  Future<void> bookSlot() async {
    try {
      var details = widget.details;

      String selectedSlotIds = selectedSlots
          .map((slotid) {
            var slot = availableSlots.firstWhere(
              (s) => s['slotid'] == slotid,
              orElse: () => {'id': null},
            );
            return slot['id']?.toString() ?? '';
          })
          .join(', ');

      var data = {
        "user_id": lid,
        'workspaceId': details['id'].toString(),
        'booking_date': selectedDate.toIso8601String(),
        'selectedTime': selectedTime.format(context),
        'slot_ids': selectedSlotIds,
        'numberOfPeople': numberOfPeople,
      };

      final response = await _dio.post('$baseurl/api/bookslot', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Booking Confirmed"),
                content: Text(
                  "You have successfully booked the following slots.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationScreen(),
                        ),
                      );
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        throw Exception('Failed to book slot');
      }
    } catch (e) {
      print("Error booking slot: $e");
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Error"),
              content: Text("Failed to book the slot. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var details = widget.details;

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2D4436),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(baseurl + details['workspaceImage']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              details['spaceName'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              details['Facilities'],
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              details['Place'],
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '\$${details['Price']}/mo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Time Slot(s)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            availableSlots.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: availableSlots.length,
                    itemBuilder: (context, index) {
                      var slot = availableSlots[index];
                      String slotDetail = slot['slotDetail'];
                      bool isBooked = slot['slotstatus'] != 'pending';
                      bool isSelected = selectedSlots.contains(slot['slotid']);

                      return GestureDetector(
                        onTap:
                            isBooked
                                ? null
                                : () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedSlots.remove(slot['slotid']);
                                    } else {
                                      selectedSlots.add(slot['slotid']);
                                    }
                                  });
                                },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isBooked
                                    ? Colors.grey.shade300
                                    : isSelected
                                    ? Color(0xFF2D4436)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isBooked
                                      ? Colors.grey
                                      : isSelected
                                      ? Colors.white
                                      : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              slotDetail,
                              style: TextStyle(
                                color:
                                    isBooked
                                        ? Colors.black38
                                        : isSelected
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedSlots.isEmpty) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(
                            "Please select at least one time slot.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                  );
                } else {
                  bookSlot();
                }
              },
              child: Text('Book Now', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2D4436),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
