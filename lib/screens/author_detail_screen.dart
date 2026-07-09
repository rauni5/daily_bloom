import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/author.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/quote_card.dart';
import 'quote_detail_screen.dart';

class AuthorDetailScreen extends StatelessWidget {
  final Author author;

  const AuthorDetailScreen({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final authorQuotes = app.quotes
        .where((quote) => quote.authorId == author.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(author.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ResponsiveCenter(
            maxWidth: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (author.tag.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Chip(label: Text(author.tag)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(author.bio, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 28),
                Text(
                  "Quotes (${authorQuotes.length})",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...authorQuotes.map((quote) {
                  return QuoteCard(
                    quote: quote,
                    author: author,
                    favorite: app.isFavorite(quote.id),
                    onFavorite: () {
                      app.toggleFavorite(quote.id);
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuoteDetailScreen(quote: quote),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
