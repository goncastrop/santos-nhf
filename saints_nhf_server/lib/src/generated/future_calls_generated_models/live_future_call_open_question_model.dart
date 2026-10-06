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

abstract class LiveFutureCallOpenQuestionModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LiveFutureCallOpenQuestionModel._({
    required this.gameId,
    required this.index,
  });

  factory LiveFutureCallOpenQuestionModel({
    required int gameId,
    required int index,
  }) = _LiveFutureCallOpenQuestionModelImpl;

  factory LiveFutureCallOpenQuestionModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LiveFutureCallOpenQuestionModel(
      gameId: jsonSerialization['gameId'] as int,
      index: jsonSerialization['index'] as int,
    );
  }

  int gameId;

  int index;

  /// Returns a shallow copy of this [LiveFutureCallOpenQuestionModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LiveFutureCallOpenQuestionModel copyWith({
    int? gameId,
    int? index,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveFutureCallOpenQuestionModel',
      'gameId': gameId,
      'index': index,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LiveFutureCallOpenQuestionModelImpl
    extends LiveFutureCallOpenQuestionModel {
  _LiveFutureCallOpenQuestionModelImpl({
    required int gameId,
    required int index,
  }) : super._(
         gameId: gameId,
         index: index,
       );

  /// Returns a shallow copy of this [LiveFutureCallOpenQuestionModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LiveFutureCallOpenQuestionModel copyWith({
    int? gameId,
    int? index,
  }) {
    return LiveFutureCallOpenQuestionModel(
      gameId: gameId ?? this.gameId,
      index: index ?? this.index,
    );
  }
}
