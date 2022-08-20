import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/game/states/game.dart';
import 'package:reversi_battle/features/game/widgets/board_widget.dart';

class GamePage extends HookConsumerWidget {
  const GamePage._({Key? key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: ((context) => const GamePage._()),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('仮テキスト！'),
              const SizedBox(height: 32),
              const Placeholder(fallbackHeight: 32),
              const SizedBox(height: 32),
              HookConsumer(builder: ((context, ref, child) {
                final board = ref.watch(gameProvider);
                final notifier = ref.watch(gameProvider.notifier);

                final currentTurn = ref.watch(turnProvider);

                return board.when(
                  data: (data) => BoardWidget(
                    board: data,
                    currentTurn: currentTurn,
                    onSquareTap: ((pos) => notifier.tryMove(pos, data)),
                  ),
                  error: (e, s) =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                );
              })),
            ],
          ),
        ),
      ),
    );
  }
}
