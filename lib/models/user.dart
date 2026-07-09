class AppUser {
  String name;

  List<String> preferredCategoryIds;

  List<String> favoriteQuoteIds;

  int streakCount;

  int xp;

  int gameScore;

  int gameStreak;

  AppUser({
    required this.name,
    List<String>? preferredCategoryIds,
    List<String>? favoriteQuoteIds,
    this.streakCount = 4,
    this.xp = 0,
    this.gameScore = 0,
    this.gameStreak = 0,
  }) : preferredCategoryIds = preferredCategoryIds ?? [],
       favoriteQuoteIds = favoriteQuoteIds ?? [];
}
