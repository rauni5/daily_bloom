import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    if (app.currentGameQuote == null) {
      app.nextGameQuestion();
    }

    if (app.currentGameQuote == null) {
      return const Scaffold(body: Center(child: Text("Not enough quotes.")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Guess the Author")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
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
                        SnackBar(
                          content: Text(correct ? "Correct!" : "Wrong!"),
                        ),
                      );

                      app.nextGameQuestion();
                    },

                    child: Text(author.name),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Text("Score: ${app.currentUser.gameScore}"),

            Text("Streak: ${app.currentUser.gameStreak}"),
          ],
        ),
      ),
    );
  }
}
