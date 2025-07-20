import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendOrderConfirmationEmail({
  required String userName,
  required String userEmail,
  required String orderId,
  required String orderDetails,
}) async {
  const serviceId = 'service_39ju8c8';
  const templateId = 'template_565wium';
  const publicKey = 'WS31K2xO1J64FTJu9';

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
        'user_name': userName,
        'user_email': userEmail,
        'order_id': orderId,
        'order_details': orderDetails, // This will be inserted into your email
      },
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Order confirmation email sent!');
  } else {
    print('❌ Failed to send email: ${response.body}');
  }
}
