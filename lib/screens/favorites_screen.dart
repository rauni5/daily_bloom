import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quote.dart';
import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/quote_card.dart';
import 'quote_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final List<Quote> favorites = app.quotes
        .where((quote) => app.isFavorite(quote.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),

      body: favorites.isEmpty
          ? const Center(child: Text("No favorite quotes yet."))
          : LayoutBuilder(
              builder: (context, constraints) {
                final columns = responsiveColumns(constraints.maxWidth);

                return ResponsiveCenter(
                  maxWidth: 1000,
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    itemCount: favorites.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 200,
                    ),
                    itemBuilder: (_, index) {
                      final quote = favorites[index];

                      final author = app.authorOf(quote.authorId)!;

                      return QuoteCard(
                        quote: quote,
                        author: author,
                        favorite: true,
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
                    },
                  ),
                );
              },
            ),
    );
  }
}
