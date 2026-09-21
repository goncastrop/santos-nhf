/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import '../saints/score_category.dart' as _ihft2aor;

/// A score change in one category. Values are only sent when the caller owns
/// the card; otherwise only the direction is revealed.
abstract class ScoreChange
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ScoreChange._({
    required this.category,
    required this.increased,
    this.from,
    this.to,
  });

  factory ScoreChange({
    required _ihft2aor.ScoreCategory category,
    required bool increased,
    int? from,
    int? to,
  }) = _ScoreChangeImpl;

  factory ScoreChange.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScoreChange(
      category: _ihft2aor.ScoreCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      increased: _is.BoolJsonExtension.fromJson(jsonSerialization['increased']),
      from: jsonSerialization['from'] as int?,
      to: jsonSerialization['to'] as int?,
    );
  }

  _ihft2aor.ScoreCategory category;

  bool increased;

  int? from;

  int? to;

  /// Returns a shallow copy of this [ScoreChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScoreChange copyWith({
    _ihft2aor.ScoreCategory? category,
    bool? increased,
    int? from,
    int? to,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScoreChange',
      'category': category.toJson(),
      'increased': increased,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScoreChange',
      'category': category.toJson(),
      'increased': increased,
      if (from != null) 'from': from,
      if (to != null) 'to': to,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScoreChangeImpl extends ScoreChange {
  _ScoreChangeImpl({
    required _ihft2aor.ScoreCategory category,
    required bool increased,
    int? from,
    int? to,
  }) : super._(
         category: category,
         increased: increased,
         from: from,
         to: to,
       );

  /// Returns a shallow copy of this [ScoreChange]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScoreChange copyWith({
    _ihft2aor.ScoreCategory? category,
    bool? increased,
    Object? from = _Undefined,
    Object? to = _Undefined,
  }) {
    return ScoreChange(
      category: category ?? this.category,
      increased: increased ?? this.increased,
      from: from is int? ? from : this.from,
      to: to is int? ? to : this.to,
    );
  }
}
