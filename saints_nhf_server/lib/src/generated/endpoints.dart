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
import 'dart:typed_data' as _idt;
import 'package:saints_nhf_server/src/generated/books/saint_book.dart'
    as _i3dacp34;
import 'package:saints_nhf_server/src/generated/protocol.dart' as _itw3ru38;
import 'package:saints_nhf_server/src/generated/questions/question.dart'
    as _i00r6ooi;
import 'package:saints_nhf_server/src/generated/saints/saint.dart' as _i6crwlsp;
import 'package:saints_nhf_server/src/generated/saints/score_category.dart'
    as _i9dy8bz4;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../admin/admin_access_endpoint.dart' as _ii14t626;
import '../admin/admin_book_endpoint.dart' as _iv0rqla0;
import '../admin/admin_catalog_endpoint.dart' as _i3lzez2m;
import '../admin/admin_codes_endpoint.dart' as _ia59h2uj;
import '../admin/admin_question_endpoint.dart' as _i9hrktio;
import '../admin/admin_saint_endpoint.dart' as _inuxycqi;
import '../admin/admin_users_endpoint.dart' as _i8e7rap6;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../collection/collection_endpoint.dart' as _igyw9xw4;
import '../duel/duel_endpoint.dart' as _inwr4dl6;
import '../litany/litany_endpoint.dart' as _ir5yijij;
import '../questions/quiz_endpoint.dart' as _i9pu1r99;
import '../saints/saint_endpoint.dart' as _i0hn8dfu;
import '../social/friends_endpoint.dart' as _iejqgreb;
import '../social/leaderboard_endpoint.dart' as _i0n7rhey;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'adminAccess': _ii14t626.AdminAccessEndpoint()
        ..initialize(
          server,
          'adminAccess',
          null,
        ),
      'adminBook': _iv0rqla0.AdminBookEndpoint()
        ..initialize(
          server,
          'adminBook',
          null,
        ),
      'adminCatalog': _i3lzez2m.AdminCatalogEndpoint()
        ..initialize(
          server,
          'adminCatalog',
          null,
        ),
      'adminCodes': _ia59h2uj.AdminCodesEndpoint()
        ..initialize(
          server,
          'adminCodes',
          null,
        ),
      'adminQuestion': _i9hrktio.AdminQuestionEndpoint()
        ..initialize(
          server,
          'adminQuestion',
          null,
        ),
      'adminSaint': _inuxycqi.AdminSaintEndpoint()
        ..initialize(
          server,
          'adminSaint',
          null,
        ),
      'adminUsers': _i8e7rap6.AdminUsersEndpoint()
        ..initialize(
          server,
          'adminUsers',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'collection': _igyw9xw4.CollectionEndpoint()
        ..initialize(
          server,
          'collection',
          null,
        ),
      'duel': _inwr4dl6.DuelEndpoint()
        ..initialize(
          server,
          'duel',
          null,
        ),
      'litany': _ir5yijij.LitanyEndpoint()
        ..initialize(
          server,
          'litany',
          null,
        ),
      'quiz': _i9pu1r99.QuizEndpoint()
        ..initialize(
          server,
          'quiz',
          null,
        ),
      'saint': _i0hn8dfu.SaintEndpoint()
        ..initialize(
          server,
          'saint',
          null,
        ),
      'friends': _iejqgreb.FriendsEndpoint()
        ..initialize(
          server,
          'friends',
          null,
        ),
      'leaderboard': _i0n7rhey.LeaderboardEndpoint()
        ..initialize(
          server,
          'leaderboard',
          null,
        ),
    };
    connectors['adminAccess'] = _is.EndpointConnector(
      name: 'adminAccess',
      endpoint: endpoints['adminAccess']!,
      methodConnectors: {
        'myAccess': _is.MethodConnector(
          name: 'myAccess',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminAccess'] as _ii14t626.AdminAccessEndpoint)
                      .myAccess(session),
        ),
        'requestAccess': _is.MethodConnector(
          name: 'requestAccess',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminAccess'] as _ii14t626.AdminAccessEndpoint)
                      .requestAccess(session),
        ),
      },
    );
    connectors['adminBook'] = _is.EndpointConnector(
      name: 'adminBook',
      endpoint: endpoints['adminBook']!,
      methodConnectors: {
        'listFor': _is.MethodConnector(
          name: 'listFor',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminBook'] as _iv0rqla0.AdminBookEndpoint)
                  .listFor(
                    session,
                    params['saintId'],
                  ),
        ),
        'counts': _is.MethodConnector(
          name: 'counts',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminBook'] as _iv0rqla0.AdminBookEndpoint)
                  .counts(session)
                  .then(
                    (container) =>
                        _itw3ru38.Protocol().mapContainerToJson(container),
                  ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'book': _is.ParameterDescription(
              name: 'book',
              type: _is.getType<_i3dacp34.SaintBook>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminBook'] as _iv0rqla0.AdminBookEndpoint).save(
                    session,
                    params['book'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'bookId': _is.ParameterDescription(
              name: 'bookId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminBook'] as _iv0rqla0.AdminBookEndpoint)
                  .delete(
                    session,
                    params['bookId'],
                  ),
        ),
        'reorder': _is.MethodConnector(
          name: 'reorder',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'bookIds': _is.ParameterDescription(
              name: 'bookIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminBook'] as _iv0rqla0.AdminBookEndpoint)
                  .reorder(
                    session,
                    params['saintId'],
                    params['bookIds'],
                  ),
        ),
      },
    );
    connectors['adminCatalog'] = _is.EndpointConnector(
      name: 'adminCatalog',
      endpoint: endpoints['adminCatalog']!,
      methodConnectors: {
        'exportSaintsCsv': _is.MethodConnector(
          name: 'exportSaintsCsv',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .exportSaintsCsv(session),
        ),
        'exportQuestionsCsv': _is.MethodConnector(
          name: 'exportQuestionsCsv',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .exportQuestionsCsv(session),
        ),
        'exportBooksCsv': _is.MethodConnector(
          name: 'exportBooksCsv',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .exportBooksCsv(session),
        ),
        'importSaintsCsv': _is.MethodConnector(
          name: 'importSaintsCsv',
          params: {
            'csv': _is.ParameterDescription(
              name: 'csv',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'apply': _is.ParameterDescription(
              name: 'apply',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .importSaintsCsv(
                        session,
                        params['csv'],
                        params['apply'],
                      ),
        ),
        'importQuestionsCsv': _is.MethodConnector(
          name: 'importQuestionsCsv',
          params: {
            'csv': _is.ParameterDescription(
              name: 'csv',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'apply': _is.ParameterDescription(
              name: 'apply',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .importQuestionsCsv(
                        session,
                        params['csv'],
                        params['apply'],
                      ),
        ),
        'importBooksCsv': _is.MethodConnector(
          name: 'importBooksCsv',
          params: {
            'csv': _is.ParameterDescription(
              name: 'csv',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'apply': _is.ParameterDescription(
              name: 'apply',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCatalog'] as _i3lzez2m.AdminCatalogEndpoint)
                      .importBooksCsv(
                        session,
                        params['csv'],
                        params['apply'],
                      ),
        ),
      },
    );
    connectors['adminCodes'] = _is.EndpointConnector(
      name: 'adminCodes',
      endpoint: endpoints['adminCodes']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCodes'] as _ia59h2uj.AdminCodesEndpoint)
                      .list(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'maxUses': _is.ParameterDescription(
              name: 'maxUses',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'expiresAt': _is.ParameterDescription(
              name: 'expiresAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCodes'] as _ia59h2uj.AdminCodesEndpoint)
                      .create(
                        session,
                        params['code'],
                        params['saintId'],
                        params['maxUses'],
                        params['expiresAt'],
                        params['note'],
                      ),
        ),
        'setActive': _is.MethodConnector(
          name: 'setActive',
          params: {
            'codeId': _is.ParameterDescription(
              name: 'codeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'active': _is.ParameterDescription(
              name: 'active',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCodes'] as _ia59h2uj.AdminCodesEndpoint)
                      .setActive(
                        session,
                        params['codeId'],
                        params['active'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'codeId': _is.ParameterDescription(
              name: 'codeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminCodes'] as _ia59h2uj.AdminCodesEndpoint)
                      .delete(
                        session,
                        params['codeId'],
                      ),
        ),
      },
    );
    connectors['adminQuestion'] = _is.EndpointConnector(
      name: 'adminQuestion',
      endpoint: endpoints['adminQuestion']!,
      methodConnectors: {
        'listFor': _is.MethodConnector(
          name: 'listFor',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminQuestion']
                          as _i9hrktio.AdminQuestionEndpoint)
                      .listFor(
                        session,
                        params['saintId'],
                      ),
        ),
        'counts': _is.MethodConnector(
          name: 'counts',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminQuestion']
                          as _i9hrktio.AdminQuestionEndpoint)
                      .counts(session)
                      .then(
                        (container) =>
                            _itw3ru38.Protocol().mapContainerToJson(container),
                      ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'question': _is.ParameterDescription(
              name: 'question',
              type: _is.getType<_i00r6ooi.Question>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminQuestion']
                          as _i9hrktio.AdminQuestionEndpoint)
                      .save(
                        session,
                        params['question'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'questionId': _is.ParameterDescription(
              name: 'questionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminQuestion']
                          as _i9hrktio.AdminQuestionEndpoint)
                      .delete(
                        session,
                        params['questionId'],
                      ),
        ),
      },
    );
    connectors['adminSaint'] = _is.EndpointConnector(
      name: 'adminSaint',
      endpoint: endpoints['adminSaint']!,
      methodConnectors: {
        'listAll': _is.MethodConnector(
          name: 'listAll',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .listAll(session),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint).get(
                    session,
                    params['saintId'],
                  ),
        ),
        'illustrationUrl': _is.MethodConnector(
          name: 'illustrationUrl',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .illustrationUrl(
                        session,
                        params['saintId'],
                      ),
        ),
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'saint': _is.ParameterDescription(
              name: 'saint',
              type: _is.getType<_i6crwlsp.Saint>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .save(
                        session,
                        params['saint'],
                        params['note'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .delete(
                        session,
                        params['saintId'],
                      ),
        ),
        'revisions': _is.MethodConnector(
          name: 'revisions',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .revisions(
                        session,
                        params['saintId'],
                      ),
        ),
        'revisionSnapshot': _is.MethodConnector(
          name: 'revisionSnapshot',
          params: {
            'revisionId': _is.ParameterDescription(
              name: 'revisionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .revisionSnapshot(
                        session,
                        params['revisionId'],
                      ),
        ),
        'restore': _is.MethodConnector(
          name: 'restore',
          params: {
            'revisionId': _is.ParameterDescription(
              name: 'revisionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .restore(
                        session,
                        params['revisionId'],
                        params['note'],
                      ),
        ),
        'uploadIllustration': _is.MethodConnector(
          name: 'uploadIllustration',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'extension': _is.ParameterDescription(
              name: 'extension',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'bytes': _is.ParameterDescription(
              name: 'bytes',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminSaint'] as _inuxycqi.AdminSaintEndpoint)
                      .uploadIllustration(
                        session,
                        params['saintId'],
                        params['extension'],
                        params['bytes'],
                      ),
        ),
      },
    );
    connectors['adminUsers'] = _is.EndpointConnector(
      name: 'adminUsers',
      endpoint: endpoints['adminUsers']!,
      methodConnectors: {
        'listAdmins': _is.MethodConnector(
          name: 'listAdmins',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUsers'] as _i8e7rap6.AdminUsersEndpoint)
                      .listAdmins(session),
        ),
        'grantAdmin': _is.MethodConnector(
          name: 'grantAdmin',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUsers'] as _i8e7rap6.AdminUsersEndpoint)
                      .grantAdmin(
                        session,
                        params['email'],
                      ),
        ),
        'revokeAdmin': _is.MethodConnector(
          name: 'revokeAdmin',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['adminUsers'] as _i8e7rap6.AdminUsersEndpoint)
                      .revokeAdmin(
                        session,
                        params['email'],
                      ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['collection'] = _is.EndpointConnector(
      name: 'collection',
      endpoint: endpoints['collection']!,
      methodConnectors: {
        'overview': _is.MethodConnector(
          name: 'overview',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _igyw9xw4.CollectionEndpoint)
                      .overview(session),
        ),
        'claimDaily': _is.MethodConnector(
          name: 'claimDaily',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _igyw9xw4.CollectionEndpoint)
                      .claimDaily(session),
        ),
        'redeem': _is.MethodConnector(
          name: 'redeem',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['collection'] as _igyw9xw4.CollectionEndpoint)
                      .redeem(
                        session,
                        params['code'],
                      ),
        ),
      },
    );
    connectors['duel'] = _is.EndpointConnector(
      name: 'duel',
      endpoint: endpoints['duel']!,
      methodConnectors: {
        'eligibleSaintIds': _is.MethodConnector(
          name: 'eligibleSaintIds',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint)
                  .eligibleSaintIds(session),
        ),
        'dealHand': _is.MethodConnector(
          name: 'dealHand',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).dealHand(
                session,
              ),
        ),
        'createVsMachine': _is.MethodConnector(
          name: 'createVsMachine',
          params: {
            'deckSaintIds': _is.ParameterDescription(
              name: 'deckSaintIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['duel'] as _inwr4dl6.DuelEndpoint).createVsMachine(
                    session,
                    params['deckSaintIds'],
                  ),
        ),
        'challenge': _is.MethodConnector(
          name: 'challenge',
          params: {
            'opponentId': _is.ParameterDescription(
              name: 'opponentId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deckSaintIds': _is.ParameterDescription(
              name: 'deckSaintIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['duel'] as _inwr4dl6.DuelEndpoint).challenge(
                    session,
                    params['opponentId'],
                    params['deckSaintIds'],
                  ),
        ),
        'accept': _is.MethodConnector(
          name: 'accept',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'deckSaintIds': _is.ParameterDescription(
              name: 'deckSaintIds',
              type: _is.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).accept(
                session,
                params['duelId'],
                params['deckSaintIds'],
              ),
        ),
        'decline': _is.MethodConnector(
          name: 'decline',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).decline(
                session,
                params['duelId'],
              ),
        ),
        'myDuels': _is.MethodConnector(
          name: 'myDuels',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).myDuels(
                session,
              ),
        ),
        'view': _is.MethodConnector(
          name: 'view',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).view(
                session,
                params['duelId'],
              ),
        ),
        'attack': _is.MethodConnector(
          name: 'attack',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<_i9dy8bz4.ScoreCategory>(),
              nullable: false,
            ),
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).attack(
                session,
                params['duelId'],
                params['category'],
                params['saintId'],
              ),
        ),
        'defend': _is.MethodConnector(
          name: 'defend',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).defend(
                session,
                params['duelId'],
                params['saintId'],
              ),
        ),
        'answer': _is.MethodConnector(
          name: 'answer',
          params: {
            'duelId': _is.ParameterDescription(
              name: 'duelId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'chosenIndex': _is.ParameterDescription(
              name: 'chosenIndex',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['duel'] as _inwr4dl6.DuelEndpoint).answer(
                session,
                params['duelId'],
                params['chosenIndex'],
              ),
        ),
      },
    );
    connectors['litany'] = _is.EndpointConnector(
      name: 'litany',
      endpoint: endpoints['litany']!,
      methodConnectors: {
        'state': _is.MethodConnector(
          name: 'state',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['litany'] as _ir5yijij.LitanyEndpoint)
                  .state(session),
        ),
        'start': _is.MethodConnector(
          name: 'start',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['litany'] as _ir5yijij.LitanyEndpoint)
                  .start(session),
        ),
        'answer': _is.MethodConnector(
          name: 'answer',
          params: {
            'chosenIndex': _is.ParameterDescription(
              name: 'chosenIndex',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['litany'] as _ir5yijij.LitanyEndpoint).answer(
                    session,
                    params['chosenIndex'],
                  ),
        ),
        'next': _is.MethodConnector(
          name: 'next',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['litany'] as _ir5yijij.LitanyEndpoint).next(
                session,
              ),
        ),
        'giveUp': _is.MethodConnector(
          name: 'giveUp',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['litany'] as _ir5yijij.LitanyEndpoint)
                  .giveUp(session),
        ),
      },
    );
    connectors['quiz'] = _is.EndpointConnector(
      name: 'quiz',
      endpoint: endpoints['quiz']!,
      methodConnectors: {
        'today': _is.MethodConnector(
          name: 'today',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['quiz'] as _i9pu1r99.QuizEndpoint).today(session),
        ),
        'answer': _is.MethodConnector(
          name: 'answer',
          params: {
            'questionId': _is.ParameterDescription(
              name: 'questionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'chosenIndex': _is.ParameterDescription(
              name: 'chosenIndex',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['quiz'] as _i9pu1r99.QuizEndpoint).answer(
                session,
                params['questionId'],
                params['chosenIndex'],
              ),
        ),
      },
    );
    connectors['saint'] = _is.EndpointConnector(
      name: 'saint',
      endpoint: endpoints['saint']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['saint'] as _i0hn8dfu.SaintEndpoint).list(session),
        ),
        'detail': _is.MethodConnector(
          name: 'detail',
          params: {
            'saintId': _is.ParameterDescription(
              name: 'saintId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['saint'] as _i0hn8dfu.SaintEndpoint).detail(
                session,
                params['saintId'],
              ),
        ),
        'recentChanges': _is.MethodConnector(
          name: 'recentChanges',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['saint'] as _i0hn8dfu.SaintEndpoint)
                  .recentChanges(session),
        ),
      },
    );
    connectors['friends'] = _is.EndpointConnector(
      name: 'friends',
      endpoint: endpoints['friends']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint).me(
                session,
              ),
        ),
        'setDisplayName': _is.MethodConnector(
          name: 'setDisplayName',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint)
                  .setDisplayName(
                    session,
                    params['name'],
                  ),
        ),
        'addByCode': _is.MethodConnector(
          name: 'addByCode',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).addByCode(
                    session,
                    params['code'],
                  ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint)
                  .list(session),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'friendId': _is.ParameterDescription(
              name: 'friendId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['friends'] as _iejqgreb.FriendsEndpoint).remove(
                    session,
                    params['friendId'],
                  ),
        ),
        'collectionOf': _is.MethodConnector(
          name: 'collectionOf',
          params: {
            'friendId': _is.ParameterDescription(
              name: 'friendId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['friends'] as _iejqgreb.FriendsEndpoint)
                  .collectionOf(
                    session,
                    params['friendId'],
                  ),
        ),
      },
    );
    connectors['leaderboard'] = _is.EndpointConnector(
      name: 'leaderboard',
      endpoint: endpoints['leaderboard']!,
      methodConnectors: {
        'top': _is.MethodConnector(
          name: 'top',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['leaderboard'] as _i0n7rhey.LeaderboardEndpoint)
                      .top(session),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
