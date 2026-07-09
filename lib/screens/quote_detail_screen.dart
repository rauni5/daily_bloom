import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'author_detail_screen.dart';
import '../models/quote.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;

  const QuoteDetailScreen({super.key, required this.quote});

  Future<void> openAuthorPage(String authorName) async {
    final Uri url = Uri.parse(
      "https://en.wikipedia.org/wiki/${authorName.replaceAll(' ', '_')}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final author = app.authorOf(quote.authorId)!;

    final categories = app.categories
        .where((category) => quote.categoryIds.contains(category.id))
        .toList();

    return Scaffold(
      appBar: AppBar(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          app.toggleFavorite(quote.id);
        },
        child: Icon(
          app.isFavorite(quote.id) ? Icons.favorite : Icons.favorite_border,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: ResponsiveCenter(
          maxWidth: 700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Hero(
                tag: "quote_${quote.id}",

                child: Material(
                  color: Colors.transparent,

                  child: Card(
                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(24),

                      child: Text(
                        quote.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Author",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(author.name),
                subtitle: Text(author.bio),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthorDetailScreen(author: author),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                children: categories.map((category) {
                  return Chip(label: Text(category.name));
                }).toList(),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  openAuthorPage(author.name);
                },
                icon: const Icon(Icons.public),
                label: const Text("Learn More"),
              ),

              const SizedBox(height: 15),

              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Audio coming soon")),
                  );
                },
                icon: const Icon(Icons.volume_up),
                label: const Text("Play Audio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
