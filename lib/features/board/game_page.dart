import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/board.dart';
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

    return board.when(
      data: (data) => Container(
        decoration: BoxDecoration(
          color: kBoardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 4, color: kBoardBorderColor),
        ),
        child: GridView.count(
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
                          logger.info(
                            '0x${pos.toRadixString(16).padLeft(16, '0')}',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: () {
                              if (board.value!.player & pos != BigInt.zero) {
                                return kDiscWhiteColor;
                              }
                              if (board.value!.opponent & pos != BigInt.zero) {
                                return kDiscBlackColor;
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
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, s) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
