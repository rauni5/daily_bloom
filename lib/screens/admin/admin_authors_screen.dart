import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/author.dart';
import '../../state/app_state.dart';
import '../../utils/responsive.dart';

class ManageAuthorsScreen extends StatelessWidget {
  const ManageAuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Authors")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAuthorDialog(context),
        child: const Icon(Icons.add),
      ),

      body: ResponsiveCenter(
        maxWidth: 800,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: app.authors.length,
          itemBuilder: (_, index) {
            final author = app.authors[index];

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    author.name.isNotEmpty ? author.name[0].toUpperCase() : "?",
                  ),
                ),
                title: Text(author.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (author.bio.isNotEmpty) Text(author.bio),
                    if (author.tag.isNotEmpty)
                      Text(
                        "#${author.tag}",
                        style: const TextStyle(color: Colors.blue),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showAuthorDialog(context, author: author);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final delete = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Author?"),
                            content: Text("Delete '${author.name}'?"),
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
                          final success = app.deleteAuthor(author.id);

                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Cannot delete this author because one or more quotes are using it.",
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAuthorDialog(BuildContext context, {Author? author}) {
    final app = context.read<AppState>();

    final name = TextEditingController(text: author?.name);
    final bio = TextEditingController(text: author?.bio);
    final tag = TextEditingController(text: author?.tag);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final screenWidth = MediaQuery.of(dialogContext).size.width;
        final dialogWidth = screenWidth < 480 ? screenWidth * 0.9 : 420.0;

        return AlertDialog(
          title: Text(author == null ? "Add Author" : "Edit Author"),
          content: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: "Author Name"),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: bio,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Biography"),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: tag,
                    decoration: const InputDecoration(
                      labelText: "Tag",
                      hintText: "Stoicism",
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;

                final newAuthor = Author(
                  id:
                      author?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name.text.trim(),
                  bio: bio.text.trim(),
                  tag: tag.text.trim(),
                );

                if (author == null) {
                  app.addAuthor(newAuthor);
                } else {
                  app.updateAuthor(newAuthor);
                }

                Navigator.pop(context);
              },
              child: Text(author == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }
}
