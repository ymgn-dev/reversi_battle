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
  BigInt get player => throw _privateConstructorUsedError;
  BigInt get opponent => throw _privateConstructorUsedError;
  BigInt? get latestMove => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BoardCopyWith<Board> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardCopyWith<$Res> {
  factory $BoardCopyWith(Board value, $Res Function(Board) then) =
      _$BoardCopyWithImpl<$Res>;
  $Res call({BigInt player, BigInt opponent, BigInt? latestMove});
}

/// @nodoc
class _$BoardCopyWithImpl<$Res> implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._value, this._then);

  final Board _value;
  // ignore: unused_field
  final $Res Function(Board) _then;

  @override
  $Res call({
    Object? player = freezed,
    Object? opponent = freezed,
    Object? latestMove = freezed,
  }) {
    return _then(_value.copyWith(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as BigInt,
      opponent: opponent == freezed
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as BigInt,
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
  $Res call({BigInt player, BigInt opponent, BigInt? latestMove});
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
    Object? player = freezed,
    Object? opponent = freezed,
    Object? latestMove = freezed,
  }) {
    return _then(_$_Board(
      player: player == freezed
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as BigInt,
      opponent: opponent == freezed
          ? _value.opponent
          : opponent // ignore: cast_nullable_to_non_nullable
              as BigInt,
      latestMove: latestMove == freezed
          ? _value.latestMove
          : latestMove // ignore: cast_nullable_to_non_nullable
              as BigInt?,
    ));
  }
}

/// @nodoc

class _$_Board with DiagnosticableTreeMixin implements _Board {
  const _$_Board(
      {required this.player, required this.opponent, this.latestMove = null});

  @override
  final BigInt player;
  @override
  final BigInt opponent;
  @override
  @JsonKey()
  final BigInt? latestMove;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Board(player: $player, opponent: $opponent, latestMove: $latestMove)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Board'))
      ..add(DiagnosticsProperty('player', player))
      ..add(DiagnosticsProperty('opponent', opponent))
      ..add(DiagnosticsProperty('latestMove', latestMove));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Board &&
            const DeepCollectionEquality().equals(other.player, player) &&
            const DeepCollectionEquality().equals(other.opponent, opponent) &&
            const DeepCollectionEquality()
                .equals(other.latestMove, latestMove));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(player),
      const DeepCollectionEquality().hash(opponent),
      const DeepCollectionEquality().hash(latestMove));

  @JsonKey(ignore: true)
  @override
  _$$_BoardCopyWith<_$_Board> get copyWith =>
      __$$_BoardCopyWithImpl<_$_Board>(this, _$identity);
}

abstract class _Board implements Board {
  const factory _Board(
      {required final BigInt player,
      required final BigInt opponent,
      final BigInt? latestMove}) = _$_Board;

  @override
  BigInt get player;
  @override
  BigInt get opponent;
  @override
  BigInt? get latestMove;
  @override
  @JsonKey(ignore: true)
  _$$_BoardCopyWith<_$_Board> get copyWith =>
      throw _privateConstructorUsedError;
}
