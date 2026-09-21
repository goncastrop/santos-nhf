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
