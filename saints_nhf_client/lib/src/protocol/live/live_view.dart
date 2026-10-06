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
import '../live/live_me.dart' as _i6hyqf28;
import '../live/live_phase.dart' as _i5luu9zi;
import '../live/live_rank_entry.dart' as _ishd6eiu;
import '../live/live_winner_view.dart' as _iqf03ea9;
import '../questions/quiz_question.dart' as _i2z4qq3v;
import '../saints/saint_info.dart' as _i38p9z6b;

/// The live game as one viewer sees it. The streams send a whole view on
/// every change instead of diffs, so a reconnect is just one more message.
abstract class LiveView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LiveView._({
    required this.phase,
    required this.serverTime,
    this.gameId,
    this.saint,
    this.questionNumber,
    this.questionCount,
    this.countdownTo,
    this.question,
    this.closesAt,
    this.answeredCount,
    this.correctIndex,
    this.tally,
    this.leaderboard,
    this.fastWinners,
    this.raffleWinners,
    required this.watching,
    this.me,
  });

  factory LiveView({
    required _i5luu9zi.LivePhase phase,
    required DateTime serverTime,
    int? gameId,
    _i38p9z6b.SaintInfo? saint,
    int? questionNumber,
    int? questionCount,
    DateTime? countdownTo,
    _i2z4qq3v.QuizQuestion? question,
    DateTime? closesAt,
    int? answeredCount,
    int? correctIndex,
    List<int>? tally,
    List<_ishd6eiu.LiveRankEntry>? leaderboard,
    List<_iqf03ea9.LiveWinnerView>? fastWinners,
    List<_iqf03ea9.LiveWinnerView>? raffleWinners,
    required int watching,
    _i6hyqf28.LiveMe? me,
  }) = _LiveViewImpl;

  factory LiveView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LiveView(
      phase: _i5luu9zi.LivePhase.fromJson(
        (jsonSerialization['phase'] as String),
      ),
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      gameId: jsonSerialization['gameId'] as int?,
      saint: jsonSerialization['saint'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
              jsonSerialization['saint'],
            ),
      questionNumber: jsonSerialization['questionNumber'] as int?,
      questionCount: jsonSerialization['questionCount'] as int?,
      countdownTo: jsonSerialization['countdownTo'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['countdownTo'],
            ),
      question: jsonSerialization['question'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i2z4qq3v.QuizQuestion>(
              jsonSerialization['question'],
            ),
      closesAt: jsonSerialization['closesAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['closesAt']),
      answeredCount: jsonSerialization['answeredCount'] as int?,
      correctIndex: jsonSerialization['correctIndex'] as int?,
      tally: jsonSerialization['tally'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<int>>(
              jsonSerialization['tally'],
            ),
      leaderboard: jsonSerialization['leaderboard'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<_ishd6eiu.LiveRankEntry>>(
              jsonSerialization['leaderboard'],
            ),
      fastWinners: jsonSerialization['fastWinners'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<_iqf03ea9.LiveWinnerView>>(
              jsonSerialization['fastWinners'],
            ),
      raffleWinners: jsonSerialization['raffleWinners'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<List<_iqf03ea9.LiveWinnerView>>(
              jsonSerialization['raffleWinners'],
            ),
      watching: jsonSerialization['watching'] as int,
      me: jsonSerialization['me'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_i6hyqf28.LiveMe>(
              jsonSerialization['me'],
            ),
    );
  }

  _i5luu9zi.LivePhase phase;

  /// The server's clock when this view was built, so the app can correct
  /// its own before showing countdowns.
  DateTime serverTime;

  int? gameId;

  _i38p9z6b.SaintInfo? saint;

  /// 1-based number of the current question, and how many there are.
  int? questionNumber;

  int? questionCount;

  DateTime? countdownTo;

  /// Present from the moment the question opens. The options come in the
  /// same order for everyone, so the host can say "the B".
  _i2z4qq3v.QuizQuestion? question;

  DateTime? closesAt;

  /// How many answered the current question so far.
  int? answeredCount;

  /// In the reveal: the right option and how many picked each one, both in
  /// the order shown.
  int? correctIndex;

  List<int>? tally;

  /// Top of the ranking, in the reveal and at the end.
  List<_ishd6eiu.LiveRankEntry>? leaderboard;

  /// At the end.
  List<_iqf03ea9.LiveWinnerView>? fastWinners;

  List<_iqf03ea9.LiveWinnerView>? raffleWinners;

  /// People with the app open right now.
  int watching;

  /// Null for viewers without an account.
  _i6hyqf28.LiveMe? me;

  /// Returns a shallow copy of this [LiveView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LiveView copyWith({
    _i5luu9zi.LivePhase? phase,
    DateTime? serverTime,
    int? gameId,
    _i38p9z6b.SaintInfo? saint,
    int? questionNumber,
    int? questionCount,
    DateTime? countdownTo,
    _i2z4qq3v.QuizQuestion? question,
    DateTime? closesAt,
    int? answeredCount,
    int? correctIndex,
    List<int>? tally,
    List<_ishd6eiu.LiveRankEntry>? leaderboard,
    List<_iqf03ea9.LiveWinnerView>? fastWinners,
    List<_iqf03ea9.LiveWinnerView>? raffleWinners,
    int? watching,
    _i6hyqf28.LiveMe? me,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LiveView',
      'phase': phase.toJson(),
      'serverTime': serverTime.toJson(),
      if (gameId != null) 'gameId': gameId,
      if (saint != null) 'saint': saint?.toJson(),
      if (questionNumber != null) 'questionNumber': questionNumber,
      if (questionCount != null) 'questionCount': questionCount,
      if (countdownTo != null) 'countdownTo': countdownTo?.toJson(),
      if (question != null) 'question': question?.toJson(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      if (answeredCount != null) 'answeredCount': answeredCount,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (tally != null) 'tally': tally?.toJson(),
      if (leaderboard != null)
        'leaderboard': leaderboard?.toJson(valueToJson: (v) => v.toJson()),
      if (fastWinners != null)
        'fastWinners': fastWinners?.toJson(valueToJson: (v) => v.toJson()),
      if (raffleWinners != null)
        'raffleWinners': raffleWinners?.toJson(valueToJson: (v) => v.toJson()),
      'watching': watching,
      if (me != null) 'me': me?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LiveView',
      'phase': phase.toJson(),
      'serverTime': serverTime.toJson(),
      if (gameId != null) 'gameId': gameId,
      if (saint != null) 'saint': saint?.toJsonForProtocol(),
      if (questionNumber != null) 'questionNumber': questionNumber,
      if (questionCount != null) 'questionCount': questionCount,
      if (countdownTo != null) 'countdownTo': countdownTo?.toJson(),
      if (question != null) 'question': question?.toJsonForProtocol(),
      if (closesAt != null) 'closesAt': closesAt?.toJson(),
      if (answeredCount != null) 'answeredCount': answeredCount,
      if (correctIndex != null) 'correctIndex': correctIndex,
      if (tally != null) 'tally': tally?.toJson(),
      if (leaderboard != null)
        'leaderboard': leaderboard?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (fastWinners != null)
        'fastWinners': fastWinners?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (raffleWinners != null)
        'raffleWinners': raffleWinners?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'watching': watching,
      if (me != null) 'me': me?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LiveViewImpl extends LiveView {
  _LiveViewImpl({
    required _i5luu9zi.LivePhase phase,
    required DateTime serverTime,
    int? gameId,
    _i38p9z6b.SaintInfo? saint,
    int? questionNumber,
    int? questionCount,
    DateTime? countdownTo,
    _i2z4qq3v.QuizQuestion? question,
    DateTime? closesAt,
    int? answeredCount,
    int? correctIndex,
    List<int>? tally,
    List<_ishd6eiu.LiveRankEntry>? leaderboard,
    List<_iqf03ea9.LiveWinnerView>? fastWinners,
    List<_iqf03ea9.LiveWinnerView>? raffleWinners,
    required int watching,
    _i6hyqf28.LiveMe? me,
  }) : super._(
         phase: phase,
         serverTime: serverTime,
         gameId: gameId,
         saint: saint,
         questionNumber: questionNumber,
         questionCount: questionCount,
         countdownTo: countdownTo,
         question: question,
         closesAt: closesAt,
         answeredCount: answeredCount,
         correctIndex: correctIndex,
         tally: tally,
         leaderboard: leaderboard,
         fastWinners: fastWinners,
         raffleWinners: raffleWinners,
         watching: watching,
         me: me,
       );

  /// Returns a shallow copy of this [LiveView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LiveView copyWith({
    _i5luu9zi.LivePhase? phase,
    DateTime? serverTime,
    Object? gameId = _Undefined,
    Object? saint = _Undefined,
    Object? questionNumber = _Undefined,
    Object? questionCount = _Undefined,
    Object? countdownTo = _Undefined,
    Object? question = _Undefined,
    Object? closesAt = _Undefined,
    Object? answeredCount = _Undefined,
    Object? correctIndex = _Undefined,
    Object? tally = _Undefined,
    Object? leaderboard = _Undefined,
    Object? fastWinners = _Undefined,
    Object? raffleWinners = _Undefined,
    int? watching,
    Object? me = _Undefined,
  }) {
    return LiveView(
      phase: phase ?? this.phase,
      serverTime: serverTime ?? this.serverTime,
      gameId: gameId is int? ? gameId : this.gameId,
      saint: saint is _i38p9z6b.SaintInfo? ? saint : this.saint?.copyWith(),
      questionNumber: questionNumber is int?
          ? questionNumber
          : this.questionNumber,
      questionCount: questionCount is int? ? questionCount : this.questionCount,
      countdownTo: countdownTo is DateTime? ? countdownTo : this.countdownTo,
      question: question is _i2z4qq3v.QuizQuestion?
          ? question
          : this.question?.copyWith(),
      closesAt: closesAt is DateTime? ? closesAt : this.closesAt,
      answeredCount: answeredCount is int? ? answeredCount : this.answeredCount,
      correctIndex: correctIndex is int? ? correctIndex : this.correctIndex,
      tally: tally is List<int>? ? tally : this.tally?.map((e0) => e0).toList(),
      leaderboard: leaderboard is List<_ishd6eiu.LiveRankEntry>?
          ? leaderboard
          : this.leaderboard?.map((e0) => e0.copyWith()).toList(),
      fastWinners: fastWinners is List<_iqf03ea9.LiveWinnerView>?
          ? fastWinners
          : this.fastWinners?.map((e0) => e0.copyWith()).toList(),
      raffleWinners: raffleWinners is List<_iqf03ea9.LiveWinnerView>?
          ? raffleWinners
          : this.raffleWinners?.map((e0) => e0.copyWith()).toList(),
      watching: watching ?? this.watching,
      me: me is _i6hyqf28.LiveMe? ? me : this.me?.copyWith(),
    );
  }
}
