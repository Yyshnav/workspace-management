// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:workspace/bookingscreen.dart';
// import 'package:workspace/login.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final Dio dio = Dio();
//   List<dynamic> spaces = []; // List to store space data

//   @override
//   void initState() {
//     super.initState();
//     _fetchSpaces(); // Fetch spaces when the screen loads
//   }

//   // Function to fetch spaces from API
//   Future<void> _fetchSpaces() async {
//     try {
//       // Replace with your actual API endpoint
//       String apiUrl = '$baseurl/api/workspace';

//       Response response = await dio.get(apiUrl);
//       print(response);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         setState(() {
//           spaces = response.data; // Assuming API returns a list of spaces
//         });
//       } else {
//         // Show error message if status code is not 200
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Failed to load spaces')));
//       }
//     } catch (e) {
//       // Handle error like network issues
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred. Please try again later')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF0F2EE),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF2D4436),
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(30),
//                   ),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'WorkSpacePro',
//                           style: TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(Icons.notifications_none, color: Colors.white),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.search, color: Colors.black54),
//                                       SizedBox(width: 10),
//                                       Expanded(
//                                         child: TextField(
//                                           decoration: InputDecoration(
//                                             hintText: 'Search spaces...',
//                                             border: InputBorder.none,
//                                             isDense: true,
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                   vertical: 10,
//                                                 ),
//                                           ),
//                                           style: TextStyle(color: Colors.black),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Icon(Icons.tune, color: Colors.black54),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child:
//                     spaces.isEmpty
//                         ? Center(
//                           child: CircularProgressIndicator(),
//                         ) // Show loading indicator while fetching data
//                         : Column(
//                           children: List.generate(spaces.length, (index) {
//                             final space = spaces[index];

//                             return GestureDetector(
//                               onTap: () {
//                                 // Navigate to the Booking Screen when the card is tapped
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (_) => BookingScreen(details: space),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 margin: EdgeInsets.only(bottom: 20),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(16),
//                                       ),
//                                       child: Image.network(
//                                         baseurl +
//                                             space['workspaceImage'], // Assuming the API returns an image URL
//                                         width: double.infinity,
//                                         height: 180,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     space['spaceName'], // Space name
//                                                     style: TextStyle(
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     '${space['Facilities']}',
//                                                     style: TextStyle(
//                                                       color: Colors.grey[700],
//                                                     ),
//                                                     softWrap: true,
//                                                     overflow:
//                                                         TextOverflow.visible,
//                                                   ),

//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     'Type :${space['WorkspaceType']}', // Space location
//                                                     style: TextStyle(
//                                                       color: Colors.grey[700],
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     'Available seat :${space['availableSeat']}', // Space location
//                                                     style: TextStyle(
//                                                       color: Colors.grey[700],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),

//                                               Text(
//                                                 '\$${space['Price']}/hr', // Space price
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: 10),
//                                           Row(
//                                             children: List.generate(
//                                               5,
//                                               (index) => Icon(
//                                                 Icons.star,
//                                                 color: Colors.amber,
//                                                 size: 18,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 10),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.access_time,
//                                                     color: Colors.grey,
//                                                     size: 16,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Text(
//                                                     '${space['start_time']} - ${space['end_time']}',
//                                                   ), // Space location
//                                                 ],
//                                               ),
//                                               ElevatedButton(
//                                                 onPressed: () {},
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: Color(
//                                                     0xFF2D4436,
//                                                   ),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           8,
//                                                         ),
//                                                   ),
//                                                 ),
//                                                 child: Text(
//                                                   'Reserve',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/bookingscreen.dart';
import 'package:workspace/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Dio dio = Dio();
  List<dynamic> allSpaces = []; // Original data
  List<dynamic> spaces = []; // Filtered list
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSpaces();
  }

  Future<void> _fetchSpaces() async {
    try {
      String apiUrl = '$baseurl/api/workspace';

      Response response = await dio.get(apiUrl);
      print(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          allSpaces = response.data;
          spaces = allSpaces;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load spaces')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later')),
      );
    }
  }

  void _filterByWorkspaceType(String type) {
    setState(() {
      spaces =
          allSpaces
              .where(
                (space) => space['WorkspaceType']
                    .toString()
                    .toLowerCase()
                    .contains(type.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2EE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF2D4436),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'WorkSpacePro',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(Icons.notifications_none, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.search, color: Colors.black54),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            _filterByWorkspaceType(value);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Search spaces...',
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                          ),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.tune, color: Colors.black54),
                                  onPressed: () {
                                    _filterByWorkspaceType('shared-desk');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    spaces.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                          children: List.generate(spaces.length, (index) {
                            final space = spaces[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => BookingScreen(details: space),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        baseurl + space['workspaceImage'],
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    space['spaceName'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Container(
                                                    width: 180,
                                                    child: Text(
                                                      // maxLines: 2,
                                                      '${space['Facilities']}',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Type :${space['WorkspaceType']}',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    'Available seat :${space['availableSeat']}',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '\$${space['Price']}/hr',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    '${space['start_time']} - ${space['end_time']}',
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xFF2D4436,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Reserve',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
