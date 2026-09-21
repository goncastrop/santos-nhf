import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../utils/feast.dart';
import 'local_cache.dart';

/// Catalog, collection, games and social data of the signed-in user.
class AppState extends ChangeNotifier {
  List<SaintInfo>? catalog;
  CollectionOverview? overview;
  AdminAccess? access;
  MyProfile? profile;
  DailyQuiz? quiz;
  List<PatchNoteEntry>? patchNotes;
  List<DuelSummary>? duels;
  Object? error;
  bool loading = false;

  /// True when the data on screen comes from the device cache because the
  /// server could not be reached.
  bool offline = false;

  /// When the cached data was saved, shown in the offline banner.
  DateTime? cachedAt;

  final _cache = LocalCache();

  /// Argentina calendar day the data on screen belongs to. The daily card and
  /// the daily question are per day, so a rollover invalidates both.
  String get day => _day;
  String _day = todayKey();
  Timer? _dayTimer;

  /// Starts watching for the day rollover. Safe to call more than once.
  void watchDayChange() {
    _dayTimer?.cancel();
    final wait =
        nextArgentinaMidnight().difference(nowInArgentina()) +
        const Duration(seconds: 2);
    _dayTimer = Timer(wait, () {
      checkDayChange();
      watchDayChange();
    });
  }

  /// Reloads when the calendar day moved on. Called by the timer and whenever
  /// the app comes back to the foreground, since timers do not fire reliably
  /// while a tab is asleep.
  void checkDayChange() {
    final today = todayKey();
    if (today == _day) return;
    _day = today;
    quiz = null;
    notifyListeners();
    unawaited(loadAll());
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    super.dispose();
  }

  /// Starter cards granted on the last load, until the UI shows them.
  List<CollectedCard> pendingStarterCards = const [];

  /// Whether there is a signed-in user. Everything but the catalog needs one.
  bool get signedIn => client.auth.isAuthenticated;

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope missing above this widget');
    return scope!.notifier!;
  }

  bool get isAdmin => access?.isAdmin ?? false;

  Set<int> get ownedIds =>
      overview?.cards.map((c) => c.saint.id).toSet() ?? const {};

  CollectedCard? cardFor(int saintId) =>
      overview?.cards.where((c) => c.saint.id == saintId).firstOrNull;

  /// Duels waiting for the player's move.
  int get pendingTurns => duels?.where((d) => d.isMyTurn).length ?? 0;

  /// Published saints whose feast is today, whether owned or not.
  List<SaintInfo> saintsOfToday(DateTime today) =>
      catalog
          ?.where(
            (s) => s.feastMonth == today.month && s.feastDay == today.day,
          )
          .toList() ??
      const [];

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();

    // Show the last known data right away; the network refreshes it below.
    if (catalog == null) {
      final cached = await _cache.load();
      if (cached != null) {
        catalog = cached.catalog;
        overview = signedIn ? cached.overview : null;
        profile = signedIn ? cached.profile : null;
        quiz = signedIn ? cached.quiz : null;
        patchNotes = cached.patchNotes;
        cachedAt = cached.savedAt;
        notifyListeners();
      }
    }

    try {
      if (!signedIn) {
        // Public mode: only the catalog.
        catalog = await client.saint.list();
        overview = null;
        access = null;
        profile = null;
        quiz = null;
        duels = null;
      } else {
        final results = await Future.wait<Object>([
          client.saint.list(),
          client.collection.overview(),
          client.adminAccess.myAccess(),
          client.friends.me(),
        ]);
        catalog = results[0] as List<SaintInfo>;
        final ov = results[1] as CollectionOverview;
        overview = ov;
        if (ov.newStarterCards.isNotEmpty) {
          pendingStarterCards = ov.newStarterCards;
        }
        access = results[2] as AdminAccess;
        profile = results[3] as MyProfile;
      }
      offline = false;
      error = null;
      unawaited(_persist());
    } catch (e) {
      if (catalog != null) {
        // Cached data is on screen: work offline instead of failing.
        offline = true;
      } else {
        error = e;
      }
    } finally {
      loading = false;
      notifyListeners();
    }
    if (offline) return;
    // Secondary data: failures here must not block the app.
    if (signedIn) {
      await Future.wait([refreshQuiz(), refreshPatchNotes(), refreshDuels()]);
    } else {
      await refreshPatchNotes();
    }
    unawaited(_persist());
  }

  /// Saves what the app would need to open without network.
  Future<void> _persist() async {
    final c = catalog;
    if (c == null) return;
    final now = DateTime.now().toUtc();
    cachedAt = now;
    await _cache.save(
      LocalSnapshot(
        catalog: c,
        overview: overview?.copyWith(newStarterCards: const []),
        profile: profile,
        quiz: quiz,
        patchNotes: patchNotes ?? const [],
        savedAt: now,
      ),
    );
  }

  Future<void> refreshCollection() async {
    overview = await client.collection.overview();
    offline = false;
    notifyListeners();
    unawaited(_persist());
  }

  Future<void> refreshCatalog() async {
    catalog = await client.saint.list();
    notifyListeners();
    unawaited(_persist());
  }

  Future<void> refreshAccess() async {
    access = await client.adminAccess.myAccess();
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    profile = await client.friends.me();
    notifyListeners();
  }

  Future<void> refreshQuiz() async {
    try {
      quiz = await client.quiz.today();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> refreshPatchNotes() async {
    try {
      patchNotes = await client.saint.recentChanges();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> refreshDuels() async {
    try {
      duels = await client.duel.myDuels();
      notifyListeners();
    } catch (_) {}
  }

  Future<DailyClaimResult> claimDaily() async {
    final result = await client.collection.claimDaily();
    await refreshCollection();
    return result;
  }

  Future<CollectedCard> redeem(String code) async {
    final card = await client.collection.redeem(code);
    await refreshCollection();
    return card;
  }

  Future<DailyQuiz> answerQuiz(int questionId, int index) async {
    final result = await client.quiz.answer(questionId, index);
    quiz = result;
    notifyListeners();
    unawaited(refreshProfile());
    return result;
  }

  void consumeStarterCards() {
    pendingStarterCards = const [];
    notifyListeners();
  }

  void reset() {
    unawaited(_cache.clear());
    offline = false;
    cachedAt = null;
    catalog = null;
    overview = null;
    access = null;
    profile = null;
    quiz = null;
    patchNotes = null;
    duels = null;
    error = null;
    pendingStarterCards = const [];
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);
}
