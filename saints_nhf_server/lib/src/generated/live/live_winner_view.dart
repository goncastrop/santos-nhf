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

/// A prize winner as players see it.
abstract class LiveWinnerView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveWinnerView._({
    required this.name,
    required this.points,
    this.saintName,
    required this.isMe,
  });

  factory LiveWinnerView({
    required String name,
    required int points,
    String? saintName,
    required bool isMe,
  }) = _LiveWinnerViewImpl;

  factory LiveWinnerView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveWinnerView(
      name: jsonSerialization['name'] as String,
      points: jsonSerialization['points'] as int,
      saintName: jsonSerialization['saintName'] as String?,
      isMe: _is.BoolJsonExtension.fromJson(jsonSerialization['isMe']),
    );
  }

  String name;

  int points;

  /// The card they got, or null when they already had the whole album.
  String? saintName;

  bool isMe;

  /// Returns a shallow copy of this [LiveWinnerView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveWinnerView copyWith({
    String? name,
    int? points,
    String? saintName,
    bool? isMe,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveWinnerView',
      'name': name,
      'points': points,
      if (saintName != null) 'saintName': saintName,
      'isMe': isMe,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveWinnerView',
      'name': name,
      'points': points,
      if (saintName != null) 'saintName': saintName,
      'isMe': isMe,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveWinnerViewImpl extends LiveWinnerView {
  _LiveWinnerViewImpl({
    required String name,
    required int points,
    String? saintName,
    required bool isMe,
  }) : super._(
         name: name,
         points: points,
         saintName: saintName,
         isMe: isMe,
       );

  /// Returns a shallow copy of this [LiveWinnerView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveWinnerView copyWith({
    String? name,
    int? points,
    Object? saintName = _Undefined,
    bool? isMe,
  }) {
    return LiveWinnerView(
      name: name ?? this.name,
      points: points ?? this.points,
      saintName: saintName is String? ? saintName : this.saintName,
      isMe: isMe ?? this.isMe,
    );
  }
}
