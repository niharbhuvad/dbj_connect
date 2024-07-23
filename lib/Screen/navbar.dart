import 'package:dbj_connect/Screen/dbj_map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

_launchURL(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.open_in_browser_rounded),
            title: const Text('College Website'),
            onTap: () {
              _launchURL('https://www.dbjcollege.org.in/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('DBJ College Map'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DbjMapPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
