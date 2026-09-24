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
import '../questions/question.dart' as _i5m8psqj;

/// One row per question a player has already been asked, so the same one does
/// not come back while there are unseen ones left. [seenAt] is refreshed every
/// time it comes up, so once the pool runs out the oldest are reused first.
///
/// Only real players are recorded: the machine opponent picks its questions
/// without looking here.
abstract class QuestionSeen
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuestionSeen._({
    this.id,
    required this.authUserId,
    required this.questionId,
    this.question,
    DateTime? seenAt,
  }) : seenAt = seenAt ?? DateTime.now();

  factory QuestionSeen({
    int? id,
    required _isc.UuidValue authUserId,
    required int questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  }) = _QuestionSeenImpl;

  factory QuestionSeen.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuestionSeen(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      questionId: jsonSerialization['questionId'] as int,
      question: jsonSerialization['question'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i5m8psqj.Question>(
              jsonSerialization['question'],
            ),
      seenAt: jsonSerialization['seenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['seenAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  int questionId;

  _i5m8psqj.Question? question;

  DateTime seenAt;

  /// Returns a shallow copy of this [QuestionSeen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuestionSeen copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuestionSeen',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      if (question != null) 'question': question?.toJson(),
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuestionSeen',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      if (question != null) 'question': question?.toJsonForProtocol(),
      'seenAt': seenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuestionSeenImpl extends QuestionSeen {
  _QuestionSeenImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int questionId,
    _i5m8psqj.Question? question,
    DateTime? seenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         questionId: questionId,
         question: question,
         seenAt: seenAt,
       );

  /// Returns a shallow copy of this [QuestionSeen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuestionSeen copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? questionId,
    Object? question = _Undefined,
    DateTime? seenAt,
  }) {
    return QuestionSeen(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      questionId: questionId ?? this.questionId,
      question: question is _i5m8psqj.Question?
          ? question
          : this.question?.copyWith(),
      seenAt: seenAt ?? this.seenAt,
    );
  }
}
