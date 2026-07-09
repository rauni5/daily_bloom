import '../models/author.dart';
import '../models/category.dart';
import '../models/quote.dart';

final List<Category> seedCategories = [
  Category(
    id: "cat1",
    name: "Motivation",
    icon: "💪",
    description: "Daily motivation",
  ),

  Category(
    id: "cat2",
    name: "Mindfulness",
    icon: "🧘",
    description: "Inner peace",
  ),

  Category(id: "cat3", name: "Love", icon: "❤️", description: "Relationships"),

  Category(
    id: "cat4",
    name: "Success",
    icon: "🏆",
    description: "Achieving goals",
  ),

  Category(
    id: "cat5",
    name: "Grief & Healing",
    icon: "🌧",
    description: "Healing journey",
  ),

  Category(
    id: "cat6",
    name: "Humor",
    icon: "😂",
    description: "Smile every day",
  ),

  Category(
    id: "cat7",
    name: "Stoicism",
    icon: "🏛",
    description: "Ancient wisdom",
  ),

  Category(
    id: "cat8",
    name: "Nature",
    icon: "🌿",
    description: "Calm and growth",
  ),
];

final List<Author> seedAuthors = [
  Author(
    id: "a1",
    name: "Marcus Aurelius",
    bio: "Roman Emperor and Stoic philosopher.",
    tag: "Stoic",
  ),

  Author(
    id: "a2",
    name: "Thich Nhat Hanh",
    bio: "Vietnamese Zen Master.",
    tag: "Mindfulness",
  ),

  Author(
    id: "a3",
    name: "Maya Angelou",
    bio: "Poet and activist.",
    tag: "Motivation",
  ),

  Author(
    id: "a4",
    name: "Confucius",
    bio: "Chinese philosopher.",
    tag: "Wisdom",
  ),
];

final List<Quote> seedQuotes = [
  Quote(
    id: "q1",
    text: "You have power over your mind, not outside events.",
    authorId: "a1",
    categoryIds: ["cat7"],
    hasImage: true,
    hasAudio: true,
    status: QuoteStatus.published,
  ),

  Quote(
    id: "q2",
    text: "Breathing in, I calm body and mind.",
    authorId: "a2",
    categoryIds: ["cat2"],
    hasImage: true,
    status: QuoteStatus.published,
  ),

  Quote(
    id: "q3",
    text: "Nothing can dim the light that shines from within.",
    authorId: "a3",
    categoryIds: ["cat1"],
    status: QuoteStatus.published,
  ),

  Quote(
    id: "q4",
    text: "Everything has beauty, but not everyone sees it.",
    authorId: "a4",
    categoryIds: ["cat8"],
    status: QuoteStatus.published,
  ),

  Quote(
    id: "q5",
    text: "Success is liking yourself.",
    authorId: "a3",
    categoryIds: ["cat4"],
    status: QuoteStatus.published,
  ),

  Quote(
    id: "q6",
    text: "Healing takes courage.",
    authorId: "a3",
    categoryIds: ["cat5"],
    status: QuoteStatus.published,
  ),
];
