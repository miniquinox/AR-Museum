// stripe_payment.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePayment {
  static Map<String, dynamic>? paymentIntent;

  static Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent(
          '10000', 'GBP'); // Set your amount and currency here

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

      // Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntent!['client_secret'], // From payment intent
                  style: ThemeMode.light,
                  merchantDisplayName:
                      'Your Merchant Name', // Set your merchant name here
                  googlePay: gpay))
          .then((value) {});

      // Display Payment sheet
      await displayPaymentSheet(context);
    } catch (err) {
      print(err);
    }
  }

  static displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Payment Successful")));
      });
    } catch (e) {
      print('$e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Payment Failed: $e")));
    }
  }

  static createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer YOUR_SECRET_KEY', // Use your secret key here
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
