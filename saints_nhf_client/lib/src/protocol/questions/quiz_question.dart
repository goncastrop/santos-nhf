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
import 'package:saints_nhf_client/src/protocol/protocol.dart' as _ipd1p8hh;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// A question as shown to players: no correct answer included.
abstract class QuizQuestion
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuizQuestion._({
    required this.id,
    required this.saintId,
    required this.prompt,
    required this.options,
  });

  factory QuizQuestion({
    required int id,
    required int saintId,
    required String prompt,
    required List<String> options,
  }) = _QuizQuestionImpl;

  factory QuizQuestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuizQuestion(
      id: jsonSerialization['id'] as int,
      saintId: jsonSerialization['saintId'] as int,
      prompt: jsonSerialization['prompt'] as String,
      options: _ipd1p8hh.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
    );
  }

  int id;

  int saintId;

  String prompt;

  List<String> options;

  /// Returns a shallow copy of this [QuizQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuizQuestion copyWith({
    int? id,
    int? saintId,
    String? prompt,
    List<String>? options,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuizQuestion',
      'id': id,
      'saintId': saintId,
      'prompt': prompt,
      'options': options.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuizQuestion',
      'id': id,
      'saintId': saintId,
      'prompt': prompt,
      'options': options.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _QuizQuestionImpl extends QuizQuestion {
  _QuizQuestionImpl({
    required int id,
    required int saintId,
    required String prompt,
    required List<String> options,
  }) : super._(
         id: id,
         saintId: saintId,
         prompt: prompt,
         options: options,
       );

  /// Returns a shallow copy of this [QuizQuestion]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuizQuestion copyWith({
    int? id,
    int? saintId,
    String? prompt,
    List<String>? options,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      saintId: saintId ?? this.saintId,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options.map((e0) => e0).toList(),
    );
  }
}
