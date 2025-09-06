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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
       
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            
            Image.asset(
              'assets/images/Logo1.png',
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'UrbanHarmony is your trusted app for discovering premium furniture, elegant room designs, and stylish accessories. '
              'Our mission is to bring harmony to your living spaces by offering curated collections, detailed design inspirations, '
              'easy browsing, and a smooth shopping experience.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.code),
              title: Text('Developed By'),
              subtitle: Text('UrbanHarmony Team'),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Website'),
              subtitle: const Text('www.urbanharmony.com'),
              onTap: () => _launchURL('https://www.urbanharmony.com'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Support Email'),
              subtitle: const Text('support@urbanharmony.com'),
              onTap: () => _launchURL('mailto:support@urbanharmony.com'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact'),
              subtitle: const Text('+92 300 1234567'),
              onTap: () => _launchURL('tel:+923001234567'),
            ),
          ],
        ),
      ),
    );
  }
}
