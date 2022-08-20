import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/board_service.dart';
import 'package:reversi_battle/features/board/constants.dart';
import 'package:reversi_battle/models/game/board.dart';
import 'package:reversi_battle/models/game/turn.dart';

final boardProvider =
    StateNotifierProvider.autoDispose<BoardNotifier, AsyncValue<Board>>(
  (ref) => BoardNotifier(ref.read, boardService: BoardService()),
);

final currentTurnProvider = StateProvider.autoDispose((_) => Turn.black);

final playerTurnProvider = StateProvider.autoDispose(
  (_) => Random().nextBool() ? Turn.black : Turn.white,
);

class BoardNotifier extends StateNotifier<AsyncValue<Board>> {
  BoardNotifier(this._read, {required this.boardService})
      : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;
  final BoardService boardService;

  Future<void> _init() async {
    // Socket.ioの接続開始

    // プレイヤー・相手の手番が決まればボードを更新
    state = await AsyncValue.guard(() async {
      final board = Board(
        player: blackInitialBoard,
        opponent: whiteInitialBoard,
      );
      return board;
    });
  }

  /// 着手可否を判定
  /// [move]: 着手位置にのみビットが立っているボード
  /// [turn]: 手番
  bool canMove(BigInt move, Board board) {
    return boardService.canMove(move, board);
  }

  /// 着手して反転する
  /// move: 着手位置にのみビットが立っているボード
  void move(BigInt move, Board board) {
    final newBoard = boardService.move(move, board);

    state = AsyncValue.data(boardService.swapBoard(newBoard));

    _read(currentTurnProvider.state)
        .update((state) => boardService.swapTurn(state));
  }
}
