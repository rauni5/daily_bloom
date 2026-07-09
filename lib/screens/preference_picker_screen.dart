import 'package:daily_bloom/screens/root.dart';
import 'package:daily_bloom/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/primary_button.dart';

class PreferencePickerScreen extends StatelessWidget {
  const PreferencePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Interests"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Select at least 3 categories.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: app.categories.map((category) {
                  return CategoryCard(
                    title: category.name,
                    selected: app.currentUser.preferredCategoryIds.contains(
                      category.id,
                    ),
                    onTap: () {
                      app.togglePreference(category.id);
                    },
                  );
                }).toList(),
              ),
            ),

            PrimaryButton(
              title: "Continue",
              onPressed: () {
                if (app.currentUser.preferredCategoryIds.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select at least 3 categories."),
                    ),
                  );

                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RootShell()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
