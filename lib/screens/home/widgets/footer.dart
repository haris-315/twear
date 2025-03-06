import 'package:flutter/material.dart';
import 'package:t_wear/core/theme/cubit/theme_cubit.dart';
import 'package:t_wear/core/theme/theme.dart';
import 'package:t_wear/core/utils/get_theme_state.dart';
import 'package:t_wear/core/utils/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = getThemeMode(context);
    final [width, height] = getScreenSize(context);
    final isSmallScreen = width < 600;

    return Container(
      padding: const EdgeInsets.all(20),
      color: themeMode.backgroundColor,
      width: width,
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Developer Contact',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'I’d love to hear from you! Reach out to me via email or connect to me on social media.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactInfo(themeMode),
          const SizedBox(height: 20),
          const Text(
            'Find Me on Social Media',
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
            '© 2025 T-Wear. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(CTheme themeMode) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email, color: Colors.blueAccent),
          title: Text('Email',style: TextStyle(color: themeMode.primTextColor)),
          subtitle: Text('hkffking@gmail.com',style: TextStyle(color: themeMode.secondaryTextColor)),
          onTap: () {
            _launchEmail('support@twear.com');
          },
        ),
        ListTile(
          leading: const Icon(Icons.phone, color: Colors.blueAccent),
          title: Text('Phone',style: TextStyle(color: themeMode.primTextColor)),
          subtitle: Text('+923150907995',style: TextStyle(color: themeMode.secondaryTextColor)),
          onTap: () {
            _launchPhone('+923150907995');
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_on, color: Colors.blueAccent),
          title: Text('Address',style: TextStyle(color: themeMode.primTextColor),),
          subtitle: Text('Abdul Khel, Dera Ismail Khan, Pakistan',style: TextStyle(color: themeMode.secondaryTextColor)),
          onTap: () {
            _launchMaps();
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
          icon: 'assets/icons/facebook.png',
          url: 'https://web.facebook.com/self.taught.programmer.2024',
        ),
        _buildSocialMediaIcon(
          icon: 'assets/icons/instagram.png',
          url: 'https://www.instagram.com/',
        ),
       
        _buildSocialMediaIcon(
          icon: isDarkMode ? 'assets/icons/github_light.png' : 'assets/icons/github.png',
          url: 'https://github.com/haris-315',
        ),
        _buildSocialMediaIcon(
          icon: 'assets/icons/linkedin.png',
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

  Future<void> _launchMaps() async {
    final Uri mapsUri = Uri(
      scheme: 'https',
      host: 'maps.app.goo.gl',
      path: '/kdRSzGffnmdDv44i6',
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      throw 'Could not launch $mapsUri';
    }
  }
}