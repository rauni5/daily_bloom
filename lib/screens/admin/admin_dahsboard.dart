import 'package:daily_bloom/screens/admin/admin_authors_screen.dart';
import 'package:daily_bloom/screens/admin/admin_categories_screen.dart';
import 'package:daily_bloom/screens/admin/admin_quotes_screen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Manage Categories"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageCategoriesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Manage Authors"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageAuthorsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_quote),
            title: const Text("Manage Quotes"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageQuotesScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
