import 'package:daily_bloom/screens/admin/admin_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/app_state.dart';
import '../utils/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> openGithub() async {
    final url = Uri.parse("https://github.com/");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ResponsiveCenter(
          maxWidth: 600,
          child: Column(
          children: [
            const CircleAvatar(radius: 45, child: Icon(Icons.person, size: 45)),

            const SizedBox(height: 15),

            Text(app.currentUser.name, style: const TextStyle(fontSize: 22)),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.emoji_events),

              title: const Text("XP"),

              trailing: Text(app.currentUser.xp.toString()),
            ),

            ListTile(
              leading: const Icon(Icons.local_fire_department),

              title: const Text("Current Streak"),

              trailing: Text(app.currentUser.gameStreak.toString()),
            ),

            ListTile(
              leading: const Icon(Icons.favorite),

              title: const Text("Favorite Quotes"),

              trailing: Text(
                app.currentUser.favoriteQuoteIds.length.toString(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Admin Panel"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
                );
              },
            ),
            SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
              value: app.isDarkMode,
              onChanged: (_) {
                app.toggleTheme();
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.code),

              title: const Text("GitHub"),

              trailing: const Icon(Icons.open_in_new),

              onTap: openGithub,
            ),
          ],
        ),
        ),
      ),
    );
  }
}
