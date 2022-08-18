import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/constants.dart';
import 'package:reversi_battle/models/game/board.dart';
import 'package:reversi_battle/models/game/turn.dart';

final boardProvider =
    StateNotifierProvider.autoDispose<BoardNotifier, AsyncValue<Board>>(
  (ref) => BoardNotifier(ref.read),
);

final currentTurnProvider = StateProvider.autoDispose((_) => Turn.black);

final playerTurnProvider = StateProvider.autoDispose(
  (_) => Random().nextBool() ? Turn.black : Turn.white,
);

/*
init(); 初期化処理
canMove(); 着手可否を判定
getMoves(); 着手可能位置を取得
getMobility(); 着手可能なマスの数を判定
*/

class BoardNotifier extends StateNotifier<AsyncValue<Board>> {
  BoardNotifier(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

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
  bool canMove(BigInt move, Turn turn) {
    // 合法手ボードを生成
    final moves = getMoves(turn);
    return (move & moves) == move;
  }

  /// 着手して反転する
  /// move: 着手位置にのみビットが立っているボード
  void move(BigInt move, Turn turn) {
    final isPlayerSide = turn == _read(playerTurnProvider);
    final playerBoard = state.value!.player;
    final opponentBoard = state.value!.opponent;

    final player = isPlayerSide ? playerBoard : opponentBoard;
    final opponent = isPlayerSide ? opponentBoard : playerBoard;

    var rev = zero;

    for (var dir = 0; dir < 8; dir++) {
      var rev_ = zero;
      var mask = _transfer(move, dir);
      while (mask != zero && (mask & opponent) != zero) {
        rev_ |= mask;
        mask = _transfer(mask, dir);
      }
      if (mask & player != zero) {
        rev |= rev_;
      }
    }

    // 反転する
    final newBoard = Board(
      player: isPlayerSide ? playerBoard ^ (move | rev) : opponentBoard ^ rev,
      opponent:
          !isPlayerSide ? opponentBoard ^ rev : playerBoard ^ (move | rev),
    );
    state = AsyncValue.data(newBoard);
    _read(currentTurnProvider.state).update(
      (state) => state == Turn.black ? Turn.white : Turn.black,
    );
  }

  // void move(BigInt move) {
  //   var rev = zero;
  //   for (var dir = 0; dir < 8; dir++) {
  //     var rev_ = zero;
  //     var mask = _transfer(move, dir);
  //     while (mask != zero && (mask & state.value!.opponent) != zero) {
  //       rev_ |= mask;
  //       mask = _transfer(mask, dir);
  //     }
  //     if (mask & state.value!.player != zero) {
  //       rev |= rev_;
  //     }
  //   }
  //   // 反転する
  //   final newBoard = Board(
  //     player: state.value!.player ^ (move | rev),
  //     opponent: state.value!.opponent ^ rev,
  //     playerTurn: state.value!.playerTurn,
  //     currentTurn:
  //         state.value!.currentTurn == Turn.black ? Turn.white : Turn.black,
  //   );
  //   state = AsyncValue.data(newBoard);
  // }

  /// 反転箇所を求める
  /// move: 着手位置にのみビットが立っているボード
  /// dir: 反転方向(8方向)
  BigInt _transfer(BigInt move, int dir) {
    switch (dir) {
      case 0:
        return (move << 8) & BigInt.parse('0xffffffffffffff00');
      case 1:
        return (move << 7) & BigInt.parse('0x7f7f7f7f7f7f7f00');
      case 2:
        return (move >> 1) & BigInt.parse('0x7f7f7f7f7f7f7f7f');
      case 3:
        return (move >> 9) & BigInt.parse('0x007f7f7f7f7f7f7f');
      case 4:
        return (move >> 8) & BigInt.parse('0x00ffffffffffffff');
      case 5:
        return (move >> 7) & BigInt.parse('0x00fefefefefefefe');
      case 6:
        return (move << 1) & BigInt.parse('0xfefefefefefefefe');
      case 7:
        return (move << 9) & BigInt.parse('0xfefefefefefefe00');
      default:
        return BigInt.zero;
    }
  }

  /// [turn]側の合法手ボードを生成
  BigInt getMoves(Turn turn) {
    final isPlayerSide = turn == _read(playerTurnProvider);
    final playerBoard = state.value!.player;
    final opponentBoard = state.value!.opponent;

    final player = isPlayerSide ? playerBoard : opponentBoard;
    final opponent = isPlayerSide ? opponentBoard : playerBoard;

    // 左右の番人
    final horizontal = opponent & BigInt.parse('0x7e7e7e7e7e7e7e7e');
    // 上下の番人
    final vertical = opponent & BigInt.parse('0x00FFFFFFFFFFFF00');
    // 全辺の番人
    final all = opponent & BigInt.parse('0x007e7e7e7e7e7e00');
    // 空きマスのみにビットが立っている盤面
    final vacant = _vacant(player, opponent);
    // 隣に手番でない側の石があるか一時保存
    var tmp = BigInt.zero;
    // 返り値
    var retBits = BigInt.zero;

    // 8方向チェック

    // 左
    tmp = horizontal & (player << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    retBits = vacant & (tmp << 1);

    // 右
    tmp = horizontal & (player >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    retBits |= vacant & (tmp >> 1);

    // 上
    tmp = vertical & (player << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    retBits |= vacant & (tmp << 8);

    // 下
    tmp = vertical & (player >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    retBits |= vacant & (tmp >> 8);

    // 右斜め上
    tmp = all & (player << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    retBits |= vacant & (tmp << 7);

    // 左斜め上
    tmp = all & (player << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    retBits |= vacant & (tmp << 9);

    // 右斜め下
    tmp = all & (player >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    retBits |= vacant & (tmp >> 9);

    // 左斜め下
    tmp = all & (player >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    retBits |= vacant & (tmp >> 7);

    return retBits;
  }

  /// 石数をカウントする
  int _populationCount(BigInt bits) {
    bits -= ((bits >> 1) & m1);
    bits = (bits & m2) + ((bits >> 2) & m2);
    bits = (bits + (bits >> 4)) & m4;
    bits += (bits >> 8);
    bits += (bits >> 16);
    bits += (bits >> 32);
    return (bits & BigInt.from(0x7f)).toInt();
  }

  /// 空きマスのみにビットが立っている盤面を返す
  BigInt _vacant(BigInt player, BigInt opponent) {
    return ~(player | opponent);
  }

  /// 空きマスの数をカウントする
  int _vacantCount(BigInt player, BigInt opponent) {
    return _populationCount(_vacant(player, opponent));
  }
}
