enum QuoteStatus { draft, published }

class Quote {
  String id;
  String text;
  String authorId;

  List<String> categoryIds;

  bool hasImage;
  bool hasAudio;

  QuoteStatus status;

  Quote({
    required this.id,
    required this.text,
    required this.authorId,
    this.categoryIds = const [],
    this.hasImage = false,
    this.hasAudio = false,
    this.status = QuoteStatus.draft,
  });
}
