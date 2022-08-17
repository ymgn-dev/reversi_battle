import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reversi_battle/features/board/constants.dart';
import 'package:reversi_battle/models/board/board.dart';
import 'package:reversi_battle/utils/logger.dart';

final boardProvider = StateNotifierProvider<BoardNotifier, AsyncValue<Board>>(
    (ref) => BoardNotifier());

class BoardNotifier extends StateNotifier<AsyncValue<Board>> {
  BoardNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    // Socket.ioの接続開始

    // プレイヤー・相手の手番が決まればボードを更新
    state = await AsyncValue.guard(() async {
      final board =
          Board(player: initWBits, opponent: initBBits, turn: turnBlack);
      return board;
    });

    _printBoard();

    logger.info('init呼ばれた');
  }

  /// 着手可否を判定
  /// move: 着手位置にのみビットが立っているボード
  bool canMove(BigInt move) {
    // 合法手ボードを生成
    final legalBoard = _makeLegalBoard();
    return (move & legalBoard) == move;
  }

  /// 着手して反転する
  /// move: 着手位置にのみビットが立っているボード
  void move(BigInt move) {
    var rev = zero;
    for (var dir = 0; dir < 8; dir++) {
      var rev_ = zero;
      var mask = _transfer(move, dir);
      while (mask != zero && (mask & state.value!.opponent) != zero) {
        rev_ |= mask;
        mask = _transfer(mask, dir);
      }
      if (mask & state.value!.player != zero) {
        rev |= rev_;
      }
    }
    // 反転する
    final newBoard = Board(
      player: state.value!.player ^ (move | rev),
      opponent: state.value!.opponent ^ rev,
      turn: 1 - state.value!.turn,
    );
    state = AsyncValue.data(newBoard);
  }

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

  /// プレイヤー側の合法手ボードを生成
  BigInt _makeLegalBoard() {
    final plBits = state.value!.player;
    final opBits = state.value!.opponent;
    // 左右の番人
    final horizBits = opBits & BigInt.parse('0x7e7e7e7e7e7e7e7e');
    // 上下の番人
    final vertBits = opBits & BigInt.parse('0x00FFFFFFFFFFFF00');
    // 全辺の番人
    final allBits = opBits & BigInt.parse('0x007e7e7e7e7e7e00');
    // 空きマスのみにビットが立っている盤面
    final vacantBits = _vacant(plBits, opBits);
    // 隣に手番でない側の石があるか一時保存
    var tmp = BigInt.zero;
    // 返り値
    var retBits = BigInt.zero;

    // 8方向チェック

    // 左
    tmp = horizBits & (plBits << 1);
    tmp |= horizBits & (tmp << 1);
    tmp |= horizBits & (tmp << 1);
    tmp |= horizBits & (tmp << 1);
    tmp |= horizBits & (tmp << 1);
    tmp |= horizBits & (tmp << 1);
    retBits = vacantBits & (tmp << 1);

    // 右
    tmp = horizBits & (plBits >> 1);
    tmp |= horizBits & (tmp >> 1);
    tmp |= horizBits & (tmp >> 1);
    tmp |= horizBits & (tmp >> 1);
    tmp |= horizBits & (tmp >> 1);
    tmp |= horizBits & (tmp >> 1);
    retBits |= vacantBits & (tmp >> 1);

    // 上
    tmp = vertBits & (plBits << 8);
    tmp |= vertBits & (tmp << 8);
    tmp |= vertBits & (tmp << 8);
    tmp |= vertBits & (tmp << 8);
    tmp |= vertBits & (tmp << 8);
    tmp |= vertBits & (tmp << 8);
    retBits |= vacantBits & (tmp << 8);

    // 下
    tmp = vertBits & (plBits >> 8);
    tmp |= vertBits & (tmp >> 8);
    tmp |= vertBits & (tmp >> 8);
    tmp |= vertBits & (tmp >> 8);
    tmp |= vertBits & (tmp >> 8);
    tmp |= vertBits & (tmp >> 8);
    retBits |= vacantBits & (tmp >> 8);

    // 右斜め上
    tmp = allBits & (plBits << 7);
    tmp |= allBits & (tmp << 7);
    tmp |= allBits & (tmp << 7);
    tmp |= allBits & (tmp << 7);
    tmp |= allBits & (tmp << 7);
    tmp |= allBits & (tmp << 7);
    retBits |= vacantBits & (tmp << 7);

    // 左斜め上
    tmp = allBits & (plBits << 9);
    tmp |= allBits & (tmp << 9);
    tmp |= allBits & (tmp << 9);
    tmp |= allBits & (tmp << 9);
    tmp |= allBits & (tmp << 9);
    tmp |= allBits & (tmp << 9);
    retBits |= vacantBits & (tmp << 9);

    // 右斜め下
    tmp = allBits & (plBits >> 9);
    tmp |= allBits & (tmp >> 9);
    tmp |= allBits & (tmp >> 9);
    tmp |= allBits & (tmp >> 9);
    tmp |= allBits & (tmp >> 9);
    tmp |= allBits & (tmp >> 9);
    retBits |= vacantBits & (tmp >> 9);

    // 左斜め下
    tmp = allBits & (plBits >> 7);
    tmp |= allBits & (tmp >> 7);
    tmp |= allBits & (tmp >> 7);
    tmp |= allBits & (tmp >> 7);
    tmp |= allBits & (tmp >> 7);
    tmp |= allBits & (tmp >> 7);
    retBits |= vacantBits & (tmp >> 7);

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

  void _printBoard() {
    final pl = state.value!.player.toRadixString(2).padLeft(64, '0');
    final opp = state.value!.opponent.toRadixString(2).padLeft(64, '0');
    assert(pl.length == 64 && pl.length == opp.length);

    for (var i = 0; i < 64; i++) {
      if (i > 7 && i % 8 == 0) {
        stdout.write('\n');
      }
      stdout.write(
        pl[i] == '1'
            ? '⚪️'
            : opp[i] == "1"
                ? '⚫️'
                : '⬜️',
      );
    }
    stdout.write('\n');
  }
}
