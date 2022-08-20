import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/board_constants.dart';
import 'package:reversi_battle/features/board/board_service.dart';
import 'package:reversi_battle/models/board.dart';
import 'package:reversi_battle/models/turn.dart';

final gameProvider =
    StateNotifierProvider.autoDispose<GameNotifier, AsyncValue<Board>>(
  (ref) => GameNotifier(ref.read, boardService: BoardService()),
);

final turnProvider = StateProvider.autoDispose((_) => Turn.black);

final _passController = StreamController<bool>();
final passProvider = StreamProvider.autoDispose<bool>((ref) {
  ref.onDispose(_passController.close);
  return _passController.stream;
});

final _gameOverController = StreamController<bool>();
final gameOverProvider = StreamProvider.autoDispose<bool>((ref) {
  ref.onDispose(_gameOverController.close);
  return _gameOverController.stream;
});

class GameNotifier extends StateNotifier<AsyncValue<Board>> {
  GameNotifier(this._read, {required this.boardService})
      : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;
  final BoardService boardService;

  Future<void> _init() async {
    state = await AsyncValue.guard(() async {
      final board = Board(
        player: blackInitialBoard,
        opponent: whiteInitialBoard,
      );
      return board;
    });
  }

  bool tryMove(BigInt move, Board board) {
    if (!boardService.canMove(move, board)) {
      return false;
    }
    _moveAndProgressGame(move, board);
    return true;
  }

  void _moveAndProgressGame(BigInt move, Board board) {
    final movedBoard = boardService.doMove(move, board);
    final nextBoard = boardService.swapPlayerAndOpponent(movedBoard);

    // 終局の判定
    final isGameOver = boardService.isGameOver(nextBoard);
    if (isGameOver) {
      _gameOverController.sink.add(true);
    }

    // パスの判定
    final isPass = boardService.isPass(nextBoard);
    if (!isGameOver && isPass) {
      _passController.sink.add(true);
    }

    if (isPass || isGameOver) {
      // ターンの入れ替えをしないため、盤面の入れ替えはおこなわない
      state = AsyncValue.data(movedBoard);
    } else {
      // ターンを入れ替える
      state = AsyncValue.data(nextBoard);
      _read(turnProvider.state).update((state) => boardService.swapTurn(state));
    }
  }
}
