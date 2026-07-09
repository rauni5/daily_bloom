import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../state/app_state.dart';

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Categories")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context),
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: app.categories.length,

        itemBuilder: (_, index) {
          final category = app.categories[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(category.icon)),

              title: Text(category.name),

              subtitle: Text(
                category.description.isEmpty
                    ? "No description"
                    : category.description,
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showCategoryDialog(context, category: category);
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final delete = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Category?"),
                          content: Text("Delete '${category.name}'?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),

                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (delete == true) {
                        app.deleteCategory(category.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, {Category? category}) {
    final app = context.read<AppState>();

    final name = TextEditingController(text: category?.name);

    final icon = TextEditingController(text: category?.icon);

    final description = TextEditingController(text: category?.description);

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(category == null ? "Add Category" : "Edit Category"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: "Name"),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: icon,
                  decoration: const InputDecoration(labelText: "Emoji/Icon"),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: description,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty) {
                  return;
                }

                final newCategory = Category(
                  id:
                      category?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),

                  name: name.text.trim(),

                  icon: icon.text.trim().isEmpty ? "✺" : icon.text.trim(),

                  description: description.text.trim(),

                  isActive: true,
                );

                if (category == null) {
                  app.addCategory(newCategory);
                } else {
                  app.updateCategory(newCategory);
                }

                Navigator.pop(context);
              },

              child: Text(category == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }
}
