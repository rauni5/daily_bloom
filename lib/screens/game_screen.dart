import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../utils/responsive.dart';

enum _Mode { guessAuthor, completeQuote }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  _Mode mode = _Mode.guessAuthor;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Quote Quest")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ResponsiveCenter(
          maxWidth: 600,
          child: Column(
            children: [
              SegmentedButton<_Mode>(
                segments: const [
                  ButtonSegment(
                    value: _Mode.guessAuthor,
                    label: Text("Guess the Author"),
                    icon: Icon(Icons.person_search),
                  ),
                  ButtonSegment(
                    value: _Mode.completeQuote,
                    label: Text("Complete the Quote"),
                    icon: Icon(Icons.edit_note),
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (selected) {
                  setState(() {
                    mode = selected.first;
                  });
                },
              ),

              const SizedBox(height: 24),

              Expanded(
                child: mode == _Mode.guessAuthor
                    ? _GuessAuthorGame(app: app)
                    : _CompleteQuoteGame(app: app),
              ),

              Text("Score: ${app.currentUser.gameScore}"),
              Text("Streak: ${app.currentUser.gameStreak}"),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuessAuthorGame extends StatelessWidget {
  final AppState app;

  const _GuessAuthorGame({required this.app});

  @override
  Widget build(BuildContext context) {
    if (app.currentGameQuote == null) {
      app.nextGameQuestion();
    }

    if (app.currentGameQuote == null) {
      return const Center(child: Text("Not enough quotes."));
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              app.currentGameQuote!.text,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),

        const SizedBox(height: 30),

        ...app.currentGameOptions.map(
          (author) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final correct = app.answerGame(author);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(correct ? "Correct!" : "Wrong!")),
                  );

                  app.nextGameQuestion();
                },
                child: Text(author.name),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompleteQuoteGame extends StatelessWidget {
  final AppState app;

  const _CompleteQuoteGame({required this.app});

  @override
  Widget build(BuildContext context) {
    if (app.currentBlankQuote == null) {
      app.nextCompleteQuoteQuestion();
    }

    if (app.currentBlankQuote == null) {
      return const Center(child: Text("Not enough quotes."));
    }

    final author = app.authorOf(app.currentBlankQuote!.authorId);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  app.currentMaskedText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (author != null)
                  Text(
                    "— ${author.name}",
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        ...app.currentBlankOptions.map(
          (word) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final correct = app.answerCompleteQuote(word);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(correct ? "Correct!" : "Wrong!")),
                  );

                  app.nextCompleteQuoteQuestion();
                },
                child: Text(word),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
