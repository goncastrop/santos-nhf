import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Stores the state of [previous] as a revision, attributed to the caller.
Future<void> recordRevision(
  Session session,
  Saint previous,
  String? note, {
  required Transaction transaction,
}) async {
  final auth = session.authenticated;
  // The lookup joins the caller's transaction: querying outside it while it
  // is open is a concurrent database call, which Serverpod rejects.
  final profile = auth == null
      ? null
      : await AuthServices.instance.userProfiles.maybeFindUserProfileByUserId(
          session,
          auth.authUserId,
          transaction: transaction,
        );
  await SaintRevision.db.insertRow(
    session,
    SaintRevision(
      saintId: previous.id!,
      snapshotJson: jsonEncode(previous.toJson()),
      note: note,
      changedByEmail: profile?.email,
      changedByAuthUserId: auth?.authUserId,
    ),
    transaction: transaction,
  );
}
