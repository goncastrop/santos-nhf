import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../meetings/meeting_service.dart';
import 'admin_scope.dart';

/// Admin management of which saints met in life. Each change applies to both
/// saints of the pair, so it is saved on its own instead of with the saint's
/// form and leaves no revision.
class AdminMeetingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  /// The saints [saintId] met, drafts included, oldest first.
  Future<List<Saint>> listFor(Session session, int saintId) =>
      MeetingService.saintsFor(session, saintId);

  /// Records that the two met and returns the updated list of [saintId].
  Future<List<Saint>> add(Session session, int saintId, int otherId) async {
    await MeetingService.add(session, saintId, otherId);
    return MeetingService.saintsFor(session, saintId);
  }

  /// Undoes [add] and returns the updated list of [saintId].
  Future<List<Saint>> remove(Session session, int saintId, int otherId) async {
    await MeetingService.remove(session, saintId, otherId);
    return MeetingService.saintsFor(session, saintId);
  }
}
