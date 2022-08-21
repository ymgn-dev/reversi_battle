// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Board {
  BigInt get black => throw _privateConstructorUsedError;
  BigInt get white => throw _privateConstructorUsedError;
  dynamic get playerTurn => throw _privateConstructorUsedError;
  dynamic get currentTurn => throw _privateConstructorUsedError;
  BigInt? get latestMove => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardCopyWith<Board> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardCopyWith<$Res> {
  factory $BoardCopyWith(Board value, $Res Function(Board) then) =
      _$BoardCopyWithImpl<$Res>;
  $Res call(
      {BigInt black,
      BigInt white,
      dynamic playerTurn,
      dynamic currentTurn,
      BigInt? latestMove});
}

/// @nodoc
class _$BoardCopyWithImpl<$Res> implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._value, this._then);

  final Board _value;
  // ignore: unused_field
  final $Res Function(Board) _then;

  @override
  $Res call({
    Object? black = freezed,
    Object? white = freezed,
    Object? playerTurn = freezed,
    Object? currentTurn = freezed,
    Object? latestMove = freezed,
  }) {
    return _then(_value.copyWith(
      black: black == freezed
          ? _value.black
          : black // ignore: cast_nullable_to_non_nullable
              as BigInt,
      white: white == freezed
          ? _value.white
          : white // ignore: cast_nullable_to_non_nullable
              as BigInt,
      playerTurn: playerTurn == freezed
          ? _value.playerTurn
          : playerTurn // ignore: cast_nullable_to_non_nullable
              as dynamic,
      currentTurn: currentTurn == freezed
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as dynamic,
      latestMove: latestMove == freezed
          ? _value.latestMove
          : latestMove // ignore: cast_nullable_to_non_nullable
              as BigInt?,
    ));
  }
}

/// @nodoc
abstract class _$$_BoardCopyWith<$Res> implements $BoardCopyWith<$Res> {
  factory _$$_BoardCopyWith(_$_Board value, $Res Function(_$_Board) then) =
      __$$_BoardCopyWithImpl<$Res>;
  @override
  $Res call(
      {BigInt black,
      BigInt white,
      dynamic playerTurn,
      dynamic currentTurn,
      BigInt? latestMove});
}

/// @nodoc
class __$$_BoardCopyWithImpl<$Res> extends _$BoardCopyWithImpl<$Res>
    implements _$$_BoardCopyWith<$Res> {
  __$$_BoardCopyWithImpl(_$_Board _value, $Res Function(_$_Board) _then)
      : super(_value, (v) => _then(v as _$_Board));

  @override
  _$_Board get _value => super._value as _$_Board;

  @override
  $Res call({
    Object? black = freezed,
    Object? white = freezed,
    Object? playerTurn = freezed,
    Object? currentTurn = freezed,
    Object? latestMove = freezed,
  }) {
    return _then(_$_Board(
      black: black == freezed
          ? _value.black
          : black // ignore: cast_nullable_to_non_nullable
              as BigInt,
      white: white == freezed
          ? _value.white
          : white // ignore: cast_nullable_to_non_nullable
              as BigInt,
      playerTurn: playerTurn == freezed ? _value.playerTurn : playerTurn,
      currentTurn: currentTurn == freezed ? _value.currentTurn : currentTurn,
      latestMove: latestMove == freezed
          ? _value.latestMove
          : latestMove // ignore: cast_nullable_to_non_nullable
              as BigInt?,
    ));
  }
}

/// @nodoc

class _$_Board extends _Board with DiagnosticableTreeMixin {
  const _$_Board(
      {required this.black,
      required this.white,
      this.playerTurn = Turn.black,
      this.currentTurn = Turn.black,
      this.latestMove = null})
      : super._();

  @override
  final BigInt black;
  @override
  final BigInt white;
  @override
  @JsonKey()
  final dynamic playerTurn;
  @override
  @JsonKey()
  final dynamic currentTurn;
  @override
  @JsonKey()
  final BigInt? latestMove;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Board(black: $black, white: $white, playerTurn: $playerTurn, currentTurn: $currentTurn, latestMove: $latestMove)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Board'))
      ..add(DiagnosticsProperty('black', black))
      ..add(DiagnosticsProperty('white', white))
      ..add(DiagnosticsProperty('playerTurn', playerTurn))
      ..add(DiagnosticsProperty('currentTurn', currentTurn))
      ..add(DiagnosticsProperty('latestMove', latestMove));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Board &&
            const DeepCollectionEquality().equals(other.black, black) &&
            const DeepCollectionEquality().equals(other.white, white) &&
            const DeepCollectionEquality()
                .equals(other.playerTurn, playerTurn) &&
            const DeepCollectionEquality()
                .equals(other.currentTurn, currentTurn) &&
            const DeepCollectionEquality()
                .equals(other.latestMove, latestMove));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(black),
      const DeepCollectionEquality().hash(white),
      const DeepCollectionEquality().hash(playerTurn),
      const DeepCollectionEquality().hash(currentTurn),
      const DeepCollectionEquality().hash(latestMove));

  @JsonKey(ignore: true)
  @override
  _$$_BoardCopyWith<_$_Board> get copyWith =>
      __$$_BoardCopyWithImpl<_$_Board>(this, _$identity);
}

abstract class _Board extends Board {
  const factory _Board(
      {required final BigInt black,
      required final BigInt white,
      final dynamic playerTurn,
      final dynamic currentTurn,
      final BigInt? latestMove}) = _$_Board;
  const _Board._() : super._();

  @override
  BigInt get black;
  @override
  BigInt get white;
  @override
  dynamic get playerTurn;
  @override
  dynamic get currentTurn;
  @override
  BigInt? get latestMove;
  @override
  @JsonKey(ignore: true)
  _$$_BoardCopyWith<_$_Board> get copyWith =>
      throw _privateConstructorUsedError;
}
