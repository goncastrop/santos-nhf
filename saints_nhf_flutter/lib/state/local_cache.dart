import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-side copy of the last data the app loaded, so it can open and show
/// the album, the saints and their prayers without network.
///
/// Uses the shared [LocalSnapshot] model, so the format is the same one the
/// server speaks; only the storage is local.
class LocalCache {
  static const _key = 'santos_nhf.snapshot.v1';

  /// Aparte de la foto de los datos: cerrar sesión borra el snapshot, pero
  /// la bienvenida ya la vio esta persona y no hay que volver a mostrarla.
  static const _welcomeKey = 'santos_nhf.welcome_seen.v1';

  /// Si ya se mostró la bienvenida en este dispositivo. Ante la duda dice
  /// que sí: mejor no mostrarla que mostrarla dos veces.
  Future<bool> welcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_welcomeKey) ?? false;
    } catch (e) {
      debugPrint('LocalCache.welcomeSeen failed: $e');
      return true;
    }
  }

  static const _liveDismissedKey = 'santos_nhf.live_dismissed.v1';

  /// La trivia cuyo cartel se cerró en este dispositivo, así recargar la
  /// página no lo trae de vuelta.
  Future<int?> dismissedLiveGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_liveDismissedKey);
    } catch (e) {
      debugPrint('LocalCache.dismissedLiveGame failed: $e');
      return null;
    }
  }

  Future<void> markLiveGameDismissed(int? gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (gameId == null) {
        await prefs.remove(_liveDismissedKey);
      } else {
        await prefs.setInt(_liveDismissedKey, gameId);
      }
    } catch (e) {
      debugPrint('LocalCache.markLiveGameDismissed failed: $e');
    }
  }

  Future<void> markWelcomeSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_welcomeKey, true);
    } catch (e) {
      debugPrint('LocalCache.markWelcomeSeen failed: $e');
    }
  }

  Future<LocalSnapshot?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      return LocalSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e) {
      // A corrupt or outdated snapshot is simply ignored.
      debugPrint('LocalCache.load failed: $e');
      return null;
    }
  }

  Future<void> save(LocalSnapshot snapshot) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(snapshot.toJson()));
    } catch (e) {
      debugPrint('LocalCache.save failed: $e');
    }
  }

  Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}
