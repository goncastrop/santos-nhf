import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../client.dart';
import 'local_cache.dart';

/// The live trivia as the server streams it.
///
/// The app listens while it is in the foreground, with or without an
/// account: that is how the banner shows up on any tab when the host
/// announces a game. It lives apart from [AppState] so the countdowns and
/// the tally, which change every second, do not rebuild the whole app.
class LiveState extends ChangeNotifier {
  LiveView? view;

  /// The server's clock minus the device's, from the last view. Countdowns
  /// use it so a phone with its clock off still closes on time.
  Duration _offset = Duration.zero;

  /// The option the player picked in the open question, shown at once while
  /// the next view, which already knows it, is on its way.
  ({int gameId, int question, int index})? _picked;

  /// Game whose banner the player closed.
  int? dismissedGameId;

  StreamSubscription<LiveView>? _subscription;
  Timer? _retry;
  int _failures = 0;
  bool _running = false;

  static LiveState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LiveStateScope>();
    assert(scope != null, 'LiveStateScope missing above this widget');
    return scope!.notifier!;
  }

  DateTime get serverNow => DateTime.now().toUtc().add(_offset);

  /// How long the podium stays on the banner, counted from the moment the
  /// game ended on the server, so it goes away for everyone at once. The
  /// server stops sending it after the same time.
  static const resultsShownFor = Duration(minutes: 10);

  Timer? _finishedTimer;

  bool get _resultsExpired {
    final end = view?.finishedAt;
    return end != null && !serverNow.isBefore(end.add(resultsShownFor));
  }

  /// Whether a game is on, from the lobby to the podium.
  bool get isOn => switch (view?.phase) {
    LivePhase.countdown || LivePhase.question || LivePhase.reveal => true,
    LivePhase.finished => !_resultsExpired,
    _ => false,
  };

  /// Whether a game is being played: lobby, questions and reveals.
  bool get isPlaying => switch (view?.phase) {
    LivePhase.countdown || LivePhase.question || LivePhase.reveal => true,
    _ => false,
  };

  bool get bannerDismissed => view?.gameId == dismissedGameId;

  final _cache = LocalCache();

  /// Hides the banner of this game, also after a reload.
  void dismissBanner() {
    dismissedGameId = view?.gameId;
    unawaited(_cache.markLiveGameDismissed(dismissedGameId));
    notifyListeners();
  }

  void showBanner() {
    dismissedGameId = null;
    unawaited(_cache.markLiveGameDismissed(null));
    notifyListeners();
  }

  /// The option the player picked in the open question, in the order shown.
  int? get myChoice {
    final v = view;
    if (v == null) return null;
    final fromServer = v.me?.chosenIndex;
    if (fromServer != null) return fromServer;
    final picked = _picked;
    if (picked != null &&
        picked.gameId == v.gameId &&
        picked.question == v.questionNumber) {
      return picked.index;
    }
    return null;
  }

  /// Starts listening. Safe to call more than once.
  void start() {
    if (_running) return;
    _running = true;
    if (!_dismissedLoaded) {
      _dismissedLoaded = true;
      _cache.dismissedLiveGame().then((id) {
        // A choice made while this was loading wins.
        dismissedGameId ??= id;
        notifyListeners();
      });
    }
    _listen();
  }

  bool _dismissedLoaded = false;

  /// Stops listening, when the app goes to the background.
  void stop() {
    _running = false;
    _retry?.cancel();
    _retry = null;
    unawaited(_subscription?.cancel());
    _subscription = null;
  }

  /// Opens the stream again, so the server knows who is watching after the
  /// player signs in or out.
  void restart() {
    stop();
    view = view?.copyWith(me: null);
    _picked = null;
    start();
  }

  void _listen() {
    unawaited(_subscription?.cancel());
    _subscription = client.live.watch().listen(
      (v) {
        _failures = 0;
        _offset = v.serverTime.difference(DateTime.now().toUtc());
        view = v;
        _trackFinish(v);
        notifyListeners();
      },
      onError: (_) => _reconnect(),
      onDone: _reconnect,
      cancelOnError: true,
    );
  }

  /// Rebuilds the banner when the results expire, since no view arrives then.
  void _trackFinish(LiveView v) {
    _finishedTimer?.cancel();
    final end = v.finishedAt;
    if (v.phase != LivePhase.finished || end == null) return;
    final left = end.add(resultsShownFor).difference(serverNow);
    if (left > Duration.zero) _finishedTimer = Timer(left, notifyListeners);
  }

  /// Tries again after a pause that grows with each failure, up to half a
  /// minute, so a server that is down is not hammered.
  void _reconnect() {
    _subscription = null;
    if (!_running) return;
    _failures++;
    final seconds = min(30, pow(2, min(_failures, 5)).toInt());
    _retry?.cancel();
    _retry = Timer(Duration(seconds: seconds), () {
      if (_running) _listen();
    });
  }

  /// Answers the open question with the option at [index], in the order
  /// shown.
  Future<void> answer(int index) async {
    final v = view;
    if (v == null || v.gameId == null || v.questionNumber == null) return;
    final picked = (
      gameId: v.gameId!,
      question: v.questionNumber!,
      index: index,
    );
    _picked = picked;
    notifyListeners();
    try {
      final me = await client.live.answer(
        v.gameId!,
        v.questionNumber! - 1,
        index,
      );
      if (view?.gameId == v.gameId &&
          view?.questionNumber == v.questionNumber) {
        view = view!.copyWith(me: me);
        notifyListeners();
      }
    } catch (_) {
      if (_picked == picked) _picked = null;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _finishedTimer?.cancel();
    stop();
    super.dispose();
  }
}

class LiveStateScope extends InheritedNotifier<LiveState> {
  const LiveStateScope({
    super.key,
    required LiveState state,
    required super.child,
  }) : super(notifier: state);
}
