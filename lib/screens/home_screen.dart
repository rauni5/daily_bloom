import 'package:daily_bloom/models/quote.dart';
import 'package:daily_bloom/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../utils/responsive.dart';
import '../widgets/quote_card.dart';
import 'quote_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    List<Quote> quotes = app.buildFeed();

    if (selectedCategory.isNotEmpty) {
      quotes = quotes.where((quote) {
        return quote.categoryIds.contains(selectedCategory);
      }).toList();
    }

    if (searchController.text.isNotEmpty) {
      quotes = quotes.where((quote) {
        return quote.text.toLowerCase().contains(
          searchController.text.toLowerCase(),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Bloom")),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = responsiveColumns(constraints.maxWidth);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ResponsiveCenter(
                maxWidth: 1000,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Good Morning 👋",
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Today's Inspiration",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search quotes...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: app.categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CategoryCard(
                              title: category.name,
                              selected: selectedCategory == category.id,
                              onTap: () {
                                setState(() {
                                  if (selectedCategory == category.id) {
                                    selectedCategory = "";
                                  } else {
                                    selectedCategory = category.id;
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quotes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 200,
                      ),
                      itemBuilder: (context, index) {
                        final quote = quotes[index];
                        final author = app.authorOf(quote.authorId)!;

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
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
