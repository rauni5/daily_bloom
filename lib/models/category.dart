class Category {
  String id;
  String name;
  String icon;
  String description;
  bool isActive;

  Category({
    required this.id,
    required this.name,
    this.icon = "✺",
    this.description = "",
    this.isActive = true,
  });
}
