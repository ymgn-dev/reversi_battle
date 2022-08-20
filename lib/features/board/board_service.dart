import 'package:reversi_battle/features/board/board_constants.dart';
import 'package:reversi_battle/models/board.dart';
import 'package:reversi_battle/models/turn.dart';

class BoardService {
  /// [board]のplayer側の着手可否を判定する。
  ///
  /// 着手箇所にのみビットが立っている盤面を[move]に渡してください。
  bool canMove(BigInt move, Board board) {
    final moves = getMoves(board);
    return (move & moves) == move;
  }

  /// [board]のplayer側の着手をおこなう。
  ///
  /// 着手箇所にのみビットが立っている盤面を[move]に渡してください。
  Board doMove(BigInt move, Board board) {
    var rev = BigInt.zero;

    for (var dir = 0; dir < 8; dir++) {
      var rev_ = BigInt.zero;
      var mask = _flip(move, dir);

      while (mask != BigInt.zero && (mask & board.opponent) != BigInt.zero) {
        rev_ |= mask;
        mask = _flip(mask, dir);
      }

      if (mask & board.player != BigInt.zero) {
        rev |= rev_;
      }
    }

    return Board(
      player: board.player ^ (move | rev),
      opponent: board.opponent ^ rev,
      latestMove: move,
    );
  }

  /// ターンを入れ替える
  Turn swapTurn(Turn turn) {
    return turn == Turn.black ? Turn.white : Turn.black;
  }

  /// [board]のplayer側がパスかどうかを判定する。
  bool isPass(Board board) {
    return calcDiscCount(getMoves(board)) == 0;
  }

  /// [board]が終局しているかどうかを判定する。
  bool isGameOver(Board board) {
    return isPass(board) && isPass(swapPlayerAndOpponent(board));
  }

  /// [board]のplayerとopponentを入れ替える。
  Board swapPlayerAndOpponent(Board board) {
    return board.copyWith(player: board.opponent, opponent: board.player);
  }

  /// [board]のplayer側が着手できる箇所にビットが立っている盤面を返す。
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

  /// 置かれているディスクの数をカウントする。
  int calcDiscCount(BigInt discs) {
    discs -= ((discs >> 1) & m1);
    discs = (discs & m2) + ((discs >> 2) & m2);
    discs = (discs + (discs >> 4)) & m4;
    discs += (discs >> 8);
    discs += (discs >> 16);
    discs += (discs >> 32);
    return (discs & BigInt.from(0x7f)).toInt();
  }

  /// 空いている箇所のみにビットが立っている盤面を返す。
  BigInt calcVacant(Board board) {
    return ~(board.player | board.opponent);
  }

  /// 空いている箇所の数をカウントする。
  int calcVacantCount(Board board) {
    return calcDiscCount(calcVacant(board));
  }

  /// [board]のplayer側が[move]に着手した時に反転するディスクの数をカウントする。
  ///
  /// 着手箇所にのみビットが立っている盤面を[move]に渡してください。
  int calcSwapCount(BigInt move, Board board) {
    final moved = doMove(move, board);

    return calcDiscCount(moved.player ^ board.player) +
        calcDiscCount(moved.opponent ^ board.opponent);
  }

  /// [move]に着手した時に反転するディスクを返す。
  ///
  /// [dir]には方向(0-7の8方向)を渡してください。
  BigInt _flip(BigInt move, int dir) {
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
