import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/models/board.dart';
import 'package:reversi_battle/models/turn.dart';
import 'package:reversi_battle/utils/res/res.dart';

class BoardWidget extends HookConsumerWidget {
  const BoardWidget({
    Key? key,
    required this.board,
    required this.currentTurn,
    this.onSquareTap,
  }) : super(key: key);

  final Board board;
  final Turn currentTurn;
  final Function(BigInt pos)? onSquareTap;

  Color? getDiscColor(BigInt pos) {
    if (board.player & pos != BigInt.zero) {
      return currentTurn == Turn.black ? kDiscBlackColor : kDiscWhiteColor;
    }
    if (board.opponent & pos != BigInt.zero) {
      return currentTurn == Turn.black ? kDiscWhiteColor : kDiscBlackColor;
    }
    return null;
  }

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
              final movePosition = BigInt.one << (63 - i);

              return GestureDetector(
                onTap: onSquareTap == null
                    ? null
                    : () => onSquareTap!(movePosition),
                child: _Square(
                  isLatestMove: board.latestMove == null
                      ? false
                      : board.latestMove! & movePosition != BigInt.zero,
                  discColor: getDiscColor(movePosition),
                ),
              );
            }(),
        ],
      ),
    );
  }
}

class _Square extends HookConsumerWidget {
  const _Square({Key? key, required this.isLatestMove, this.discColor})
      : super(key: key);

  final bool isLatestMove;
  final Color? discColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: discColor,
                ),
              ),
              if (isLatestMove)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kLatestMovePointColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
