// ignore: unnecessary_import, unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board.freezed.dart';

@freezed
class Board with _$Board {
  const factory Board({
    required BigInt player,
    required BigInt opponent,
  }) = _Board;
}
