import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = getThemeMode(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(20),
      color: themeMode.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Contact Us',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'We’d love to hear from you! Reach out to us via email or connect with us on social media.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactInfo(),
          const SizedBox(height: 20),
          const Text(
            'Follow Us on Social Media',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          _buildSocialMediaLinks(isSmallScreen,themeMode),
          const SizedBox(height: 20),
          const Text(
            '© 2023 T-Wear. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email, color: Colors.blueAccent),
          title: const Text('Email'),
          subtitle: const Text('support@twear.com'),
          onTap: () {
            _launchEmail('support@twear.com');
          },
        ),
        ListTile(
          leading: const Icon(Icons.phone, color: Colors.blueAccent),
          title: const Text('Phone'),
          subtitle: const Text('+1 (123) 456-7890'),
          onTap: () {
            _launchPhone('+11234567890');
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_on, color: Colors.blueAccent),
          title: const Text('Address'),
          subtitle: const Text('123 Main St, City, Country'),
          onTap: () {
            _launchMaps('123 Main St, City, Country');
          },
        ),
      ],
    );
  }

  Widget _buildSocialMediaLinks(bool isSmallScreen,CTheme themeMode) {
    bool isDarkMode = themeMode.getThemeType() is Dark;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: isSmallScreen ? 16 : 24,
      runSpacing: isSmallScreen ? 16 : 24,
      children: [
        _buildSocialMediaIcon(
          icon: 'icons/facebook.png', // Replace with your Facebook icon
          url: 'https://www.facebook.com/',
        ),
        _buildSocialMediaIcon(
          icon: 'icons/instagram.png', // Replace with your Instagram icon
          url: 'https://www.instagram.com/',
        ),
       
        _buildSocialMediaIcon(
          icon: isDarkMode ? 'icons/github_light.png' : 'icons/github.png', // Replace with your GitHub icon
          url: 'https://github.com/',
        ),
        _buildSocialMediaIcon(
          icon: 'icons/linkedin.png', // Replace with your LinkedIn icon
          url: 'https://www.linkedin.com/',
        ),
      ],
    );
  }

  Widget _buildSocialMediaIcon({required String icon, required String url}) {
    return InkWell(
      onTap: () {
        _launchURL(Uri.parse(url));
      },
      child: Image.asset(
        icon,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }

  // Helper functions to launch URLs, email, phone, and maps
  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  Future<void> _launchMaps(String address) async {
    final Uri mapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'query': address},
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      throw 'Could not launch $mapsUri';
    }
  }
}