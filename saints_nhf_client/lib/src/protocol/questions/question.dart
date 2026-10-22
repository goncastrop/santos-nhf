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
import '../questions/question_kind.dart' as _isgn4499;

/// A multiple-choice question about a saint. Only admins see [correctIndex].
abstract class Question
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Question._({
    this.id,
    required this.saintId,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    _isgn4499.QuestionKind? kind,
    this.optionSaintIds,
    DateTime? createdAt,
  }) : kind = kind ?? _isgn4499.QuestionKind.manual,
       createdAt = createdAt ?? DateTime.now();

  factory Question({
    int? id,
    required int saintId,
    required String prompt,
    required List<String> options,
    required int correctIndex,
    _isgn4499.QuestionKind? kind,
    List<int>? optionSaintIds,
    DateTime? createdAt,
  }) = _QuestionImpl;

  factory Question.fromJson(Map<String, dynamic> jsonSerialization) {
    return Question(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      prompt: jsonSerialization['prompt'] as String,
      options: _ipd1p8hh.Protocol().deserialize<List<String>>(
        jsonSerialization['options'],
      ),
      correctIndex: jsonSerialization['correctIndex'] as int,
      kind: jsonSerialization['kind'] == null
          ? null
          : _isgn4499.QuestionKind.fromJson(
              (jsonSerialization['kind'] as String),
            ),
      optionSaintIds: jsonSerialization['optionSaintIds'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<int>>(
              jsonSerialization['optionSaintIds'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int saintId;

  String prompt;

  /// Exactly four options.
  List<String> options;

  int correctIndex;

  _isgn4499.QuestionKind kind;

  /// For the generated ones, the saint behind each option, in the order of
  /// [options]. Null for the ones an admin typed.
  List<int>? optionSaintIds;

  DateTime createdAt;

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Question copyWith({
    int? id,
    int? saintId,
    String? prompt,
    List<String>? options,
    int? correctIndex,
    _isgn4499.QuestionKind? kind,
    List<int>? optionSaintIds,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'saintId': saintId,
      'prompt': prompt,
      'options': options.toJson(),
      'correctIndex': correctIndex,
      'kind': kind.toJson(),
      if (optionSaintIds != null) 'optionSaintIds': optionSaintIds?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Question',
      if (id != null) 'id': id,
      'saintId': saintId,
      'prompt': prompt,
      'options': options.toJson(),
      'correctIndex': correctIndex,
      'kind': kind.toJson(),
      if (optionSaintIds != null) 'optionSaintIds': optionSaintIds?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionImpl extends Question {
  _QuestionImpl({
    int? id,
    required int saintId,
    required String prompt,
    required List<String> options,
    required int correctIndex,
    _isgn4499.QuestionKind? kind,
    List<int>? optionSaintIds,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintId: saintId,
         prompt: prompt,
         options: options,
         correctIndex: correctIndex,
         kind: kind,
         optionSaintIds: optionSaintIds,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Question]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Question copyWith({
    Object? id = _Undefined,
    int? saintId,
    String? prompt,
    List<String>? options,
    int? correctIndex,
    _isgn4499.QuestionKind? kind,
    Object? optionSaintIds = _Undefined,
    DateTime? createdAt,
  }) {
    return Question(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options.map((e0) => e0).toList(),
      correctIndex: correctIndex ?? this.correctIndex,
      kind: kind ?? this.kind,
      optionSaintIds: optionSaintIds is List<int>?
          ? optionSaintIds
          : this.optionSaintIds?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
