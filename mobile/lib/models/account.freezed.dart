// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AccountTearOff {
  const _$AccountTearOff();

  _Account call({required AccountType accountType, required String publicKey}) {
    return _Account(
      accountType: accountType,
      publicKey: publicKey,
    );
  }
}

/// @nodoc
const $Account = _$AccountTearOff();

/// @nodoc
mixin _$Account {
  AccountType get accountType => throw _privateConstructorUsedError;
  String get publicKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res>;
  $Res call({AccountType accountType, String publicKey});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res> implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  final Account _value;
  // ignore: unused_field
  final $Res Function(Account) _then;

  @override
  $Res call({
    Object? accountType = freezed,
    Object? publicKey = freezed,
  }) {
    return _then(_value.copyWith(
      accountType: accountType == freezed
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) then) =
      __$AccountCopyWithImpl<$Res>;
  @override
  $Res call({AccountType accountType, String publicKey});
}

/// @nodoc
class __$AccountCopyWithImpl<$Res> extends _$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(_Account _value, $Res Function(_Account) _then)
      : super(_value, (v) => _then(v as _Account));

  @override
  _Account get _value => super._value as _Account;

  @override
  $Res call({
    Object? accountType = freezed,
    Object? publicKey = freezed,
  }) {
    return _then(_Account(
      accountType: accountType == freezed
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Account implements _Account {
  const _$_Account({required this.accountType, required this.publicKey});

  @override
  final AccountType accountType;
  @override
  final String publicKey;

  @override
  String toString() {
    return 'Account(accountType: $accountType, publicKey: $publicKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Account &&
            const DeepCollectionEquality()
                .equals(other.accountType, accountType) &&
            const DeepCollectionEquality().equals(other.publicKey, publicKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(accountType),
      const DeepCollectionEquality().hash(publicKey));

  @JsonKey(ignore: true)
  @override
  _$AccountCopyWith<_Account> get copyWith =>
      __$AccountCopyWithImpl<_Account>(this, _$identity);
}

abstract class _Account implements Account {
  const factory _Account(
      {required AccountType accountType,
      required String publicKey}) = _$_Account;

  @override
  AccountType get accountType;
  @override
  String get publicKey;
  @override
  @JsonKey(ignore: true)
  _$AccountCopyWith<_Account> get copyWith =>
      throw _privateConstructorUsedError;
}
