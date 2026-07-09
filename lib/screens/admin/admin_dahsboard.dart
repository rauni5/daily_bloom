import 'package:daily_bloom/screens/admin/admin_authors_screen.dart';
import 'package:daily_bloom/screens/admin/admin_categories_screen.dart';
import 'package:daily_bloom/screens/admin/admin_quotes_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../utils/responsive.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    final publishedCount = app.quotes
        .where((q) => q.status.name == "published")
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Stack stat cards 2-up on phones, 4-up on tablet/desktop/web.
          final statColumns = constraints.maxWidth >= Breakpoints.tablet
              ? 4
              : 2;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ResponsiveCenter(
                maxWidth: 900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: statColumns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(
                          label: "Categories",
                          value: app.categories.length,
                        ),
                        _StatCard(label: "Authors", value: app.authors.length),
                        _StatCard(label: "Quotes", value: app.quotes.length),
                        _StatCard(label: "Published", value: publishedCount),
                      ],
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      "Quotes per Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...app.categories.map((category) {
                      final count = app.quotes
                          .where((q) => q.categoryIds.contains(category.id))
                          .length;

                      final maxCount = app.categories
                          .map(
                            (c) => app.quotes
                                .where((q) => q.categoryIds.contains(c.id))
                                .length,
                          )
                          .fold(1, (a, b) => a > b ? a : b);

                      final fraction = count / maxCount;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                "${category.icon} ${category.name}",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: fraction.clamp(0.0, 1.0),
                                    child: Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text("$count"),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 28),

                    const Text(
                      "Manage",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Side-by-side management cards on wide screens, stacked on phone.
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ManageCard(
                          width: constraints.maxWidth,
                          icon: Icons.category,
                          label: "Manage Categories",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageCategoriesScreen(),
                              ),
                            );
                          },
                        ),
                        _ManageCard(
                          width: constraints.maxWidth,
                          icon: Icons.person,
                          label: "Manage Authors",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageAuthorsScreen(),
                              ),
                            );
                          },
                        ),
                        _ManageCard(
                          width: constraints.maxWidth,
                          icon: Icons.format_quote,
                          label: "Manage Quotes",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManageQuotesScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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

class _StatCard extends StatelessWidget {
  final String label;
  final int value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$value",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _ManageCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ManageCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Full width on phone, ~1/3 width on tablet/desktop/web (minus spacing).
    final wide = width >= Breakpoints.tablet;
    final cardWidth = wide ? (width.clamp(0, 900) - 24) / 3 : double.infinity;

    return SizedBox(
      width: cardWidth,
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(label),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
