import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@laptopharbor.com',
      query: Uri.encodeFull('subject=Support Request - LaptopHarbor'),
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: '+1234567890');
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Icon(Icons.support_agent, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Need Help?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We are here to help you 24/7 with your orders, account, or any other queries.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Support'),
              subtitle: const Text('support@laptopharbor.com'),
              onTap: _launchEmail,
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Us'),
              subtitle: const Text('+1 234 567 890'),
              onTap: _launchPhone,
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQs'),
              subtitle: const Text('Visit our frequently asked questions section'),
              onTap: () {
                // Navigate to FAQ page or show a dialog (to be implemented)
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Our support team typically responds within 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
