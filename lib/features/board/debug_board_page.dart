import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/models/board.dart';
import 'package:reversi_battle/utils/res/res.dart';

/// [board]もしくは[discs]を引数に渡すことで、その盤面を表示するページです。
///
/// [board]を渡した場合、player側が先手(黒番)として表示されます。
/// [discs]を渡した場合、全て先手(黒番)として表示されます。
class DebugBoardPage extends HookConsumerWidget {
  const DebugBoardPage({Key? key, this.board, this.discs})
      : assert((board == null && discs != null) ||
            (board != null && discs == null)),
        super(key: key);

  final Board? board;
  final BigInt? discs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _Board(board: board, discs: discs),
        ),
      ),
    );
  }
}

class _Board extends HookConsumerWidget {
  const _Board({Key? key, this.board, this.discs})
      : assert((board == null && discs != null) ||
            (board != null && discs == null)),
        super(key: key);

  final Board? board;
  final BigInt? discs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: () {
                          if (discs != null && discs! & pos != BigInt.zero) {
                            return kDiscBlackColor;
                          }
                          if (board != null) {
                            if (board!.player & pos != BigInt.zero) {
                              return kDiscBlackColor;
                            } else if (board!.opponent & pos != BigInt.zero) {
                              return kDiscWhiteColor;
                            }
                          }
                        }(),
                      ),
                    ),
                  ),
                ),
              );
            }()
        ],
      ),
    );
  }
}
