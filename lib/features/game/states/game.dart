import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/board_constants.dart';
import 'package:reversi_battle/features/board/board_service.dart';
import 'package:reversi_battle/models/board.dart';
import 'package:reversi_battle/models/turn.dart';
import 'package:reversi_battle/utils/logger.dart';

final gameProvider =
    StateNotifierProvider.autoDispose<GameNotifier, AsyncValue<Board>>(
  (ref) {
    ref.onDispose(() => logger.info('gameProvider#dispose'));
    return GameNotifier(ref.read, boardService: BoardService());
  },
);

final turnProvider = StateProvider.autoDispose((ref) {
  ref.onDispose(() => logger.info('turnProvider#dispose'));
  return Turn.black;
});

StreamController<bool>? _passController;
final passProvider = StreamProvider.autoDispose<bool>((ref) {
  ref.onDispose((() {
    _passController?.close();
    _passController = null;
    logger.info('passProvider#dispose');
  }));
  _passController ??= StreamController<bool>();
  return _passController!.stream;
});

StreamController<bool>? _gameOverController;
final gameOverProvider = StreamProvider.autoDispose<bool>((ref) {
  ref.onDispose(() {
    _gameOverController?.close();
    _gameOverController = null;
    logger.info('gameOverProvider#dispose');
  });

  _gameOverController ??= StreamController<bool>();
  return _gameOverController!.stream;
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
    logger.info('GameNotifier#_init');
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
    state = AsyncValue.data(movedBoard);
    _checkUpdate();
  }

  void _checkUpdate() {
    if (state.value == null) {
      return;
    }

    final board = state.value!;
    final nextBoard = boardService.swapPlayerAndOpponent(board);

    // 終局の判定
    final isGameOver = boardService.isGameOver(nextBoard);
    if (isGameOver) {
      logger.info('終局判定');
      if (_gameOverController != null && !_gameOverController!.isClosed) {
        _gameOverController!.add(true);
      } else {
        logger.warning('_gameOverController.isClosed');
      }
    }

    // パスの判定
    final isPass = boardService.isPass(nextBoard);
    if (!isGameOver && isPass) {
      if (_passController != null && !_passController!.isClosed) {
        _passController!.add(true);
      }
    }

    if (!isPass & !isGameOver) {
      // ターンを入れ替える
      state = AsyncValue.data(nextBoard);
      _read(turnProvider.state).update((state) => boardService.swapTurn(state));
    }
  }
}
