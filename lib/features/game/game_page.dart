import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/game/states/game.dart';
import 'package:reversi_battle/features/game/top_page.dart';
import 'package:reversi_battle/features/game/widgets/board_widget.dart';
import 'package:reversi_battle/utils/logger.dart';
import 'package:reversi_battle/utils/scaffold_messenger_key.dart';

class GamePage extends HookConsumerWidget {
  const GamePage._({Key? key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: ((context) => const GamePage._()),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(passProvider).whenData((_) {
      ref.read(scaffoldMessengerKeyProvider).currentState?.showSnackBar(
            SnackBar(
              content: const Text('パス！'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
      logger.info('パス！');
    });

    ref.watch(gameOverProvider).whenData((_) {
      logger.info('終局！');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(TopPage.route);
      });
    });

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
                final turn = ref.watch(turnProvider);

                return board.when(
                  data: (data) => BoardWidget(
                    board: data,
                    turn: turn,
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
