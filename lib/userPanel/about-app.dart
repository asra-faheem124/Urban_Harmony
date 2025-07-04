import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
           Image.asset('assets/images/logo2.png', height: 50,),
            const SizedBox(height: 16),
            const Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'LaptopHarbor is your go-to app for browsing, comparing, and purchasing the latest laptops and accessories. We aim to simplify the laptop shopping experience through detailed product information, smart filters, real-time order tracking, and a smooth checkout process.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Developed By'),
              subtitle: const Text('LaptopHarbor Team'),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Website'),
              subtitle: const Text('www.laptopharbor.com'),
              onTap: () => _launchURL('https://www.laptopharbor.com'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Support Email'),
              subtitle: const Text('support@laptopharbor.com'),
              onTap: () => _launchURL('mailto:support@laptopharbor.com'),
            ),
          ],
        ),
      ),
    );
  }
}
