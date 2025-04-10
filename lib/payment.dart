import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:workspace/bottomnav.dart';
import 'package:workspace/login.dart';

class PaymentScreen extends StatefulWidget {
  final String workspaceName;
  final String place;
  final String bookingDate;
  final double price;
  final String bookingId; // Example booking ID

  PaymentScreen({
    required this.workspaceName,
    required this.place,
    required this.bookingDate,
    required this.price,
    required this.bookingId,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  bool isProcessingPayment = false;
  Dio _dio = Dio(); // Dio instance for making API calls

  // Payment method selection
  String _selectedPaymentMethod = 'Credit Card';
  final TextEditingController _cardNumberController = TextEditingController();

  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  // Error messages for validation
  String? _cardNumberError;
  String? _expiryDateError;
  String? _cvvError;
  String? _upiIdError;

  // Payment API URL (replace with your actual URL)
  final String paymentApiUrl = "$baseurl/api/payment";

  // Animation Controllers
  late AnimationController _iconController;
  late AnimationController _textController;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _iconController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Icon will scale and fade in and out repeatedly

    _textController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward(); // Text will fade in once
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment for ${widget.workspaceName}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF2D4436),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Details Section
              _buildCard(
                "Workspace Details",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.business, widget.workspaceName),
                    _buildDetailRow(Icons.location_on, widget.place),
                    _buildDetailRow(Icons.calendar_today, widget.bookingDate),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Price Details Section
              _buildCard(
                "Price Details",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      Icons.monetization_on,
                      "₹${widget.price.toStringAsFixed(2)}",
                      isPrice: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Payment Method Selection
              Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildPaymentMethodSelection(),
              SizedBox(height: 20),

              // Payment Input Fields based on selected method
              _selectedPaymentMethod == 'Credit Card'
                  ? _buildCreditCardForm()
                  : _selectedPaymentMethod == 'UPI'
                  ? _buildUpiForm()
                  : SizedBox(),

              // Payment Button
              if (!isProcessingPayment)
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_validatePaymentDetails()) {
                        setState(() {
                          isProcessingPayment = true;
                        });
                        // Call API to process payment
                        bool paymentSuccess = await _processPayment();

                        setState(() {
                          isProcessingPayment = false;
                        });

                        if (paymentSuccess) {
                          _showPaymentSuccessDialog(context);
                        }
                      } else {
                        _showErrorDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text("Proceed to Pay"),
                  ),
                ),
              if (isProcessingPayment)
                Center(child: CircularProgressIndicator()),

              SizedBox(height: 30),

              // Back to Booking History
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    ); // Go back to the previous screen (Booking History)
                  },
                  child: Text(
                    "Back to Booking History",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the card
  Widget _buildCard(String title, Widget content) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  // Method to build each detail row
  Widget _buildDetailRow(IconData icon, String text, {bool isPrice = false}) {
    return Row(
      children: [
        Icon(icon, color: isPrice ? Colors.green : Colors.grey[600], size: 24),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isPrice ? Colors.green : Colors.black87,
          ),
        ),
      ],
    );
  }

  // Method to build payment method selection UI
  Widget _buildPaymentMethodSelection() {
    return Column(
      children: [
        ListTile(
          title: Text('Credit Card'),
          leading: Radio<String>(
            value: 'Credit Card',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('UPI'),
          leading: Radio<String>(
            value: 'UPI',
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  // Method to build Credit Card form fields with card-like text fields
  Widget _buildCreditCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardLikeTextField(
          'Holder name',
          _cardNameController,
          TextInputType.text,
        ),
        _buildCardLikeTextField(
          'Card Number',
          _cardNumberController,
          TextInputType.number,
          errorText: _cardNumberError,
        ),
        _buildCardLikeTextField(
          'Expiry Date (MM/YY)',
          _expiryDateController,
          TextInputType.datetime,
          errorText: _expiryDateError,
        ),
        _buildCardLikeTextField(
          'CVV',
          _cvvController,
          TextInputType.number,
          errorText: _cvvError,
        ),
      ],
    );
  }

  // Method to build UPI form field with card-like text field
  Widget _buildUpiForm() {
    return _buildCardLikeTextField(
      'UPI ID',
      _upiIdController,
      TextInputType.text,
      errorText: _upiIdError,
    );
  }

  // Method to build card-like TextField
  Widget _buildCardLikeTextField(
    String label,
    TextEditingController controller,
    TextInputType inputType, {
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 4.0,
                ),
                child: Text(
                  errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Method to validate payment details
  bool _validatePaymentDetails() {
    bool isValid = true;
    setState(() {
      _cardNumberError = null;
      _expiryDateError = null;
      _cvvError = null;
      _upiIdError = null;

      if (_selectedPaymentMethod == 'Credit Card') {
        // Card Number should be 16 digits
        if (_cardNumberController.text.isEmpty ||
            _cardNumberController.text.length != 16) {
          _cardNumberError = "Card number must be 16 digits.";
          isValid = false;
        }
        // Expiry date should follow MM/YY format
        if (_expiryDateController.text.isEmpty ||
            !_expiryDateController.text.contains("/")) {
          _expiryDateError = "Invalid expiry date format.";
          isValid = false;
        }
        // CVV should be 3 digits
        if (_cvvController.text.isEmpty || _cvvController.text.length != 3) {
          _cvvError = "CVV must be 3 digits.";
          isValid = false;
        }
      } else if (_selectedPaymentMethod == 'UPI') {
        // UPI ID should contain '@'
        if (_upiIdController.text.isEmpty ||
            !_upiIdController.text.contains("@")) {
          _upiIdError = "Invalid UPI ID.";
          isValid = false;
        }
      }
    });

    return isValid;
  }

  // Method to process the payment
  Future<bool> _processPayment() async {
    try {
      final response = await _dio.post(
        paymentApiUrl,
        data: {
          'bookingId': widget.bookingId,
          'user_id': lid,
          'amount': widget.price,
          'payment_method': _selectedPaymentMethod,
          'paymentDetails':
              _selectedPaymentMethod == 'Credit Card'
                  ? {
                    'card_number': _cardNumberController.text,
                    'card_expiry': _expiryDateController.text,
                    'card_holdername': _cvvController.text,
                  }
                  : {'upi_id': _upiIdController.text},
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Method to show payment success dialog
  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Success"),
          content: Text("Your payment has been successfully processed!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(),
                  ),
                  (Route<dynamic> route) =>
                      false, // This removes all previous routes
                );
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to show error dialog
  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Failed"),
          content: Text("Please fill in all the fields correctly."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
