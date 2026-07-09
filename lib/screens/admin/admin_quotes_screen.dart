import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/author.dart';
import '../../models/category.dart';
import '../../models/quote.dart';
import '../../state/app_state.dart';

class ManageQuotesScreen extends StatelessWidget {
  const ManageQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Quotes"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuoteDialog(context),
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: app.quotes.length,
        itemBuilder: (_, index) {
          final quote = app.quotes[index];
          final author = app.authorOf(quote.authorId);

          return Card(
            child: ListTile(
              title: Text(
                quote.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              subtitle: Text(
                author?.name ?? "Unknown",
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(
                    quote.status == QuoteStatus.published
                        ? Icons.public
                        : Icons.edit_note,
                    color: quote.status == QuoteStatus.published
                        ? Colors.green
                        : Colors.orange,
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showQuoteDialog(
                        context,
                        quote: quote,
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      app.deleteQuote(quote.id);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showQuoteDialog(
    BuildContext context, {
    Quote? quote,
  }) {
    final app = context.read<AppState>();

    final textController =
        TextEditingController(text: quote?.text);

    String? selectedAuthor =
        quote?.authorId ?? app.authors.first.id;

    QuoteStatus status =
        quote?.status ?? QuoteStatus.draft;

    bool hasImage = quote?.hasImage ?? false;
    bool hasAudio = quote?.hasAudio ?? false;

    List<String> selectedCategories =
        List.from(quote?.categoryIds ?? []);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                quote == null
                    ? "Add Quote"
                    : "Edit Quote",
              ),

              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      TextField(
                        controller: textController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Quote",
                        ),
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        value: selectedAuthor,
                        decoration: const InputDecoration(
                          labelText: "Author",
                        ),
                        items: app.authors
                            .map(
                              (Author author) =>
                                  DropdownMenuItem(
                                value: author.id,
                                child: Text(author.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAuthor = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Wrap(
                        spacing: 8,
                        children: app.categories
                            .map(
                              (Category category) => FilterChip(
                                label: Text(category.name),
                                selected: selectedCategories
                                    .contains(category.id),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedCategories
                                          .add(category.id);
                                    } else {
                                      selectedCategories
                                          .remove(category.id);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<QuoteStatus>(
                        value: status,
                        decoration: const InputDecoration(
                          labelText: "Status",
                        ),
                        items: QuoteStatus.values
                            .map(
                              (status) =>
                                  DropdownMenuItem(
                                value: status,
                                child: Text(
                                  status.name,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            status = value!;
                          });
                        },
                      ),

                      SwitchListTile(
                        value: hasImage,
                        title: const Text("Has Image"),
                        onChanged: (value) {
                          setState(() {
                            hasImage = value;
                          });
                        },
                      ),

                      SwitchListTile(
                        value: hasAudio,
                        title: const Text("Has Audio"),
                        onChanged: (value) {
                          setState(() {
                            hasAudio = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {

                    if (textController.text.trim().isEmpty) {
                      return;
                    }

                    final newQuote = Quote(
                      id: quote?.id ??
                          DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),

                      text: textController.text.trim(),

                      authorId: selectedAuthor!,

                      categoryIds: selectedCategories,

                      hasImage: hasImage,

                      hasAudio: hasAudio,

                      status: status,
                    );

                    if (quote == null) {
                      app.addQuote(newQuote);
                    } else {
                      app.updateQuote(newQuote);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    quote == null
                        ? "Add"
                        : "Save",
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}