// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'traffic_light_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrafficLightState {

 LightColor get currentColor; bool get isPaused; bool get isBlinking;
/// Create a copy of TrafficLightState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrafficLightStateCopyWith<TrafficLightState> get copyWith => _$TrafficLightStateCopyWithImpl<TrafficLightState>(this as TrafficLightState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrafficLightState&&(identical(other.currentColor, currentColor) || other.currentColor == currentColor)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isBlinking, isBlinking) || other.isBlinking == isBlinking));
}


@override
int get hashCode => Object.hash(runtimeType,currentColor,isPaused,isBlinking);

@override
String toString() {
  return 'TrafficLightState(currentColor: $currentColor, isPaused: $isPaused, isBlinking: $isBlinking)';
}


}

/// @nodoc
abstract mixin class $TrafficLightStateCopyWith<$Res>  {
  factory $TrafficLightStateCopyWith(TrafficLightState value, $Res Function(TrafficLightState) _then) = _$TrafficLightStateCopyWithImpl;
@useResult
$Res call({
 LightColor currentColor, bool isPaused, bool isBlinking
});




}
/// @nodoc
class _$TrafficLightStateCopyWithImpl<$Res>
    implements $TrafficLightStateCopyWith<$Res> {
  _$TrafficLightStateCopyWithImpl(this._self, this._then);

  final TrafficLightState _self;
  final $Res Function(TrafficLightState) _then;

/// Create a copy of TrafficLightState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentColor = null,Object? isPaused = null,Object? isBlinking = null,}) {
  return _then(_self.copyWith(
currentColor: null == currentColor ? _self.currentColor : currentColor // ignore: cast_nullable_to_non_nullable
as LightColor,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isBlinking: null == isBlinking ? _self.isBlinking : isBlinking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TrafficLightState].
extension TrafficLightStatePatterns on TrafficLightState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrafficLightState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrafficLightState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrafficLightState value)  $default,){
final _that = this;
switch (_that) {
case _TrafficLightState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrafficLightState value)?  $default,){
final _that = this;
switch (_that) {
case _TrafficLightState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LightColor currentColor,  bool isPaused,  bool isBlinking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrafficLightState() when $default != null:
return $default(_that.currentColor,_that.isPaused,_that.isBlinking);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LightColor currentColor,  bool isPaused,  bool isBlinking)  $default,) {final _that = this;
switch (_that) {
case _TrafficLightState():
return $default(_that.currentColor,_that.isPaused,_that.isBlinking);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LightColor currentColor,  bool isPaused,  bool isBlinking)?  $default,) {final _that = this;
switch (_that) {
case _TrafficLightState() when $default != null:
return $default(_that.currentColor,_that.isPaused,_that.isBlinking);case _:
  return null;

}
}

}

/// @nodoc


class _TrafficLightState implements TrafficLightState {
  const _TrafficLightState({this.currentColor = LightColor.red, this.isPaused = false, this.isBlinking = false});
  

@override@JsonKey() final  LightColor currentColor;
@override@JsonKey() final  bool isPaused;
@override@JsonKey() final  bool isBlinking;

/// Create a copy of TrafficLightState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrafficLightStateCopyWith<_TrafficLightState> get copyWith => __$TrafficLightStateCopyWithImpl<_TrafficLightState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrafficLightState&&(identical(other.currentColor, currentColor) || other.currentColor == currentColor)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isBlinking, isBlinking) || other.isBlinking == isBlinking));
}


@override
int get hashCode => Object.hash(runtimeType,currentColor,isPaused,isBlinking);

@override
String toString() {
  return 'TrafficLightState(currentColor: $currentColor, isPaused: $isPaused, isBlinking: $isBlinking)';
}


}

/// @nodoc
abstract mixin class _$TrafficLightStateCopyWith<$Res> implements $TrafficLightStateCopyWith<$Res> {
  factory _$TrafficLightStateCopyWith(_TrafficLightState value, $Res Function(_TrafficLightState) _then) = __$TrafficLightStateCopyWithImpl;
@override @useResult
$Res call({
 LightColor currentColor, bool isPaused, bool isBlinking
});




}
/// @nodoc
class __$TrafficLightStateCopyWithImpl<$Res>
    implements _$TrafficLightStateCopyWith<$Res> {
  __$TrafficLightStateCopyWithImpl(this._self, this._then);

  final _TrafficLightState _self;
  final $Res Function(_TrafficLightState) _then;

/// Create a copy of TrafficLightState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentColor = null,Object? isPaused = null,Object? isBlinking = null,}) {
  return _then(_TrafficLightState(
currentColor: null == currentColor ? _self.currentColor : currentColor // ignore: cast_nullable_to_non_nullable
as LightColor,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isBlinking: null == isBlinking ? _self.isBlinking : isBlinking // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
