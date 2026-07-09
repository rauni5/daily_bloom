import 'package:flutter/material.dart';

import '../data/seed_data.dart';

import '../models/user.dart';
import '../models/author.dart';
import '../models/category.dart';
import '../models/quote.dart';

class AppState extends ChangeNotifier {
  List<Category> categories = List.from(seedCategories);

  List<Author> authors = List.from(seedAuthors);

  List<Quote> quotes = List.from(seedQuotes);

  AppUser currentUser = AppUser(name: "Guest");
  void addCategory(Category category) {
    categories.add(category);

    notifyListeners();
  }

  void updateCategory(Category updated) {
    final index = categories.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      categories[index] = updated;

      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    categories.removeWhere((e) => e.id == id);

    for (final quote in quotes) {
      quote.categoryIds.remove(id);
    }

    notifyListeners();
  }

  void addAuthor(Author author) {
    authors.add(author);

    notifyListeners();
  }

  void updateAuthor(Author author) {
    final index = authors.indexWhere((e) => e.id == author.id);

    if (index != -1) {
      authors[index] = author;

      notifyListeners();
    }
  }

  bool deleteAuthor(String id) {
    if (quotes.any((q) => q.authorId == id)) {
      return false;
    }

    authors.removeWhere((a) => a.id == id);

    notifyListeners();

    return true;
  }

  void addQuote(Quote quote) {
    quotes.add(quote);

    notifyListeners();
  }

  void updateQuote(Quote quote) {
    final index = quotes.indexWhere((e) => e.id == quote.id);

    if (index != -1) {
      quotes[index] = quote;

      notifyListeners();
    }
  }

  void deleteQuote(String id) {
    quotes.removeWhere((e) => e.id == id);

    currentUser.favoriteQuoteIds.remove(id);

    notifyListeners();
  }

  void toggleFavorite(String quoteId) {
    if (currentUser.favoriteQuoteIds.contains(quoteId)) {
      currentUser.favoriteQuoteIds.remove(quoteId);
    } else {
      currentUser.favoriteQuoteIds.add(quoteId);
    }

    notifyListeners();
  }

  bool isFavorite(String quoteId) {
    return currentUser.favoriteQuoteIds.contains(quoteId);
  }

  void togglePreference(String categoryId) {
    if (currentUser.preferredCategoryIds.contains(categoryId)) {
      currentUser.preferredCategoryIds.remove(categoryId);
    } else {
      currentUser.preferredCategoryIds.add(categoryId);
    }

    notifyListeners();
  }

  Author? authorOf(String id) {
    try {
      return authors.firstWhere((author) => author.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Quote> buildFeed() {
    final published = quotes
        .where((quote) => quote.status == QuoteStatus.published)
        .toList();

    final preferred = published
        .where(
          (quote) => quote.categoryIds.any(
            (category) => currentUser.preferredCategoryIds.contains(category),
          ),
        )
        .toList();

    final wildcards = published
        .where(
          (quote) => !quote.categoryIds.any(
            (category) => currentUser.preferredCategoryIds.contains(category),
          ),
        )
        .toList();

    final feed = <Quote>[];

    for (int i = 0; i < preferred.length; i++) {
      feed.add(preferred[i]);

      if (i % 3 == 2 && wildcards.isNotEmpty) {
        feed.add(wildcards[i % wildcards.length]);
      }
    }

    if (feed.isEmpty) {
      feed.addAll(wildcards);
    }

    return feed;
  }

  bool isWildcard(Quote quote) {
    return !quote.categoryIds.any(
      (category) => currentUser.preferredCategoryIds.contains(category),
    );
  }

  Quote? currentGameQuote;

  Author? currentGameCorrectAuthor;

  List<Author> currentGameOptions = [];
  void nextGameQuestion() {
    final published = quotes
        .where((quote) => quote.status == QuoteStatus.published)
        .toList();

    if (published.length < 2) {
      currentGameQuote = null;

      notifyListeners();

      return;
    }

    published.shuffle();

    currentGameQuote = published.first;

    currentGameCorrectAuthor = authorOf(currentGameQuote!.authorId);

    final distractors = authors
        .where((author) => author.id != currentGameQuote!.authorId)
        .toList();

    distractors.shuffle();

    currentGameOptions = [...distractors.take(3), currentGameCorrectAuthor!];

    currentGameOptions.shuffle();

    notifyListeners();
  }

  bool answerGame(Author picked) {
    final correct = picked.id == currentGameCorrectAuthor!.id;

    if (correct) {
      currentUser.gameStreak++;

      final points = 10 + currentUser.gameStreak * 2;

      currentUser.gameScore += points;

      currentUser.xp += points;
    } else {
      currentUser.gameStreak = 0;
    }

    notifyListeners();

    return correct;
  }

  void resetGame() {
    currentUser.gameScore = 0;

    currentUser.gameStreak = 0;

    nextGameQuestion();
  }

  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
