import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/board.dart';
import 'package:reversi_battle/models/game/turn.dart';
import 'package:reversi_battle/utils/logger.dart';
import 'package:reversi_battle/utils/res/res.dart';

class GamePage extends HookConsumerWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _Board(),
        ),
      ),
    );
  }
}

class _Board extends HookConsumerWidget {
  const _Board({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(boardProvider);
    final boardNotifier = ref.watch(boardProvider.notifier);
    final currentTurn = ref.watch(currentTurnProvider);
    final playerTurn = ref.watch(playerTurnProvider);

    return Container(
      decoration: BoxDecoration(
        color: kBoardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 4, color: kBoardBorderColor),
      ),
      child: board.when(
        data: (data) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 8,
            children: [
              for (var i = 0; i < 64; i++)
                () {
                  final pos = BigInt.one << (63 - i);
                  return AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: kBoardColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.9,
                        child: GestureDetector(
                          onTap: () {
                            final str =
                                '0x${pos.toRadixString(16).padLeft(16, '0')}';
                            if (boardNotifier.canMove(
                                BigInt.parse(str), data)) {
                              boardNotifier.move(BigInt.parse(str), data);
                              logger.info(currentTurn);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: () {
                                if (board.value!.player & pos != BigInt.zero) {
                                  if (currentTurn == playerTurn) {
                                    return playerTurn == Turn.black
                                        ? kDiscBlackColor
                                        : kDiscWhiteColor;
                                  } else {
                                    return playerTurn == Turn.black
                                        ? kDiscWhiteColor
                                        : kDiscBlackColor;
                                  }
                                }

                                if (board.value!.opponent & pos !=
                                    BigInt.zero) {
                                  if (currentTurn == playerTurn) {
                                    return playerTurn == Turn.black
                                        ? kDiscWhiteColor
                                        : kDiscBlackColor;
                                  } else {
                                    return playerTurn == Turn.black
                                        ? kDiscBlackColor
                                        : kDiscWhiteColor;
                                  }
                                }
                              }(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }()
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, s) =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
