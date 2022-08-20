import 'package:reversi_battle/features/board/constants.dart';
import 'package:reversi_battle/models/game/board.dart';
import 'package:reversi_battle/models/game/turn.dart';

class BoardService {
  /// player側の着手可否を判定
  /// [move]着手位置にのみビットが立っているボード
  /// [board]盤面
  bool canMove(BigInt move, Board board) {
    // 合法手ボードを生成
    final moves = getMoves(board);
    return (move & moves) == move;
  }

  /// player側の着手処理
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

  /// パスの判定
  /// player側がパスかを判定
  bool isPass(Board board) {
    return calcPopulationCount(getMoves(board)) == 0;
  }

  /// 終局の判定
  /// player, opponent両方がパスであれば終局
  bool isGameFinished(Board board) {
    return isPass(board) && isPass(swapBoard(board));
  }

  /// playerとopponentの盤面を入れ替える
  Board swapBoard(Board board) {
    return Board(player: board.opponent, opponent: board.player);
  }

  /// player側の合法手ボードを生成
  /// [board]盤面
  BigInt getMoves(Board board) {
    // 左右の番人
    final horizontal = board.opponent & BigInt.parse('0x7e7e7e7e7e7e7e7e');
    // 上下の番人
    final vertical = board.opponent & BigInt.parse('0x00FFFFFFFFFFFF00');
    // 全辺の番人
    final all = board.opponent & BigInt.parse('0x007e7e7e7e7e7e00');
    // 空きマスのみにビットが立っている盤面
    final vacant = calcVacant(board);
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
    retBits = vacant & (tmp << 1);

    // 右
    tmp = horizontal & (board.player >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    tmp |= horizontal & (tmp >> 1);
    retBits |= vacant & (tmp >> 1);

    // 上
    tmp = vertical & (board.player << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    tmp |= vertical & (tmp << 8);
    retBits |= vacant & (tmp << 8);

    // 下
    tmp = vertical & (board.player >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    tmp |= vertical & (tmp >> 8);
    retBits |= vacant & (tmp >> 8);

    // 右斜め上
    tmp = all & (board.player << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    tmp |= all & (tmp << 7);
    retBits |= vacant & (tmp << 7);

    // 左斜め上
    tmp = all & (board.player << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    tmp |= all & (tmp << 9);
    retBits |= vacant & (tmp << 9);

    // 右斜め下
    tmp = all & (board.player >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    tmp |= all & (tmp >> 9);
    retBits |= vacant & (tmp >> 9);

    // 左斜め下
    tmp = all & (board.player >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    tmp |= all & (tmp >> 7);
    retBits |= vacant & (tmp >> 7);

    return retBits;
  }

  /// 石数をカウントする
  int calcPopulationCount(BigInt bit) {
    bit -= ((bit >> 1) & m1);
    bit = (bit & m2) + ((bit >> 2) & m2);
    bit = (bit + (bit >> 4)) & m4;
    bit += (bit >> 8);
    bit += (bit >> 16);
    bit += (bit >> 32);
    return (bit & BigInt.from(0x7f)).toInt();
  }

  /// 空きマスのみにビットが立っている盤面を返す
  BigInt calcVacant(Board board) {
    return ~(board.player | board.opponent);
  }

  /// 空きマスの数をカウントする
  int calcVacantCount(Board board) {
    return calcPopulationCount(calcVacant(board));
  }

  /// playerが[m]に着手した時に反転する数を求める(着手した石もカウントに含まれる)
  /// [m]着手位置にのみビットが立っている盤面
  /// [board]盤面
  int calcSwapCount(BigInt m, Board board) {
    final result = move(m, board);

    return calcPopulationCount(result.player ^ board.player) +
        calcPopulationCount(result.opponent ^ board.opponent);
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
