import 'package:flutter/material.dart';

import '../models/author.dart';
import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Author author;

  final bool favorite;

  final VoidCallback onFavorite;

  final VoidCallback onTap;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
    required this.favorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "quote_${quote.id}",
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 18),

                Text(author.name, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Spacer(),

                    IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
