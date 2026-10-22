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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:saints_nhf_client/src/protocol/admin/admin_access.dart'
    as _i0319f55;
import 'package:saints_nhf_client/src/protocol/admin/admin_user.dart'
    as _iru27t36;
import 'package:saints_nhf_client/src/protocol/admin/import_report.dart'
    as _i6hsmomy;
import 'package:saints_nhf_client/src/protocol/books/saint_book.dart'
    as _iufuvubm;
import 'package:saints_nhf_client/src/protocol/codes/unlock_code.dart'
    as _ioe1cpkq;
import 'package:saints_nhf_client/src/protocol/collection/collected_card.dart'
    as _i59yczri;
import 'package:saints_nhf_client/src/protocol/collection/collection_overview.dart'
    as _i2ek2h2q;
import 'package:saints_nhf_client/src/protocol/collection/daily_claim_result.dart'
    as _i0lgknaa;
import 'package:saints_nhf_client/src/protocol/duel/duel_summary.dart'
    as _ihyypura;
import 'package:saints_nhf_client/src/protocol/duel/duel_view.dart'
    as _i0xdwvjk;
import 'package:saints_nhf_client/src/protocol/litany/litany_view.dart'
    as _inkd0p69;
import 'package:saints_nhf_client/src/protocol/live/live_me.dart' as _iisflcg2;
import 'package:saints_nhf_client/src/protocol/live/live_view.dart'
    as _i5gbr5f8;
import 'package:saints_nhf_client/src/protocol/questions/daily_quiz.dart'
    as _iw94znon;
import 'package:saints_nhf_client/src/protocol/questions/question.dart'
    as _i4pwanzb;
import 'package:saints_nhf_client/src/protocol/saints/patch_note_entry.dart'
    as _i03rie5r;
import 'package:saints_nhf_client/src/protocol/saints/saint.dart' as _i3ylg3gz;
import 'package:saints_nhf_client/src/protocol/saints/saint_detail.dart'
    as _iya8l065;
import 'package:saints_nhf_client/src/protocol/saints/saint_info.dart'
    as _ixoxxawi;
import 'package:saints_nhf_client/src/protocol/saints/saint_revision.dart'
    as _i97ohlx9;
import 'package:saints_nhf_client/src/protocol/saints/score_category.dart'
    as _iu9hbu29;
import 'package:saints_nhf_client/src/protocol/social/friend_collection.dart'
    as _ikqtk233;
import 'package:saints_nhf_client/src/protocol/social/friend_summary.dart'
    as _ijw14ij6;
import 'package:saints_nhf_client/src/protocol/social/leaderboard.dart'
    as _ipd7pxqy;
import 'package:saints_nhf_client/src/protocol/social/my_profile.dart'
    as _icc4qg7y;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// The signed-in player's own account.
/// {@category Endpoint}
class EndpointAccount extends _isc.EndpointRef {
  EndpointAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'account';

  /// Deletes the account for good. [confirmation] has to be
  /// [AccountService.confirmationWord], typed by the player.
  _ida.Future<void> deleteMyAccount(String confirmation) =>
      caller.callServerEndpoint<void>(
        'account',
        'deleteMyAccount',
        {'confirmation': confirmation},
      );
}

/// Lets a signed-in user check and request admin access.
/// {@category Endpoint}
class EndpointAdminAccess extends _isc.EndpointRef {
  EndpointAdminAccess(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminAccess';

  /// Whether the caller currently has the admin scope.
  _ida.Future<_i0319f55.AdminAccess> myAccess() =>
      caller.callServerEndpoint<_i0319f55.AdminAccess>(
        'adminAccess',
        'myAccess',
        {},
      );

  /// Grants the admin scope when the caller's email is listed in the
  /// `adminEmails` password: `config/passwords.yaml` locally, and
  /// `scloud password set adminEmails <emails>` on Serverpod Cloud, which
  /// does not upload that file.
  _ida.Future<_i0319f55.AdminAccess> requestAccess() =>
      caller.callServerEndpoint<_i0319f55.AdminAccess>(
        'adminAccess',
        'requestAccess',
        {},
      );
}

/// Admin management of the recommended reading of each saint.
/// {@category Endpoint}
class EndpointAdminBook extends _isc.EndpointRef {
  EndpointAdminBook(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminBook';

  _ida.Future<List<_iufuvubm.SaintBook>> listFor(int saintId) =>
      caller.callServerEndpoint<List<_iufuvubm.SaintBook>>(
        'adminBook',
        'listFor',
        {'saintId': saintId},
      );

  /// Number of books per saint id, for the admin list.
  _ida.Future<Map<int, int>> counts() =>
      caller.callServerEndpoint<Map<int, int>>(
        'adminBook',
        'counts',
        {},
      );

  _ida.Future<_iufuvubm.SaintBook> save(_iufuvubm.SaintBook book) =>
      caller.callServerEndpoint<_iufuvubm.SaintBook>(
        'adminBook',
        'save',
        {'book': book},
      );

  _ida.Future<void> delete(int bookId) => caller.callServerEndpoint<void>(
    'adminBook',
    'delete',
    {'bookId': bookId},
  );

  /// Rewrites the order of a saint's books, [bookIds] listed as they should
  /// read. Ids that are not the saint's are ignored.
  _ida.Future<List<_iufuvubm.SaintBook>> reorder(
    int saintId,
    List<int> bookIds,
  ) => caller.callServerEndpoint<List<_iufuvubm.SaintBook>>(
    'adminBook',
    'reorder',
    {
      'saintId': saintId,
      'bookIds': bookIds,
    },
  );
}

/// CSV export and import of saints, questions, books and meetings, for
/// maintaining the content in a spreadsheet.
/// {@category Endpoint}
class EndpointAdminCatalog extends _isc.EndpointRef {
  EndpointAdminCatalog(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminCatalog';

  _ida.Future<String> exportSaintsCsv() => caller.callServerEndpoint<String>(
    'adminCatalog',
    'exportSaintsCsv',
    {},
  );

  _ida.Future<String> exportQuestionsCsv() => caller.callServerEndpoint<String>(
    'adminCatalog',
    'exportQuestionsCsv',
    {},
  );

  _ida.Future<String> exportBooksCsv() => caller.callServerEndpoint<String>(
    'adminCatalog',
    'exportBooksCsv',
    {},
  );

  _ida.Future<String> exportMeetingsCsv() => caller.callServerEndpoint<String>(
    'adminCatalog',
    'exportMeetingsCsv',
    {},
  );

  /// With [apply] false, only reports what would change.
  _ida.Future<_i6hsmomy.ImportReport> importSaintsCsv(
    String csv,
    bool apply,
  ) => caller.callServerEndpoint<_i6hsmomy.ImportReport>(
    'adminCatalog',
    'importSaintsCsv',
    {
      'csv': csv,
      'apply': apply,
    },
  );

  _ida.Future<_i6hsmomy.ImportReport> importQuestionsCsv(
    String csv,
    bool apply,
  ) => caller.callServerEndpoint<_i6hsmomy.ImportReport>(
    'adminCatalog',
    'importQuestionsCsv',
    {
      'csv': csv,
      'apply': apply,
    },
  );

  _ida.Future<_i6hsmomy.ImportReport> importBooksCsv(
    String csv,
    bool apply,
  ) => caller.callServerEndpoint<_i6hsmomy.ImportReport>(
    'adminCatalog',
    'importBooksCsv',
    {
      'csv': csv,
      'apply': apply,
    },
  );

  _ida.Future<_i6hsmomy.ImportReport> importMeetingsCsv(
    String csv,
    bool apply,
  ) => caller.callServerEndpoint<_i6hsmomy.ImportReport>(
    'adminCatalog',
    'importMeetingsCsv',
    {
      'csv': csv,
      'apply': apply,
    },
  );
}

/// Admin management of unlock codes handed out during the stream.
/// {@category Endpoint}
class EndpointAdminCodes extends _isc.EndpointRef {
  EndpointAdminCodes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminCodes';

  _ida.Future<List<_ioe1cpkq.UnlockCode>> list() =>
      caller.callServerEndpoint<List<_ioe1cpkq.UnlockCode>>(
        'adminCodes',
        'list',
        {},
      );

  /// Creates a code. With an empty [code] a random one is generated.
  _ida.Future<_ioe1cpkq.UnlockCode> create(
    String code,
    int? saintId,
    int? maxUses,
    DateTime? expiresAt,
    String? note,
  ) => caller.callServerEndpoint<_ioe1cpkq.UnlockCode>(
    'adminCodes',
    'create',
    {
      'code': code,
      'saintId': saintId,
      'maxUses': maxUses,
      'expiresAt': expiresAt,
      'note': note,
    },
  );

  _ida.Future<_ioe1cpkq.UnlockCode> setActive(
    int codeId,
    bool active,
  ) => caller.callServerEndpoint<_ioe1cpkq.UnlockCode>(
    'adminCodes',
    'setActive',
    {
      'codeId': codeId,
      'active': active,
    },
  );

  _ida.Future<void> delete(int codeId) => caller.callServerEndpoint<void>(
    'adminCodes',
    'delete',
    {'codeId': codeId},
  );
}

/// Admin management of which saints met in life. Each change applies to both
/// saints of the pair, so it is saved on its own instead of with the saint's
/// form and leaves no revision.
/// {@category Endpoint}
class EndpointAdminMeeting extends _isc.EndpointRef {
  EndpointAdminMeeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminMeeting';

  /// The saints [saintId] met, drafts included, oldest first.
  _ida.Future<List<_i3ylg3gz.Saint>> listFor(int saintId) =>
      caller.callServerEndpoint<List<_i3ylg3gz.Saint>>(
        'adminMeeting',
        'listFor',
        {'saintId': saintId},
      );

  /// Records that the two met and returns the updated list of [saintId].
  _ida.Future<List<_i3ylg3gz.Saint>> add(
    int saintId,
    int otherId,
  ) => caller.callServerEndpoint<List<_i3ylg3gz.Saint>>(
    'adminMeeting',
    'add',
    {
      'saintId': saintId,
      'otherId': otherId,
    },
  );

  /// Undoes [add] and returns the updated list of [saintId].
  _ida.Future<List<_i3ylg3gz.Saint>> remove(
    int saintId,
    int otherId,
  ) => caller.callServerEndpoint<List<_i3ylg3gz.Saint>>(
    'adminMeeting',
    'remove',
    {
      'saintId': saintId,
      'otherId': otherId,
    },
  );
}

/// Admin management of the question bank.
/// {@category Endpoint}
class EndpointAdminQuestion extends _isc.EndpointRef {
  EndpointAdminQuestion(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminQuestion';

  _ida.Future<List<_i4pwanzb.Question>> listFor(int saintId) =>
      caller.callServerEndpoint<List<_i4pwanzb.Question>>(
        'adminQuestion',
        'listFor',
        {'saintId': saintId},
      );

  /// Number of questions per saint id.
  _ida.Future<Map<int, int>> counts() =>
      caller.callServerEndpoint<Map<int, int>>(
        'adminQuestion',
        'counts',
        {},
      );

  _ida.Future<_i4pwanzb.Question> save(_i4pwanzb.Question question) =>
      caller.callServerEndpoint<_i4pwanzb.Question>(
        'adminQuestion',
        'save',
        {'question': question},
      );

  _ida.Future<void> delete(int questionId) => caller.callServerEndpoint<void>(
    'adminQuestion',
    'delete',
    {'questionId': questionId},
  );
}

/// Admin CRUD of the saints catalog, with a revision history.
/// {@category Endpoint}
class EndpointAdminSaint extends _isc.EndpointRef {
  EndpointAdminSaint(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminSaint';

  /// Every saint, drafts included, ordered by name.
  _ida.Future<List<_i3ylg3gz.Saint>> listAll() =>
      caller.callServerEndpoint<List<_i3ylg3gz.Saint>>(
        'adminSaint',
        'listAll',
        {},
      );

  /// A saint by id, drafts included.
  _ida.Future<_i3ylg3gz.Saint> get(int saintId) =>
      caller.callServerEndpoint<_i3ylg3gz.Saint>(
        'adminSaint',
        'get',
        {'saintId': saintId},
      );

  /// Public URL of the illustration of a saint, if any.
  _ida.Future<String?> illustrationUrl(int saintId) =>
      caller.callServerEndpoint<String?>(
        'adminSaint',
        'illustrationUrl',
        {'saintId': saintId},
      );

  /// Creates or updates a saint. On update, the previous state is kept as a
  /// [SaintRevision] with [note] describing the change.
  _ida.Future<_i3ylg3gz.Saint> save(
    _i3ylg3gz.Saint saint,
    String? note,
  ) => caller.callServerEndpoint<_i3ylg3gz.Saint>(
    'adminSaint',
    'save',
    {
      'saint': saint,
      'note': note,
    },
  );

  /// Deletes a saint and, by cascade, its revisions and collected cards.
  _ida.Future<void> delete(int saintId) => caller.callServerEndpoint<void>(
    'adminSaint',
    'delete',
    {'saintId': saintId},
  );

  /// Revision history of a saint, newest first.
  _ida.Future<List<_i97ohlx9.SaintRevision>> revisions(int saintId) =>
      caller.callServerEndpoint<List<_i97ohlx9.SaintRevision>>(
        'adminSaint',
        'revisions',
        {'saintId': saintId},
      );

  /// Decodes the saint stored in a revision.
  _ida.Future<_i3ylg3gz.Saint> revisionSnapshot(int revisionId) =>
      caller.callServerEndpoint<_i3ylg3gz.Saint>(
        'adminSaint',
        'revisionSnapshot',
        {'revisionId': revisionId},
      );

  /// Restores a saint to the state stored in [revisionId]. The current state
  /// is saved as a new revision first.
  _ida.Future<_i3ylg3gz.Saint> restore(
    int revisionId,
    String? note,
  ) => caller.callServerEndpoint<_i3ylg3gz.Saint>(
    'adminSaint',
    'restore',
    {
      'revisionId': revisionId,
      'note': note,
    },
  );

  /// Stores the illustration of a saint, sent as bytes by the admin app.
  ///
  /// The image travels through the server instead of going straight to the
  /// storage bucket. A browser upload directly to the bucket is blocked by
  /// the bucket's cross-origin rules, and routing it here keeps one code
  /// path for every platform and for both the database and cloud storages.
  ///
  /// Keep [maxIllustrationBytes] in sync with the app, and both below the
  /// server's `maxRequestSize`: the bytes are base64 encoded in the request,
  /// which adds about a third to their size.
  _ida.Future<_i3ylg3gz.Saint> uploadIllustration(
    int saintId,
    String extension,
    _idt.ByteData bytes,
  ) => caller.callServerEndpoint<_i3ylg3gz.Saint>(
    'adminSaint',
    'uploadIllustration',
    {
      'saintId': saintId,
      'extension': extension,
      'bytes': bytes,
    },
  );
}

/// Admin management of other admins.
/// {@category Endpoint}
class EndpointAdminUsers extends _isc.EndpointRef {
  EndpointAdminUsers(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminUsers';

  /// Users that currently hold the admin scope.
  _ida.Future<List<_iru27t36.AdminUser>> listAdmins() =>
      caller.callServerEndpoint<List<_iru27t36.AdminUser>>(
        'adminUsers',
        'listAdmins',
        {},
      );

  /// Grants the admin scope to the user registered with [email].
  _ida.Future<_iru27t36.AdminUser> grantAdmin(String email) =>
      caller.callServerEndpoint<_iru27t36.AdminUser>(
        'adminUsers',
        'grantAdmin',
        {'email': email},
      );

  /// Removes the admin scope from the user registered with [email].
  _ida.Future<void> revokeAdmin(String email) =>
      caller.callServerEndpoint<void>(
        'adminUsers',
        'revokeAdmin',
        {'email': email},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// Sign-in with Google. Its existence is what makes the sign-in widget show
/// the Google button; the provider itself only runs when `server.dart` finds
/// `googleClientSecret` in the passwords.
///
/// Serverpod keys a Google account by Google's own user id and, the first
/// time it sees one, creates a brand new user for it, even when someone
/// already plays with that same address by email and password. Here that
/// person would land in an empty album, so before Serverpod looks, the Google
/// account is linked to the existing user. See [GoogleAccountLinking].
/// {@category Endpoint}
class EndpointGoogleIdp extends _iaic.EndpointGoogleIdpBase {
  EndpointGoogleIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIdp';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );

  /// The web flow. The code can be exchanged only once, so it is exchanged
  /// here and the tokens go through [login], which does the linking.
  @override
  _ida.Future<_iacc.AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'googleIdp',
    'loginWithCode',
    {
      'code': code,
      'codeVerifier': codeVerifier,
      'redirectUri': redirectUri,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'googleIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// The signed-in user's card collection.
/// {@category Endpoint}
class EndpointCollection extends _isc.EndpointRef {
  EndpointCollection(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'collection';

  /// Collection state. Grants the starter pack on first call.
  _ida.Future<_i2ek2h2q.CollectionOverview> overview() =>
      caller.callServerEndpoint<_i2ek2h2q.CollectionOverview>(
        'collection',
        'overview',
        {},
      );

  /// Claims today's card. Throws [CollectionException] when not possible.
  _ida.Future<_i0lgknaa.DailyClaimResult> claimDaily() =>
      caller.callServerEndpoint<_i0lgknaa.DailyClaimResult>(
        'collection',
        'claimDaily',
        {},
      );

  /// Redeems an unlock code. Throws [CollectionException] when invalid.
  _ida.Future<_i59yczri.CollectedCard> redeem(String code) =>
      caller.callServerEndpoint<_i59yczri.CollectedCard>(
        'collection',
        'redeem',
        {'code': code},
      );
}

/// Card duels against the machine or against friends.
/// {@category Endpoint}
class EndpointDuel extends _isc.EndpointRef {
  EndpointDuel(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'duel';

  /// Owned saints that can be put in a deck (they have questions).
  _ida.Future<List<int>> eligibleSaintIds() =>
      caller.callServerEndpoint<List<int>>(
        'duel',
        'eligibleSaintIds',
        {},
      );

  /// Deals the hand the next deck must be chosen from.
  _ida.Future<List<int>> dealHand() => caller.callServerEndpoint<List<int>>(
    'duel',
    'dealHand',
    {},
  );

  _ida.Future<_i0xdwvjk.DuelView> createVsMachine(List<int> deckSaintIds) =>
      caller.callServerEndpoint<_i0xdwvjk.DuelView>(
        'duel',
        'createVsMachine',
        {'deckSaintIds': deckSaintIds},
      );

  _ida.Future<_i0xdwvjk.DuelView> challenge(
    _isc.UuidValue opponentId,
    List<int> deckSaintIds,
  ) => caller.callServerEndpoint<_i0xdwvjk.DuelView>(
    'duel',
    'challenge',
    {
      'opponentId': opponentId,
      'deckSaintIds': deckSaintIds,
    },
  );

  _ida.Future<_i0xdwvjk.DuelView> accept(
    int duelId,
    List<int> deckSaintIds,
  ) => caller.callServerEndpoint<_i0xdwvjk.DuelView>(
    'duel',
    'accept',
    {
      'duelId': duelId,
      'deckSaintIds': deckSaintIds,
    },
  );

  _ida.Future<void> decline(int duelId) => caller.callServerEndpoint<void>(
    'duel',
    'decline',
    {'duelId': duelId},
  );

  _ida.Future<List<_ihyypura.DuelSummary>> myDuels() =>
      caller.callServerEndpoint<List<_ihyypura.DuelSummary>>(
        'duel',
        'myDuels',
        {},
      );

  _ida.Future<_i0xdwvjk.DuelView> view(int duelId) =>
      caller.callServerEndpoint<_i0xdwvjk.DuelView>(
        'duel',
        'view',
        {'duelId': duelId},
      );

  /// The board now and again after every move, from either player.
  _ida.Stream<_i0xdwvjk.DuelView> watch(int duelId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i0xdwvjk.DuelView>,
        _i0xdwvjk.DuelView
      >(
        'duel',
        'watch',
        {'duelId': duelId},
        {},
      );

  /// The player's duels now and again whenever one of them changes, for the
  /// count of turns waiting.
  _ida.Stream<List<_ihyypura.DuelSummary>> watchMine() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<_ihyypura.DuelSummary>>,
        List<_ihyypura.DuelSummary>
      >(
        'duel',
        'watchMine',
        {},
        {},
      );

  _ida.Future<_i0xdwvjk.DuelView> attack(
    int duelId,
    _iu9hbu29.ScoreCategory category,
    int saintId,
  ) => caller.callServerEndpoint<_i0xdwvjk.DuelView>(
    'duel',
    'attack',
    {
      'duelId': duelId,
      'category': category,
      'saintId': saintId,
    },
  );

  _ida.Future<_i0xdwvjk.DuelView> defend(
    int duelId,
    int saintId,
  ) => caller.callServerEndpoint<_i0xdwvjk.DuelView>(
    'duel',
    'defend',
    {
      'duelId': duelId,
      'saintId': saintId,
    },
  );

  _ida.Future<_i0xdwvjk.DuelView> answer(
    int duelId,
    int chosenIndex,
  ) => caller.callServerEndpoint<_i0xdwvjk.DuelView>(
    'duel',
    'answer',
    {
      'duelId': duelId,
      'chosenIndex': chosenIndex,
    },
  );
}

/// La Letanía: the solo run of questions.
/// {@category Endpoint}
class EndpointLitany extends _isc.EndpointRef {
  EndpointLitany(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'litany';

  /// The run in progress, if any.
  _ida.Future<_inkd0p69.LitanyView> state() =>
      caller.callServerEndpoint<_inkd0p69.LitanyView>(
        'litany',
        'state',
        {},
      );

  /// Starts a run, or picks up the one already going on.
  _ida.Future<_inkd0p69.LitanyView> start() =>
      caller.callServerEndpoint<_inkd0p69.LitanyView>(
        'litany',
        'start',
        {},
      );

  _ida.Future<_inkd0p69.LitanyView> answer(int chosenIndex) =>
      caller.callServerEndpoint<_inkd0p69.LitanyView>(
        'litany',
        'answer',
        {'chosenIndex': chosenIndex},
      );

  _ida.Future<_inkd0p69.LitanyView> next() =>
      caller.callServerEndpoint<_inkd0p69.LitanyView>(
        'litany',
        'next',
        {},
      );

  _ida.Future<_inkd0p69.LitanyView> giveUp() =>
      caller.callServerEndpoint<_inkd0p69.LitanyView>(
        'litany',
        'giveUp',
        {},
      );
}

/// Runs the live trivia from the admin panel.
/// {@category Endpoint}
class EndpointAdminLive extends _isc.EndpointRef {
  EndpointAdminLive(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminLive';

  /// Opens the lobby now; the first question opens after [countdownSeconds].
  _ida.Future<_i5gbr5f8.LiveView> announce(
    int saintId,
    List<int> questionIds,
    int countdownSeconds,
    int questionSeconds,
    int fastPrizes,
    int rafflePrizes,
  ) => caller.callServerEndpoint<_i5gbr5f8.LiveView>(
    'adminLive',
    'announce',
    {
      'saintId': saintId,
      'questionIds': questionIds,
      'countdownSeconds': countdownSeconds,
      'questionSeconds': questionSeconds,
      'fastPrizes': fastPrizes,
      'rafflePrizes': rafflePrizes,
    },
  );

  /// Skips the countdown, closes the open question, goes to the next one or
  /// ends the game, depending on where it is.
  _ida.Future<_i5gbr5f8.LiveView> advance(int gameId) =>
      caller.callServerEndpoint<_i5gbr5f8.LiveView>(
        'adminLive',
        'advance',
        {'gameId': gameId},
      );

  _ida.Future<_i5gbr5f8.LiveView> cancel(int gameId) =>
      caller.callServerEndpoint<_i5gbr5f8.LiveView>(
        'adminLive',
        'cancel',
        {'gameId': gameId},
      );
}

/// The live trivia, for everyone. Watching needs no account, so whoever
/// opens the app because the show told them to sees the game at once;
/// answering does, because the prize goes to an album.
/// {@category Endpoint}
class EndpointLive extends _isc.EndpointRef {
  EndpointLive(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'live';

  /// The game as it stands now.
  _ida.Future<_i5gbr5f8.LiveView> state() =>
      caller.callServerEndpoint<_i5gbr5f8.LiveView>(
        'live',
        'state',
        {},
      );

  /// A view now and another one after every change. The app keeps it open
  /// while it is in the foreground, which is how the banner shows up on any
  /// tab when the host announces a game.
  _ida.Stream<_i5gbr5f8.LiveView> watch() =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i5gbr5f8.LiveView>,
        _i5gbr5f8.LiveView
      >(
        'live',
        'watch',
        {},
        {},
      );

  /// Answers question [questionIndex] (0-based) with the option at
  /// [chosenIndex], in the order shown.
  _ida.Future<_iisflcg2.LiveMe> answer(
    int gameId,
    int questionIndex,
    int chosenIndex,
  ) => caller.callServerEndpoint<_iisflcg2.LiveMe>(
    'live',
    'answer',
    {
      'gameId': gameId,
      'questionIndex': questionIndex,
      'chosenIndex': chosenIndex,
    },
  );
}

/// The daily question and its streak.
/// {@category Endpoint}
class EndpointQuiz extends _isc.EndpointRef {
  EndpointQuiz(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'quiz';

  _ida.Future<_iw94znon.DailyQuiz> today() =>
      caller.callServerEndpoint<_iw94znon.DailyQuiz>(
        'quiz',
        'today',
        {},
      );

  _ida.Future<_iw94znon.DailyQuiz> answer(
    int questionId,
    int chosenIndex,
  ) => caller.callServerEndpoint<_iw94znon.DailyQuiz>(
    'quiz',
    'answer',
    {
      'questionId': questionId,
      'chosenIndex': chosenIndex,
    },
  );
}

/// Public catalog of published saints. No sign-in required.
/// {@category Endpoint}
class EndpointSaint extends _isc.EndpointRef {
  EndpointSaint(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'saint';

  /// All published saints, ordered by name. Scores are never included.
  _ida.Future<List<_ixoxxawi.SaintInfo>> list() =>
      caller.callServerEndpoint<List<_ixoxxawi.SaintInfo>>(
        'saint',
        'list',
        {},
      );

  /// A published saint by id, with the card when the caller owns it.
  _ida.Future<_iya8l065.SaintDetail> detail(int saintId) =>
      caller.callServerEndpoint<_iya8l065.SaintDetail>(
        'saint',
        'detail',
        {'saintId': saintId},
      );

  /// Recent score changes of published saints ("notas del parche"). Exact
  /// values are only included for cards the caller owns.
  _ida.Future<List<_i03rie5r.PatchNoteEntry>> recentChanges() =>
      caller.callServerEndpoint<List<_i03rie5r.PatchNoteEntry>>(
        'saint',
        'recentChanges',
        {},
      );
}

/// Player identity, friend codes and friends' collections.
/// {@category Endpoint}
class EndpointFriends extends _isc.EndpointRef {
  EndpointFriends(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'friends';

  _ida.Future<_icc4qg7y.MyProfile> me() =>
      caller.callServerEndpoint<_icc4qg7y.MyProfile>(
        'friends',
        'me',
        {},
      );

  _ida.Future<_icc4qg7y.MyProfile> setDisplayName(String name) =>
      caller.callServerEndpoint<_icc4qg7y.MyProfile>(
        'friends',
        'setDisplayName',
        {'name': name},
      );

  /// Adds the player whose friend code is [code]. Friendship is immediate:
  /// the code is the invitation.
  _ida.Future<_ijw14ij6.FriendSummary> addByCode(String code) =>
      caller.callServerEndpoint<_ijw14ij6.FriendSummary>(
        'friends',
        'addByCode',
        {'code': code},
      );

  _ida.Future<List<_ijw14ij6.FriendSummary>> list() =>
      caller.callServerEndpoint<List<_ijw14ij6.FriendSummary>>(
        'friends',
        'list',
        {},
      );

  _ida.Future<void> remove(_isc.UuidValue friendId) =>
      caller.callServerEndpoint<void>(
        'friends',
        'remove',
        {'friendId': friendId},
      );

  /// The saints a friend has collected. Scores are not included.
  _ida.Future<_ikqtk233.FriendCollection> collectionOf(
    _isc.UuidValue friendId,
  ) => caller.callServerEndpoint<_ikqtk233.FriendCollection>(
    'friends',
    'collectionOf',
    {'friendId': friendId},
  );
}

/// Global rankings by cards, streak and duels won.
/// {@category Endpoint}
class EndpointLeaderboard extends _isc.EndpointRef {
  EndpointLeaderboard(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'leaderboard';

  _ida.Future<_ipd7pxqy.Leaderboard> top() =>
      caller.callServerEndpoint<_ipd7pxqy.Leaderboard>(
        'leaderboard',
        'top',
        {},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    account = EndpointAccount(this);
    adminAccess = EndpointAdminAccess(this);
    adminBook = EndpointAdminBook(this);
    adminCatalog = EndpointAdminCatalog(this);
    adminCodes = EndpointAdminCodes(this);
    adminMeeting = EndpointAdminMeeting(this);
    adminQuestion = EndpointAdminQuestion(this);
    adminSaint = EndpointAdminSaint(this);
    adminUsers = EndpointAdminUsers(this);
    emailIdp = EndpointEmailIdp(this);
    googleIdp = EndpointGoogleIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    collection = EndpointCollection(this);
    duel = EndpointDuel(this);
    litany = EndpointLitany(this);
    adminLive = EndpointAdminLive(this);
    live = EndpointLive(this);
    quiz = EndpointQuiz(this);
    saint = EndpointSaint(this);
    friends = EndpointFriends(this);
    leaderboard = EndpointLeaderboard(this);
    modules = Modules(this);
  }

  late final EndpointAccount account;

  late final EndpointAdminAccess adminAccess;

  late final EndpointAdminBook adminBook;

  late final EndpointAdminCatalog adminCatalog;

  late final EndpointAdminCodes adminCodes;

  late final EndpointAdminMeeting adminMeeting;

  late final EndpointAdminQuestion adminQuestion;

  late final EndpointAdminSaint adminSaint;

  late final EndpointAdminUsers adminUsers;

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleIdp googleIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointCollection collection;

  late final EndpointDuel duel;

  late final EndpointLitany litany;

  late final EndpointAdminLive adminLive;

  late final EndpointLive live;

  late final EndpointQuiz quiz;

  late final EndpointSaint saint;

  late final EndpointFriends friends;

  late final EndpointLeaderboard leaderboard;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'account': account,
    'adminAccess': adminAccess,
    'adminBook': adminBook,
    'adminCatalog': adminCatalog,
    'adminCodes': adminCodes,
    'adminMeeting': adminMeeting,
    'adminQuestion': adminQuestion,
    'adminSaint': adminSaint,
    'adminUsers': adminUsers,
    'emailIdp': emailIdp,
    'googleIdp': googleIdp,
    'jwtRefresh': jwtRefresh,
    'collection': collection,
    'duel': duel,
    'litany': litany,
    'adminLive': adminLive,
    'live': live,
    'quiz': quiz,
    'saint': saint,
    'friends': friends,
    'leaderboard': leaderboard,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
