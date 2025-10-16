import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  final double amount;
  final String email;
  final int bookingId;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.email,
    required this.bookingId,
  }) : super(key: key);

  void _handlePayment(BuildContext context, String method) {
    if (method == 'Card') {
      // Navigate to card entry page
      Get.to(() => CardPaymentScreen(amount: amount));
    } else {
      // Simulate Google Pay / Apple Pay
      Get.to(() => PaymentSuccessScreen(amount: amount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Amount to Pay: \$${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            // Google Pay
            GestureDetector(
              onTap: () => _handlePayment(context, 'Google Pay'),
              child: PaymentOptionCard(
                imagePath: 'assets/images/google_pay.png',
                title: 'Pay with Google Pay',
              ),
            ),
            SizedBox(height: 16),

            // Apple Pay
            GestureDetector(
              onTap: () => _handlePayment(context, 'Card'),
              child: PaymentOptionCard(
                imagePath: 'assets/images/apple_pay.png',
                title: 'Pay with Apple Pay / Card',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable card widget
class PaymentOptionCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const PaymentOptionCard(
      {Key? key, required this.imagePath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Image.asset(imagePath, height: 32),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Card Payment Screen =====
class CardPaymentScreen extends StatefulWidget {
  final double amount;

  const CardPaymentScreen({Key? key, required this.amount}) : super(key: key);

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      // Simulate payment success
      Get.to(() => PaymentSuccessScreen(amount: widget.amount));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Card Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cardholder Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter cardholder name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cardController,
                decoration: InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter card number';
                  if (value.length < 16) return 'Card number must be 16 digits';
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration:
                          InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter expiry date' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) return 'Enter CVV';
                        if (value.length != 3) return 'CVV must be 3 digits';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Pay \$${widget.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Payment Success Screen =====
class PaymentSuccessScreen extends StatelessWidget {
  final double amount;

  const PaymentSuccessScreen({Key? key, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Amount Paid: \$${amount.toStringAsFixed(2)}'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Go back to booking page
              },
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
