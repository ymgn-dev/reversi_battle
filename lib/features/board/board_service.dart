import 'package:reversi_battle/features/board/constants.dart';
import 'package:reversi_battle/models/game/board.dart';
import 'package:reversi_battle/models/game/turn.dart';

class BoardService {
  /// [board.player]側の着手可否を判定
  /// [move]着手位置にのみビットが立っているボード
  /// [board]盤面
  bool canMove(BigInt move, Board board) {
    // 合法手ボードを生成
    final moves = getMoves(board);
    return (move & moves) == move;
  }

  /// [board.player]側の着手処理
  /// [move]着手位置にのみビットが立っているボード
  /// [board]盤面
  Board move(BigInt move, Board board) {
    var rev = zero;
    for (var dir = 0; dir < 8; dir++) {
      var rev_ = zero;
      var mask = _transfer(move, dir);
      while (mask != zero && (mask & board.opponent) != zero) {
        rev_ |= mask;
        mask = _transfer(mask, dir);
      }
      if (mask & board.player != zero) {
        rev |= rev_;
      }
    }

    return Board(
      player: board.player ^ (move | rev),
      opponent: board.opponent ^ rev,
    );
  }

  /// ターンを入れ替える
  Turn swapTurn(Turn turn) {
    return turn == Turn.black ? Turn.white : Turn.black;
  }

  /// プレイヤー側と相手側の盤面を入れ替える
  Board swapBoard(Board board) {
    return Board(player: board.opponent, opponent: board.player);
  }

  /// [board.player]側の合法手ボードを生成
  /// [board]盤面
  BigInt getMoves(Board board) {
    // 左右の番人
    final horizontal = board.opponent & BigInt.parse('0x7e7e7e7e7e7e7e7e');
    // 上下の番人
    final vertical = board.opponent & BigInt.parse('0x00FFFFFFFFFFFF00');
    // 全辺の番人
    final all = board.opponent & BigInt.parse('0x007e7e7e7e7e7e00');
    // 空きマスのみにビットが立っている盤面
    final vacant_ = vacant(board);
    // 隣に手番でない側の石があるか一時保存
    var tmp = BigInt.zero;
    // 返り値
    var retBits = BigInt.zero;

    // 8方向チェック

    // 左
    tmp = horizontal & (board.player << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    tmp |= horizontal & (tmp << 1);
    retBits = vacant_ & (tmp << 1);

    // 右
    tmp = horizontal & (board.player >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    retBits |= vacant_ & (tmp >> 1);

    // 上
    tmp = vertical & (board.player << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    retBits |= vacant_ & (tmp << 8);

    // 下
    tmp = vertical & (board.player >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    retBits |= vacant_ & (tmp >> 8);

    // 右斜め上
    tmp = all & (board.player << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    retBits |= vacant_ & (tmp << 7);

    // 左斜め上
    tmp = all & (board.player << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    retBits |= vacant_ & (tmp << 9);

    // 右斜め下
    tmp = all & (board.player >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    retBits |= vacant_ & (tmp >> 9);

    // 左斜め下
    tmp = all & (board.player >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    retBits |= vacant_ & (tmp >> 7);

    return retBits;
  }

  /// 石数をカウントする
  int populationCount(BigInt bit) {
    bit -= ((bit >> 1) & m1);
    bit = (bit & m2) + ((bit >> 2) & m2);
    bit = (bit + (bit >> 4)) & m4;
    bit += (bit >> 8);
    bit += (bit >> 16);
    bit += (bit >> 32);
    return (bit & BigInt.from(0x7f)).toInt();
  }

  /// 空きマスのみにビットが立っている盤面を返す
  BigInt vacant(Board board) {
    return ~(board.player | board.opponent);
  }

  /// 空きマスの数をカウントする
  int vacantCount(Board board) {
    return populationCount(vacant(board));
  }

  /// [board.player]が[m]に着手した時に反転する数を求める
  /// [m]着手位置にのみビットが立っている盤面
  /// [board]盤面
  int swapCount(BigInt m, Board board) {
    final result = move(m, board);

    return (populationCount(result.player ^ board.player) +
        populationCount(result.opponent ^ board.opponent));
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
}
