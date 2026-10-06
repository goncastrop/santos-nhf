/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:saints_nhf_server/src/generated/admin/admin_user.dart'
    as _ixvhhjbu;
import 'package:saints_nhf_server/src/generated/books/saint_book.dart'
    as _i3dacp34;
import 'package:saints_nhf_server/src/generated/codes/unlock_code.dart'
    as _igemr9nl;
import 'package:saints_nhf_server/src/generated/duel/duel_summary.dart'
    as _i55m6l7d;
import 'package:saints_nhf_server/src/generated/questions/question.dart'
    as _i00r6ooi;
import 'package:saints_nhf_server/src/generated/saints/patch_note_entry.dart'
    as _io38hsvh;
import 'package:saints_nhf_server/src/generated/saints/saint.dart' as _i6crwlsp;
import 'package:saints_nhf_server/src/generated/saints/saint_info.dart'
    as _ic7tcu9g;
import 'package:saints_nhf_server/src/generated/saints/saint_revision.dart'
    as _i6idv2va;
import 'package:saints_nhf_server/src/generated/social/friend_summary.dart'
    as _il0f7ire;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'admin/admin_access.dart' as _ihuj30ec;
import 'admin/admin_exception.dart' as _i6y36sdk;
import 'admin/admin_user.dart' as _iq8787bd;
import 'admin/import_report.dart' as _i1xhp4yx;
import 'books/book_kind.dart' as _i87hhyqb;
import 'books/saint_book.dart' as _ivh8ny1n;
import 'codes/unlock_code.dart' as _iyyfi4i1;
import 'codes/unlock_redemption.dart' as _i4uksn3k;
import 'collection/card_source.dart' as _iu9ms52k;
import 'collection/collected_card.dart' as _i7vp20ao;
import 'collection/collection_error.dart' as _iipqxuj0;
import 'collection/collection_error_code.dart' as _i1trhjm8;
import 'collection/collection_overview.dart' as _ifcmdtux;
import 'collection/daily_claim_result.dart' as _ingdabn4;
import 'collection/local_snapshot.dart' as _iuis7zid;
import 'collection/player_profile.dart' as _i2w8nphz;
import 'collection/user_saint_card.dart' as _igvftuig;
import 'duel/duel.dart' as _ik1dbiur;
import 'duel/duel_deck.dart' as _iu4yo7o5;
import 'duel/duel_exception.dart' as _iz847zbs;
import 'duel/duel_phase.dart' as _igih3ea9;
import 'duel/duel_round.dart' as _ih8y80e4;
import 'duel/duel_round_view.dart' as _izgr1lt8;
import 'duel/duel_signal.dart' as _it5t06fg;
import 'duel/duel_status.dart' as _iawu1v59;
import 'duel/duel_summary.dart' as _iqx58u4g;
import 'duel/duel_view.dart' as _inhuti79;
import 'future_calls_generated_models/live_future_call_close_question_model.dart'
    as _iy1bmzm3;
import 'future_calls_generated_models/live_future_call_open_question_model.dart'
    as _ithggvt0;
import 'litany/litany_exception.dart' as _ihfep1t2;
import 'litany/litany_run.dart' as _i0tq7vpz;
import 'litany/litany_view.dart' as _iyteid9u;
import 'live/live_answer.dart' as _is6i5ayg;
import 'live/live_exception.dart' as _iv5amj9z;
import 'live/live_game.dart' as _idyo08hd;
import 'live/live_me.dart' as _i0jiuvf7;
import 'live/live_phase.dart' as _itq2os4y;
import 'live/live_rank_entry.dart' as _ij4wbs4b;
import 'live/live_results.dart' as _i3ku2kox;
import 'live/live_signal.dart' as _inzp8g3i;
import 'live/live_view.dart' as _iiwgvz3h;
import 'live/live_winner.dart' as _ijb4qkzu;
import 'live/live_winner_view.dart' as _i0z8s1jl;
import 'questions/daily_quiz.dart' as _i0w8jnl1;
import 'questions/question.dart' as _ihstiddh;
import 'questions/question_seen.dart' as _iqz00a3b;
import 'questions/quiz_exception.dart' as _ilkzvlf7;
import 'questions/quiz_question.dart' as _icdqdbld;
import 'saints/patch_note_entry.dart' as _i3y4zho1;
import 'saints/saint.dart' as _iqo2xiq1;
import 'saints/saint_detail.dart' as _it9dn8v7;
import 'saints/saint_info.dart' as _iguva2up;
import 'saints/saint_revision.dart' as _igrhtj8i;
import 'saints/saint_scores.dart' as _i97g4q2x;
import 'saints/saint_status.dart' as _iaa1v1k9;
import 'saints/saint_title.dart' as _i85g2sm6;
import 'saints/score_category.dart' as _i1jf30yd;
import 'saints/score_change.dart' as _i1mhooeb;
import 'social/friend_collection.dart' as _igj8vqqd;
import 'social/friend_summary.dart' as _is15n45g;
import 'social/friendship.dart' as _i76eh3vl;
import 'social/leaderboard.dart' as _ijc0657k;
import 'social/leaderboard_entry.dart' as _i12nr32a;
import 'social/my_profile.dart' as _i9fi806u;
import 'social/social_exception.dart' as _ikp908ax;
export 'admin/admin_access.dart';
export 'admin/admin_exception.dart';
export 'admin/admin_user.dart';
export 'admin/import_report.dart';
export 'books/book_kind.dart';
export 'books/saint_book.dart';
export 'codes/unlock_code.dart';
export 'codes/unlock_redemption.dart';
export 'collection/card_source.dart';
export 'collection/collected_card.dart';
export 'collection/collection_error.dart';
export 'collection/collection_error_code.dart';
export 'collection/collection_overview.dart';
export 'collection/daily_claim_result.dart';
export 'collection/local_snapshot.dart';
export 'collection/player_profile.dart';
export 'collection/user_saint_card.dart';
export 'duel/duel.dart';
export 'duel/duel_deck.dart';
export 'duel/duel_exception.dart';
export 'duel/duel_phase.dart';
export 'duel/duel_round.dart';
export 'duel/duel_round_view.dart';
export 'duel/duel_signal.dart';
export 'duel/duel_status.dart';
export 'duel/duel_summary.dart';
export 'duel/duel_view.dart';
export 'litany/litany_exception.dart';
export 'litany/litany_run.dart';
export 'litany/litany_view.dart';
export 'live/live_answer.dart';
export 'live/live_exception.dart';
export 'live/live_game.dart';
export 'live/live_me.dart';
export 'live/live_phase.dart';
export 'live/live_rank_entry.dart';
export 'live/live_results.dart';
export 'live/live_signal.dart';
export 'live/live_view.dart';
export 'live/live_winner.dart';
export 'live/live_winner_view.dart';
export 'questions/daily_quiz.dart';
export 'questions/question.dart';
export 'questions/question_seen.dart';
export 'questions/quiz_exception.dart';
export 'questions/quiz_question.dart';
export 'saints/patch_note_entry.dart';
export 'saints/saint.dart';
export 'saints/saint_detail.dart';
export 'saints/saint_info.dart';
export 'saints/saint_revision.dart';
export 'saints/saint_scores.dart';
export 'saints/saint_status.dart';
export 'saints/saint_title.dart';
export 'saints/score_category.dart';
export 'saints/score_change.dart';
export 'social/friend_collection.dart';
export 'social/friend_summary.dart';
export 'social/friendship.dart';
export 'social/leaderboard.dart';
export 'social/leaderboard_entry.dart';
export 'social/my_profile.dart';
export 'social/social_exception.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'duel',
      dartName: 'Duel',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'challengerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'opponentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'isVsMachine',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DuelStatus',
          columnDefault: '\'pendingDeck\'',
        ),
        _isp.ColumnDefinition(
          name: 'roundNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'attackerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'turnOf',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'challengerScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'opponentScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'winnerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'duel_challenger_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'challengerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'duel_opponent_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'opponentId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duel_deck',
      dartName: 'DuelDeck',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'duelId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'playerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'saintIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'usedSaintIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'duel_deck_fk_0',
          columns: ['duelId'],
          referenceTable: 'duel',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'duel_deck_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'duelId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'playerId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duel_round',
      dartName: 'DuelRound',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'duelId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'roundNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ScoreCategory',
        ),
        _isp.ColumnDefinition(
          name: 'attackerId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'defenderId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'attackerSaintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'attackerQuestionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'attackerAnswerIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'attackerCorrect',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'defenderSaintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'defenderQuestionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'defenderAnswerIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'defenderCorrect',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'attackerScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'defenderScore',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'pointTo',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'resolved',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'duel_round_fk_0',
          columns: ['duelId'],
          referenceTable: 'duel',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'duel_round_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'duelId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'roundNumber',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'friendship',
      dartName: 'Friendship',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'playerA',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'playerB',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'friendship_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'playerA',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'playerB',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'friendship_b_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'playerB',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'litany_run',
      dartName: 'LitanyRun',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lives',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
        _isp.ColumnDefinition(
          name: 'score',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'streak',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'bestStreak',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'answered',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'correct',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'questionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'chosenIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'askedQuestionIds',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _isp.ColumnDefinition(
          name: 'finished',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'wasRecord',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'litany_run_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'live_answer',
      dartName: 'LiveAnswer',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'gameId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'questionIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'chosenIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'correct',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'points',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'elapsedMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'answeredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'live_answer_fk_0',
          columns: ['gameId'],
          referenceTable: 'live_game',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'live_answer_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'gameId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'questionIndex',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'live_game',
      dartName: 'LiveGame',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'questionIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<int>',
        ),
        _isp.ColumnDefinition(
          name: 'phase',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:LivePhase',
          columnDefault: '\'countdown\'',
        ),
        _isp.ColumnDefinition(
          name: 'currentIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'countdownTo',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'openedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'closesAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'questionSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
        _isp.ColumnDefinition(
          name: 'fastPrizes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'rafflePrizes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'results',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:LiveResults?',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'live_game_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'live_game_phase_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'phase',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'player_profile',
      dartName: 'PlayerProfile',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lastDailyClaimDay',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'starterGranted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'friendCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'quizDay',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'quizQuestionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'quizChosenIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'quizAnswered',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'lastCorrectDay',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'streak',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'bestStreak',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'totalAnswered',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'totalCorrect',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'pendingHand',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _isp.ColumnDefinition(
          name: 'duelsWon',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'duelsPlayed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'litanyBest',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'player_profile_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'player_profile_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'player_profile_friend_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'friendCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'question',
      dartName: 'Question',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'prompt',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'options',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'correctIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'question_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'question_saint_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'saintId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'question_seen',
      dartName: 'QuestionSeen',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'questionId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'seenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'question_seen_fk_0',
          columns: ['questionId'],
          referenceTable: 'question',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'question_seen_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'questionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'saint',
      dartName: 'Saint',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'titles',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SaintTitle>?',
        ),
        _isp.ColumnDefinition(
          name: 'feastMonth',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'feastDay',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'birthYear',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'birthApprox',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'deathYear',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'deathApprox',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'birthPlace',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'birthLat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'birthLng',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'deathPlace',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deathLat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'deathLng',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'bio',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'prayer',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'illustrationPath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'season',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'episode',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'youtubeUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SaintStatus',
          columnDefault: '\'draft\'',
        ),
        _isp.ColumnDefinition(
          name: 'catequesis',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'escritos',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'oracion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'patronazgos',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'evangelizacion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'viajes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '50',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'saint__slug__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'saint_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'saint_feast_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'feastMonth',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'feastDay',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'saint_death_year_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deathYear',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'saint_book',
      dartName: 'SaintBook',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'author',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BookKind',
        ),
        _isp.ColumnDefinition(
          name: 'year',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'publisher',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'url',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'position',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'saint_book_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'saint_book_saint_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'saintId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'saint_revision',
      dartName: 'SaintRevision',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'snapshotJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'changedByEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'changedByAuthUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'saint_revision_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'saint_revision_saint_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'saintId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'unlock_code',
      dartName: 'UnlockCode',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'maxUses',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'uses',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'unlock_code_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'unlock_code__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'unlock_redemption',
      dartName: 'UnlockRedemption',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'codeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'unlock_redemption_fk_0',
          columns: ['codeId'],
          referenceTable: 'unlock_code',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'unlock_redemption_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'codeId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_saint_card',
      dartName: 'UserSaintCard',
      schema: 'public',
      module: 'saints_nhf',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'saintId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CardSource',
        ),
        _isp.ColumnDefinition(
          name: 'obtainedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'user_saint_card_fk_0',
          columns: ['saintId'],
          referenceTable: 'saint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_saint_card_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'saintId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ihuj30ec.AdminAccess) {
      return _ihuj30ec.AdminAccess.fromJson(data) as T;
    }
    if (t == _i6y36sdk.AdminException) {
      return _i6y36sdk.AdminException.fromJson(data) as T;
    }
    if (t == _iq8787bd.AdminUser) {
      return _iq8787bd.AdminUser.fromJson(data) as T;
    }
    if (t == _i1xhp4yx.ImportReport) {
      return _i1xhp4yx.ImportReport.fromJson(data) as T;
    }
    if (t == _i87hhyqb.BookKind) {
      return _i87hhyqb.BookKind.fromJson(data) as T;
    }
    if (t == _ivh8ny1n.SaintBook) {
      return _ivh8ny1n.SaintBook.fromJson(data) as T;
    }
    if (t == _iyyfi4i1.UnlockCode) {
      return _iyyfi4i1.UnlockCode.fromJson(data) as T;
    }
    if (t == _i4uksn3k.UnlockRedemption) {
      return _i4uksn3k.UnlockRedemption.fromJson(data) as T;
    }
    if (t == _iu9ms52k.CardSource) {
      return _iu9ms52k.CardSource.fromJson(data) as T;
    }
    if (t == _i7vp20ao.CollectedCard) {
      return _i7vp20ao.CollectedCard.fromJson(data) as T;
    }
    if (t == _iipqxuj0.CollectionException) {
      return _iipqxuj0.CollectionException.fromJson(data) as T;
    }
    if (t == _i1trhjm8.CollectionErrorCode) {
      return _i1trhjm8.CollectionErrorCode.fromJson(data) as T;
    }
    if (t == _ifcmdtux.CollectionOverview) {
      return _ifcmdtux.CollectionOverview.fromJson(data) as T;
    }
    if (t == _ingdabn4.DailyClaimResult) {
      return _ingdabn4.DailyClaimResult.fromJson(data) as T;
    }
    if (t == _iuis7zid.LocalSnapshot) {
      return _iuis7zid.LocalSnapshot.fromJson(data) as T;
    }
    if (t == _i2w8nphz.PlayerProfile) {
      return _i2w8nphz.PlayerProfile.fromJson(data) as T;
    }
    if (t == _igvftuig.UserSaintCard) {
      return _igvftuig.UserSaintCard.fromJson(data) as T;
    }
    if (t == _ik1dbiur.Duel) {
      return _ik1dbiur.Duel.fromJson(data) as T;
    }
    if (t == _iu4yo7o5.DuelDeck) {
      return _iu4yo7o5.DuelDeck.fromJson(data) as T;
    }
    if (t == _iz847zbs.DuelException) {
      return _iz847zbs.DuelException.fromJson(data) as T;
    }
    if (t == _igih3ea9.DuelPhase) {
      return _igih3ea9.DuelPhase.fromJson(data) as T;
    }
    if (t == _ih8y80e4.DuelRound) {
      return _ih8y80e4.DuelRound.fromJson(data) as T;
    }
    if (t == _izgr1lt8.DuelRoundView) {
      return _izgr1lt8.DuelRoundView.fromJson(data) as T;
    }
    if (t == _it5t06fg.DuelSignal) {
      return _it5t06fg.DuelSignal.fromJson(data) as T;
    }
    if (t == _iawu1v59.DuelStatus) {
      return _iawu1v59.DuelStatus.fromJson(data) as T;
    }
    if (t == _iqx58u4g.DuelSummary) {
      return _iqx58u4g.DuelSummary.fromJson(data) as T;
    }
    if (t == _inhuti79.DuelView) {
      return _inhuti79.DuelView.fromJson(data) as T;
    }
    if (t == _iy1bmzm3.LiveFutureCallCloseQuestionModel) {
      return _iy1bmzm3.LiveFutureCallCloseQuestionModel.fromJson(data) as T;
    }
    if (t == _ithggvt0.LiveFutureCallOpenQuestionModel) {
      return _ithggvt0.LiveFutureCallOpenQuestionModel.fromJson(data) as T;
    }
    if (t == _ihfep1t2.LitanyException) {
      return _ihfep1t2.LitanyException.fromJson(data) as T;
    }
    if (t == _i0tq7vpz.LitanyRun) {
      return _i0tq7vpz.LitanyRun.fromJson(data) as T;
    }
    if (t == _iyteid9u.LitanyView) {
      return _iyteid9u.LitanyView.fromJson(data) as T;
    }
    if (t == _is6i5ayg.LiveAnswer) {
      return _is6i5ayg.LiveAnswer.fromJson(data) as T;
    }
    if (t == _iv5amj9z.LiveException) {
      return _iv5amj9z.LiveException.fromJson(data) as T;
    }
    if (t == _idyo08hd.LiveGame) {
      return _idyo08hd.LiveGame.fromJson(data) as T;
    }
    if (t == _i0jiuvf7.LiveMe) {
      return _i0jiuvf7.LiveMe.fromJson(data) as T;
    }
    if (t == _itq2os4y.LivePhase) {
      return _itq2os4y.LivePhase.fromJson(data) as T;
    }
    if (t == _ij4wbs4b.LiveRankEntry) {
      return _ij4wbs4b.LiveRankEntry.fromJson(data) as T;
    }
    if (t == _i3ku2kox.LiveResults) {
      return _i3ku2kox.LiveResults.fromJson(data) as T;
    }
    if (t == _inzp8g3i.LiveSignal) {
      return _inzp8g3i.LiveSignal.fromJson(data) as T;
    }
    if (t == _iiwgvz3h.LiveView) {
      return _iiwgvz3h.LiveView.fromJson(data) as T;
    }
    if (t == _ijb4qkzu.LiveWinner) {
      return _ijb4qkzu.LiveWinner.fromJson(data) as T;
    }
    if (t == _i0z8s1jl.LiveWinnerView) {
      return _i0z8s1jl.LiveWinnerView.fromJson(data) as T;
    }
    if (t == _i0w8jnl1.DailyQuiz) {
      return _i0w8jnl1.DailyQuiz.fromJson(data) as T;
    }
    if (t == _ihstiddh.Question) {
      return _ihstiddh.Question.fromJson(data) as T;
    }
    if (t == _iqz00a3b.QuestionSeen) {
      return _iqz00a3b.QuestionSeen.fromJson(data) as T;
    }
    if (t == _ilkzvlf7.QuizException) {
      return _ilkzvlf7.QuizException.fromJson(data) as T;
    }
    if (t == _icdqdbld.QuizQuestion) {
      return _icdqdbld.QuizQuestion.fromJson(data) as T;
    }
    if (t == _i3y4zho1.PatchNoteEntry) {
      return _i3y4zho1.PatchNoteEntry.fromJson(data) as T;
    }
    if (t == _iqo2xiq1.Saint) {
      return _iqo2xiq1.Saint.fromJson(data) as T;
    }
    if (t == _it9dn8v7.SaintDetail) {
      return _it9dn8v7.SaintDetail.fromJson(data) as T;
    }
    if (t == _iguva2up.SaintInfo) {
      return _iguva2up.SaintInfo.fromJson(data) as T;
    }
    if (t == _igrhtj8i.SaintRevision) {
      return _igrhtj8i.SaintRevision.fromJson(data) as T;
    }
    if (t == _i97g4q2x.SaintScores) {
      return _i97g4q2x.SaintScores.fromJson(data) as T;
    }
    if (t == _iaa1v1k9.SaintStatus) {
      return _iaa1v1k9.SaintStatus.fromJson(data) as T;
    }
    if (t == _i85g2sm6.SaintTitle) {
      return _i85g2sm6.SaintTitle.fromJson(data) as T;
    }
    if (t == _i1jf30yd.ScoreCategory) {
      return _i1jf30yd.ScoreCategory.fromJson(data) as T;
    }
    if (t == _i1mhooeb.ScoreChange) {
      return _i1mhooeb.ScoreChange.fromJson(data) as T;
    }
    if (t == _igj8vqqd.FriendCollection) {
      return _igj8vqqd.FriendCollection.fromJson(data) as T;
    }
    if (t == _is15n45g.FriendSummary) {
      return _is15n45g.FriendSummary.fromJson(data) as T;
    }
    if (t == _i76eh3vl.Friendship) {
      return _i76eh3vl.Friendship.fromJson(data) as T;
    }
    if (t == _ijc0657k.Leaderboard) {
      return _ijc0657k.Leaderboard.fromJson(data) as T;
    }
    if (t == _i12nr32a.LeaderboardEntry) {
      return _i12nr32a.LeaderboardEntry.fromJson(data) as T;
    }
    if (t == _i9fi806u.MyProfile) {
      return _i9fi806u.MyProfile.fromJson(data) as T;
    }
    if (t == _ikp908ax.SocialException) {
      return _ikp908ax.SocialException.fromJson(data) as T;
    }
    if (t == _is.getType<_ihuj30ec.AdminAccess?>()) {
      return (data != null ? _ihuj30ec.AdminAccess.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6y36sdk.AdminException?>()) {
      return (data != null ? _i6y36sdk.AdminException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq8787bd.AdminUser?>()) {
      return (data != null ? _iq8787bd.AdminUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1xhp4yx.ImportReport?>()) {
      return (data != null ? _i1xhp4yx.ImportReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i87hhyqb.BookKind?>()) {
      return (data != null ? _i87hhyqb.BookKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivh8ny1n.SaintBook?>()) {
      return (data != null ? _ivh8ny1n.SaintBook.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyyfi4i1.UnlockCode?>()) {
      return (data != null ? _iyyfi4i1.UnlockCode.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4uksn3k.UnlockRedemption?>()) {
      return (data != null ? _i4uksn3k.UnlockRedemption.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu9ms52k.CardSource?>()) {
      return (data != null ? _iu9ms52k.CardSource.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7vp20ao.CollectedCard?>()) {
      return (data != null ? _i7vp20ao.CollectedCard.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iipqxuj0.CollectionException?>()) {
      return (data != null
              ? _iipqxuj0.CollectionException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1trhjm8.CollectionErrorCode?>()) {
      return (data != null
              ? _i1trhjm8.CollectionErrorCode.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifcmdtux.CollectionOverview?>()) {
      return (data != null ? _ifcmdtux.CollectionOverview.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ingdabn4.DailyClaimResult?>()) {
      return (data != null ? _ingdabn4.DailyClaimResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuis7zid.LocalSnapshot?>()) {
      return (data != null ? _iuis7zid.LocalSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2w8nphz.PlayerProfile?>()) {
      return (data != null ? _i2w8nphz.PlayerProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igvftuig.UserSaintCard?>()) {
      return (data != null ? _igvftuig.UserSaintCard.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ik1dbiur.Duel?>()) {
      return (data != null ? _ik1dbiur.Duel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu4yo7o5.DuelDeck?>()) {
      return (data != null ? _iu4yo7o5.DuelDeck.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz847zbs.DuelException?>()) {
      return (data != null ? _iz847zbs.DuelException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igih3ea9.DuelPhase?>()) {
      return (data != null ? _igih3ea9.DuelPhase.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ih8y80e4.DuelRound?>()) {
      return (data != null ? _ih8y80e4.DuelRound.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izgr1lt8.DuelRoundView?>()) {
      return (data != null ? _izgr1lt8.DuelRoundView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it5t06fg.DuelSignal?>()) {
      return (data != null ? _it5t06fg.DuelSignal.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iawu1v59.DuelStatus?>()) {
      return (data != null ? _iawu1v59.DuelStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqx58u4g.DuelSummary?>()) {
      return (data != null ? _iqx58u4g.DuelSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inhuti79.DuelView?>()) {
      return (data != null ? _inhuti79.DuelView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iy1bmzm3.LiveFutureCallCloseQuestionModel?>()) {
      return (data != null
              ? _iy1bmzm3.LiveFutureCallCloseQuestionModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ithggvt0.LiveFutureCallOpenQuestionModel?>()) {
      return (data != null
              ? _ithggvt0.LiveFutureCallOpenQuestionModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihfep1t2.LitanyException?>()) {
      return (data != null ? _ihfep1t2.LitanyException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0tq7vpz.LitanyRun?>()) {
      return (data != null ? _i0tq7vpz.LitanyRun.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyteid9u.LitanyView?>()) {
      return (data != null ? _iyteid9u.LitanyView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_is6i5ayg.LiveAnswer?>()) {
      return (data != null ? _is6i5ayg.LiveAnswer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv5amj9z.LiveException?>()) {
      return (data != null ? _iv5amj9z.LiveException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idyo08hd.LiveGame?>()) {
      return (data != null ? _idyo08hd.LiveGame.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0jiuvf7.LiveMe?>()) {
      return (data != null ? _i0jiuvf7.LiveMe.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itq2os4y.LivePhase?>()) {
      return (data != null ? _itq2os4y.LivePhase.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ij4wbs4b.LiveRankEntry?>()) {
      return (data != null ? _ij4wbs4b.LiveRankEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i3ku2kox.LiveResults?>()) {
      return (data != null ? _i3ku2kox.LiveResults.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inzp8g3i.LiveSignal?>()) {
      return (data != null ? _inzp8g3i.LiveSignal.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiwgvz3h.LiveView?>()) {
      return (data != null ? _iiwgvz3h.LiveView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijb4qkzu.LiveWinner?>()) {
      return (data != null ? _ijb4qkzu.LiveWinner.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0z8s1jl.LiveWinnerView?>()) {
      return (data != null ? _i0z8s1jl.LiveWinnerView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0w8jnl1.DailyQuiz?>()) {
      return (data != null ? _i0w8jnl1.DailyQuiz.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihstiddh.Question?>()) {
      return (data != null ? _ihstiddh.Question.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqz00a3b.QuestionSeen?>()) {
      return (data != null ? _iqz00a3b.QuestionSeen.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilkzvlf7.QuizException?>()) {
      return (data != null ? _ilkzvlf7.QuizException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icdqdbld.QuizQuestion?>()) {
      return (data != null ? _icdqdbld.QuizQuestion.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3y4zho1.PatchNoteEntry?>()) {
      return (data != null ? _i3y4zho1.PatchNoteEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqo2xiq1.Saint?>()) {
      return (data != null ? _iqo2xiq1.Saint.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_it9dn8v7.SaintDetail?>()) {
      return (data != null ? _it9dn8v7.SaintDetail.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iguva2up.SaintInfo?>()) {
      return (data != null ? _iguva2up.SaintInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igrhtj8i.SaintRevision?>()) {
      return (data != null ? _igrhtj8i.SaintRevision.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i97g4q2x.SaintScores?>()) {
      return (data != null ? _i97g4q2x.SaintScores.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaa1v1k9.SaintStatus?>()) {
      return (data != null ? _iaa1v1k9.SaintStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i85g2sm6.SaintTitle?>()) {
      return (data != null ? _i85g2sm6.SaintTitle.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1jf30yd.ScoreCategory?>()) {
      return (data != null ? _i1jf30yd.ScoreCategory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1mhooeb.ScoreChange?>()) {
      return (data != null ? _i1mhooeb.ScoreChange.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igj8vqqd.FriendCollection?>()) {
      return (data != null ? _igj8vqqd.FriendCollection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is15n45g.FriendSummary?>()) {
      return (data != null ? _is15n45g.FriendSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i76eh3vl.Friendship?>()) {
      return (data != null ? _i76eh3vl.Friendship.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijc0657k.Leaderboard?>()) {
      return (data != null ? _ijc0657k.Leaderboard.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i12nr32a.LeaderboardEntry?>()) {
      return (data != null ? _i12nr32a.LeaderboardEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9fi806u.MyProfile?>()) {
      return (data != null ? _i9fi806u.MyProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikp908ax.SocialException?>()) {
      return (data != null ? _ikp908ax.SocialException.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i7vp20ao.CollectedCard>) {
      return (data as List)
              .map((e) => deserialize<_i7vp20ao.CollectedCard>(e))
              .toList()
          as T;
    }
    if (t == List<_iguva2up.SaintInfo>) {
      return (data as List)
              .map((e) => deserialize<_iguva2up.SaintInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i3y4zho1.PatchNoteEntry>) {
      return (data as List)
              .map((e) => deserialize<_i3y4zho1.PatchNoteEntry>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i1jf30yd.ScoreCategory>) {
      return (data as List)
              .map((e) => deserialize<_i1jf30yd.ScoreCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_izgr1lt8.DuelRoundView>) {
      return (data as List)
              .map((e) => deserialize<_izgr1lt8.DuelRoundView>(e))
              .toList()
          as T;
    }
    if (t == List<_ijb4qkzu.LiveWinner>) {
      return (data as List)
              .map((e) => deserialize<_ijb4qkzu.LiveWinner>(e))
              .toList()
          as T;
    }
    if (t == List<_ij4wbs4b.LiveRankEntry>) {
      return (data as List)
              .map((e) => deserialize<_ij4wbs4b.LiveRankEntry>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ij4wbs4b.LiveRankEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ij4wbs4b.LiveRankEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i0z8s1jl.LiveWinnerView>) {
      return (data as List)
              .map((e) => deserialize<_i0z8s1jl.LiveWinnerView>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i0z8s1jl.LiveWinnerView>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i0z8s1jl.LiveWinnerView>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i1mhooeb.ScoreChange>) {
      return (data as List)
              .map((e) => deserialize<_i1mhooeb.ScoreChange>(e))
              .toList()
          as T;
    }
    if (t == List<_i85g2sm6.SaintTitle>) {
      return (data as List)
              .map((e) => deserialize<_i85g2sm6.SaintTitle>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i85g2sm6.SaintTitle>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i85g2sm6.SaintTitle>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ivh8ny1n.SaintBook>) {
      return (data as List)
              .map((e) => deserialize<_ivh8ny1n.SaintBook>(e))
              .toList()
          as T;
    }
    if (t == List<_i12nr32a.LeaderboardEntry>) {
      return (data as List)
              .map((e) => deserialize<_i12nr32a.LeaderboardEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i3dacp34.SaintBook>) {
      return (data as List)
              .map((e) => deserialize<_i3dacp34.SaintBook>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_igemr9nl.UnlockCode>) {
      return (data as List)
              .map((e) => deserialize<_igemr9nl.UnlockCode>(e))
              .toList()
          as T;
    }
    if (t == List<_i00r6ooi.Question>) {
      return (data as List)
              .map((e) => deserialize<_i00r6ooi.Question>(e))
              .toList()
          as T;
    }
    if (t == List<_i6crwlsp.Saint>) {
      return (data as List).map((e) => deserialize<_i6crwlsp.Saint>(e)).toList()
          as T;
    }
    if (t == List<_i6idv2va.SaintRevision>) {
      return (data as List)
              .map((e) => deserialize<_i6idv2va.SaintRevision>(e))
              .toList()
          as T;
    }
    if (t == List<_ixvhhjbu.AdminUser>) {
      return (data as List)
              .map((e) => deserialize<_ixvhhjbu.AdminUser>(e))
              .toList()
          as T;
    }
    if (t == List<_i55m6l7d.DuelSummary>) {
      return (data as List)
              .map((e) => deserialize<_i55m6l7d.DuelSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ic7tcu9g.SaintInfo>) {
      return (data as List)
              .map((e) => deserialize<_ic7tcu9g.SaintInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_io38hsvh.PatchNoteEntry>) {
      return (data as List)
              .map((e) => deserialize<_io38hsvh.PatchNoteEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_il0f7ire.FriendSummary>) {
      return (data as List)
              .map((e) => deserialize<_il0f7ire.FriendSummary>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ihuj30ec.AdminAccess => 'AdminAccess',
      _i6y36sdk.AdminException => 'AdminException',
      _iq8787bd.AdminUser => 'AdminUser',
      _i1xhp4yx.ImportReport => 'ImportReport',
      _i87hhyqb.BookKind => 'BookKind',
      _ivh8ny1n.SaintBook => 'SaintBook',
      _iyyfi4i1.UnlockCode => 'UnlockCode',
      _i4uksn3k.UnlockRedemption => 'UnlockRedemption',
      _iu9ms52k.CardSource => 'CardSource',
      _i7vp20ao.CollectedCard => 'CollectedCard',
      _iipqxuj0.CollectionException => 'CollectionException',
      _i1trhjm8.CollectionErrorCode => 'CollectionErrorCode',
      _ifcmdtux.CollectionOverview => 'CollectionOverview',
      _ingdabn4.DailyClaimResult => 'DailyClaimResult',
      _iuis7zid.LocalSnapshot => 'LocalSnapshot',
      _i2w8nphz.PlayerProfile => 'PlayerProfile',
      _igvftuig.UserSaintCard => 'UserSaintCard',
      _ik1dbiur.Duel => 'Duel',
      _iu4yo7o5.DuelDeck => 'DuelDeck',
      _iz847zbs.DuelException => 'DuelException',
      _igih3ea9.DuelPhase => 'DuelPhase',
      _ih8y80e4.DuelRound => 'DuelRound',
      _izgr1lt8.DuelRoundView => 'DuelRoundView',
      _it5t06fg.DuelSignal => 'DuelSignal',
      _iawu1v59.DuelStatus => 'DuelStatus',
      _iqx58u4g.DuelSummary => 'DuelSummary',
      _inhuti79.DuelView => 'DuelView',
      _iy1bmzm3.LiveFutureCallCloseQuestionModel =>
        'LiveFutureCallCloseQuestionModel',
      _ithggvt0.LiveFutureCallOpenQuestionModel =>
        'LiveFutureCallOpenQuestionModel',
      _ihfep1t2.LitanyException => 'LitanyException',
      _i0tq7vpz.LitanyRun => 'LitanyRun',
      _iyteid9u.LitanyView => 'LitanyView',
      _is6i5ayg.LiveAnswer => 'LiveAnswer',
      _iv5amj9z.LiveException => 'LiveException',
      _idyo08hd.LiveGame => 'LiveGame',
      _i0jiuvf7.LiveMe => 'LiveMe',
      _itq2os4y.LivePhase => 'LivePhase',
      _ij4wbs4b.LiveRankEntry => 'LiveRankEntry',
      _i3ku2kox.LiveResults => 'LiveResults',
      _inzp8g3i.LiveSignal => 'LiveSignal',
      _iiwgvz3h.LiveView => 'LiveView',
      _ijb4qkzu.LiveWinner => 'LiveWinner',
      _i0z8s1jl.LiveWinnerView => 'LiveWinnerView',
      _i0w8jnl1.DailyQuiz => 'DailyQuiz',
      _ihstiddh.Question => 'Question',
      _iqz00a3b.QuestionSeen => 'QuestionSeen',
      _ilkzvlf7.QuizException => 'QuizException',
      _icdqdbld.QuizQuestion => 'QuizQuestion',
      _i3y4zho1.PatchNoteEntry => 'PatchNoteEntry',
      _iqo2xiq1.Saint => 'Saint',
      _it9dn8v7.SaintDetail => 'SaintDetail',
      _iguva2up.SaintInfo => 'SaintInfo',
      _igrhtj8i.SaintRevision => 'SaintRevision',
      _i97g4q2x.SaintScores => 'SaintScores',
      _iaa1v1k9.SaintStatus => 'SaintStatus',
      _i85g2sm6.SaintTitle => 'SaintTitle',
      _i1jf30yd.ScoreCategory => 'ScoreCategory',
      _i1mhooeb.ScoreChange => 'ScoreChange',
      _igj8vqqd.FriendCollection => 'FriendCollection',
      _is15n45g.FriendSummary => 'FriendSummary',
      _i76eh3vl.Friendship => 'Friendship',
      _ijc0657k.Leaderboard => 'Leaderboard',
      _i12nr32a.LeaderboardEntry => 'LeaderboardEntry',
      _i9fi806u.MyProfile => 'MyProfile',
      _ikp908ax.SocialException => 'SocialException',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('saints_nhf.', '');
    }

    switch (data) {
      case _ihuj30ec.AdminAccess():
        return 'AdminAccess';
      case _i6y36sdk.AdminException():
        return 'AdminException';
      case _iq8787bd.AdminUser():
        return 'AdminUser';
      case _i1xhp4yx.ImportReport():
        return 'ImportReport';
      case _i87hhyqb.BookKind():
        return 'BookKind';
      case _ivh8ny1n.SaintBook():
        return 'SaintBook';
      case _iyyfi4i1.UnlockCode():
        return 'UnlockCode';
      case _i4uksn3k.UnlockRedemption():
        return 'UnlockRedemption';
      case _iu9ms52k.CardSource():
        return 'CardSource';
      case _i7vp20ao.CollectedCard():
        return 'CollectedCard';
      case _iipqxuj0.CollectionException():
        return 'CollectionException';
      case _i1trhjm8.CollectionErrorCode():
        return 'CollectionErrorCode';
      case _ifcmdtux.CollectionOverview():
        return 'CollectionOverview';
      case _ingdabn4.DailyClaimResult():
        return 'DailyClaimResult';
      case _iuis7zid.LocalSnapshot():
        return 'LocalSnapshot';
      case _i2w8nphz.PlayerProfile():
        return 'PlayerProfile';
      case _igvftuig.UserSaintCard():
        return 'UserSaintCard';
      case _ik1dbiur.Duel():
        return 'Duel';
      case _iu4yo7o5.DuelDeck():
        return 'DuelDeck';
      case _iz847zbs.DuelException():
        return 'DuelException';
      case _igih3ea9.DuelPhase():
        return 'DuelPhase';
      case _ih8y80e4.DuelRound():
        return 'DuelRound';
      case _izgr1lt8.DuelRoundView():
        return 'DuelRoundView';
      case _it5t06fg.DuelSignal():
        return 'DuelSignal';
      case _iawu1v59.DuelStatus():
        return 'DuelStatus';
      case _iqx58u4g.DuelSummary():
        return 'DuelSummary';
      case _inhuti79.DuelView():
        return 'DuelView';
      case _iy1bmzm3.LiveFutureCallCloseQuestionModel():
        return 'LiveFutureCallCloseQuestionModel';
      case _ithggvt0.LiveFutureCallOpenQuestionModel():
        return 'LiveFutureCallOpenQuestionModel';
      case _ihfep1t2.LitanyException():
        return 'LitanyException';
      case _i0tq7vpz.LitanyRun():
        return 'LitanyRun';
      case _iyteid9u.LitanyView():
        return 'LitanyView';
      case _is6i5ayg.LiveAnswer():
        return 'LiveAnswer';
      case _iv5amj9z.LiveException():
        return 'LiveException';
      case _idyo08hd.LiveGame():
        return 'LiveGame';
      case _i0jiuvf7.LiveMe():
        return 'LiveMe';
      case _itq2os4y.LivePhase():
        return 'LivePhase';
      case _ij4wbs4b.LiveRankEntry():
        return 'LiveRankEntry';
      case _i3ku2kox.LiveResults():
        return 'LiveResults';
      case _inzp8g3i.LiveSignal():
        return 'LiveSignal';
      case _iiwgvz3h.LiveView():
        return 'LiveView';
      case _ijb4qkzu.LiveWinner():
        return 'LiveWinner';
      case _i0z8s1jl.LiveWinnerView():
        return 'LiveWinnerView';
      case _i0w8jnl1.DailyQuiz():
        return 'DailyQuiz';
      case _ihstiddh.Question():
        return 'Question';
      case _iqz00a3b.QuestionSeen():
        return 'QuestionSeen';
      case _ilkzvlf7.QuizException():
        return 'QuizException';
      case _icdqdbld.QuizQuestion():
        return 'QuizQuestion';
      case _i3y4zho1.PatchNoteEntry():
        return 'PatchNoteEntry';
      case _iqo2xiq1.Saint():
        return 'Saint';
      case _it9dn8v7.SaintDetail():
        return 'SaintDetail';
      case _iguva2up.SaintInfo():
        return 'SaintInfo';
      case _igrhtj8i.SaintRevision():
        return 'SaintRevision';
      case _i97g4q2x.SaintScores():
        return 'SaintScores';
      case _iaa1v1k9.SaintStatus():
        return 'SaintStatus';
      case _i85g2sm6.SaintTitle():
        return 'SaintTitle';
      case _i1jf30yd.ScoreCategory():
        return 'ScoreCategory';
      case _i1mhooeb.ScoreChange():
        return 'ScoreChange';
      case _igj8vqqd.FriendCollection():
        return 'FriendCollection';
      case _is15n45g.FriendSummary():
        return 'FriendSummary';
      case _i76eh3vl.Friendship():
        return 'Friendship';
      case _ijc0657k.Leaderboard():
        return 'Leaderboard';
      case _i12nr32a.LeaderboardEntry():
        return 'LeaderboardEntry';
      case _i9fi806u.MyProfile():
        return 'MyProfile';
      case _ikp908ax.SocialException():
        return 'SocialException';
    }
    if (data is List<_i55m6l7d.DuelSummary>) {
      return 'List<DuelSummary>';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminAccess') {
      return deserialize<_ihuj30ec.AdminAccess>(data['data']);
    }
    if (dataClassName == 'AdminException') {
      return deserialize<_i6y36sdk.AdminException>(data['data']);
    }
    if (dataClassName == 'AdminUser') {
      return deserialize<_iq8787bd.AdminUser>(data['data']);
    }
    if (dataClassName == 'ImportReport') {
      return deserialize<_i1xhp4yx.ImportReport>(data['data']);
    }
    if (dataClassName == 'BookKind') {
      return deserialize<_i87hhyqb.BookKind>(data['data']);
    }
    if (dataClassName == 'SaintBook') {
      return deserialize<_ivh8ny1n.SaintBook>(data['data']);
    }
    if (dataClassName == 'UnlockCode') {
      return deserialize<_iyyfi4i1.UnlockCode>(data['data']);
    }
    if (dataClassName == 'UnlockRedemption') {
      return deserialize<_i4uksn3k.UnlockRedemption>(data['data']);
    }
    if (dataClassName == 'CardSource') {
      return deserialize<_iu9ms52k.CardSource>(data['data']);
    }
    if (dataClassName == 'CollectedCard') {
      return deserialize<_i7vp20ao.CollectedCard>(data['data']);
    }
    if (dataClassName == 'CollectionException') {
      return deserialize<_iipqxuj0.CollectionException>(data['data']);
    }
    if (dataClassName == 'CollectionErrorCode') {
      return deserialize<_i1trhjm8.CollectionErrorCode>(data['data']);
    }
    if (dataClassName == 'CollectionOverview') {
      return deserialize<_ifcmdtux.CollectionOverview>(data['data']);
    }
    if (dataClassName == 'DailyClaimResult') {
      return deserialize<_ingdabn4.DailyClaimResult>(data['data']);
    }
    if (dataClassName == 'LocalSnapshot') {
      return deserialize<_iuis7zid.LocalSnapshot>(data['data']);
    }
    if (dataClassName == 'PlayerProfile') {
      return deserialize<_i2w8nphz.PlayerProfile>(data['data']);
    }
    if (dataClassName == 'UserSaintCard') {
      return deserialize<_igvftuig.UserSaintCard>(data['data']);
    }
    if (dataClassName == 'Duel') {
      return deserialize<_ik1dbiur.Duel>(data['data']);
    }
    if (dataClassName == 'DuelDeck') {
      return deserialize<_iu4yo7o5.DuelDeck>(data['data']);
    }
    if (dataClassName == 'DuelException') {
      return deserialize<_iz847zbs.DuelException>(data['data']);
    }
    if (dataClassName == 'DuelPhase') {
      return deserialize<_igih3ea9.DuelPhase>(data['data']);
    }
    if (dataClassName == 'DuelRound') {
      return deserialize<_ih8y80e4.DuelRound>(data['data']);
    }
    if (dataClassName == 'DuelRoundView') {
      return deserialize<_izgr1lt8.DuelRoundView>(data['data']);
    }
    if (dataClassName == 'DuelSignal') {
      return deserialize<_it5t06fg.DuelSignal>(data['data']);
    }
    if (dataClassName == 'DuelStatus') {
      return deserialize<_iawu1v59.DuelStatus>(data['data']);
    }
    if (dataClassName == 'DuelSummary') {
      return deserialize<_iqx58u4g.DuelSummary>(data['data']);
    }
    if (dataClassName == 'DuelView') {
      return deserialize<_inhuti79.DuelView>(data['data']);
    }
    if (dataClassName == 'LiveFutureCallCloseQuestionModel') {
      return deserialize<_iy1bmzm3.LiveFutureCallCloseQuestionModel>(
        data['data'],
      );
    }
    if (dataClassName == 'LiveFutureCallOpenQuestionModel') {
      return deserialize<_ithggvt0.LiveFutureCallOpenQuestionModel>(
        data['data'],
      );
    }
    if (dataClassName == 'LitanyException') {
      return deserialize<_ihfep1t2.LitanyException>(data['data']);
    }
    if (dataClassName == 'LitanyRun') {
      return deserialize<_i0tq7vpz.LitanyRun>(data['data']);
    }
    if (dataClassName == 'LitanyView') {
      return deserialize<_iyteid9u.LitanyView>(data['data']);
    }
    if (dataClassName == 'LiveAnswer') {
      return deserialize<_is6i5ayg.LiveAnswer>(data['data']);
    }
    if (dataClassName == 'LiveException') {
      return deserialize<_iv5amj9z.LiveException>(data['data']);
    }
    if (dataClassName == 'LiveGame') {
      return deserialize<_idyo08hd.LiveGame>(data['data']);
    }
    if (dataClassName == 'LiveMe') {
      return deserialize<_i0jiuvf7.LiveMe>(data['data']);
    }
    if (dataClassName == 'LivePhase') {
      return deserialize<_itq2os4y.LivePhase>(data['data']);
    }
    if (dataClassName == 'LiveRankEntry') {
      return deserialize<_ij4wbs4b.LiveRankEntry>(data['data']);
    }
    if (dataClassName == 'LiveResults') {
      return deserialize<_i3ku2kox.LiveResults>(data['data']);
    }
    if (dataClassName == 'LiveSignal') {
      return deserialize<_inzp8g3i.LiveSignal>(data['data']);
    }
    if (dataClassName == 'LiveView') {
      return deserialize<_iiwgvz3h.LiveView>(data['data']);
    }
    if (dataClassName == 'LiveWinner') {
      return deserialize<_ijb4qkzu.LiveWinner>(data['data']);
    }
    if (dataClassName == 'LiveWinnerView') {
      return deserialize<_i0z8s1jl.LiveWinnerView>(data['data']);
    }
    if (dataClassName == 'DailyQuiz') {
      return deserialize<_i0w8jnl1.DailyQuiz>(data['data']);
    }
    if (dataClassName == 'Question') {
      return deserialize<_ihstiddh.Question>(data['data']);
    }
    if (dataClassName == 'QuestionSeen') {
      return deserialize<_iqz00a3b.QuestionSeen>(data['data']);
    }
    if (dataClassName == 'QuizException') {
      return deserialize<_ilkzvlf7.QuizException>(data['data']);
    }
    if (dataClassName == 'QuizQuestion') {
      return deserialize<_icdqdbld.QuizQuestion>(data['data']);
    }
    if (dataClassName == 'PatchNoteEntry') {
      return deserialize<_i3y4zho1.PatchNoteEntry>(data['data']);
    }
    if (dataClassName == 'Saint') {
      return deserialize<_iqo2xiq1.Saint>(data['data']);
    }
    if (dataClassName == 'SaintDetail') {
      return deserialize<_it9dn8v7.SaintDetail>(data['data']);
    }
    if (dataClassName == 'SaintInfo') {
      return deserialize<_iguva2up.SaintInfo>(data['data']);
    }
    if (dataClassName == 'SaintRevision') {
      return deserialize<_igrhtj8i.SaintRevision>(data['data']);
    }
    if (dataClassName == 'SaintScores') {
      return deserialize<_i97g4q2x.SaintScores>(data['data']);
    }
    if (dataClassName == 'SaintStatus') {
      return deserialize<_iaa1v1k9.SaintStatus>(data['data']);
    }
    if (dataClassName == 'SaintTitle') {
      return deserialize<_i85g2sm6.SaintTitle>(data['data']);
    }
    if (dataClassName == 'ScoreCategory') {
      return deserialize<_i1jf30yd.ScoreCategory>(data['data']);
    }
    if (dataClassName == 'ScoreChange') {
      return deserialize<_i1mhooeb.ScoreChange>(data['data']);
    }
    if (dataClassName == 'FriendCollection') {
      return deserialize<_igj8vqqd.FriendCollection>(data['data']);
    }
    if (dataClassName == 'FriendSummary') {
      return deserialize<_is15n45g.FriendSummary>(data['data']);
    }
    if (dataClassName == 'Friendship') {
      return deserialize<_i76eh3vl.Friendship>(data['data']);
    }
    if (dataClassName == 'Leaderboard') {
      return deserialize<_ijc0657k.Leaderboard>(data['data']);
    }
    if (dataClassName == 'LeaderboardEntry') {
      return deserialize<_i12nr32a.LeaderboardEntry>(data['data']);
    }
    if (dataClassName == 'MyProfile') {
      return deserialize<_i9fi806u.MyProfile>(data['data']);
    }
    if (dataClassName == 'SocialException') {
      return deserialize<_ikp908ax.SocialException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<DuelSummary>') {
      return deserialize<List<_i55m6l7d.DuelSummary>>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('saints_nhf', this);
    _iacs.Protocol().registerHostProtocol('saints_nhf', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ivh8ny1n.SaintBook:
        return _ivh8ny1n.SaintBook.t;
      case _iyyfi4i1.UnlockCode:
        return _iyyfi4i1.UnlockCode.t;
      case _i4uksn3k.UnlockRedemption:
        return _i4uksn3k.UnlockRedemption.t;
      case _i2w8nphz.PlayerProfile:
        return _i2w8nphz.PlayerProfile.t;
      case _igvftuig.UserSaintCard:
        return _igvftuig.UserSaintCard.t;
      case _ik1dbiur.Duel:
        return _ik1dbiur.Duel.t;
      case _iu4yo7o5.DuelDeck:
        return _iu4yo7o5.DuelDeck.t;
      case _ih8y80e4.DuelRound:
        return _ih8y80e4.DuelRound.t;
      case _i0tq7vpz.LitanyRun:
        return _i0tq7vpz.LitanyRun.t;
      case _is6i5ayg.LiveAnswer:
        return _is6i5ayg.LiveAnswer.t;
      case _idyo08hd.LiveGame:
        return _idyo08hd.LiveGame.t;
      case _ihstiddh.Question:
        return _ihstiddh.Question.t;
      case _iqz00a3b.QuestionSeen:
        return _iqz00a3b.QuestionSeen.t;
      case _iqo2xiq1.Saint:
        return _iqo2xiq1.Saint.t;
      case _igrhtj8i.SaintRevision:
        return _igrhtj8i.SaintRevision.t;
      case _i76eh3vl.Friendship:
        return _i76eh3vl.Friendship.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'saints_nhf';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }

  /// Maps container types (like [List], [Map], [Set]) containing
  /// [Record]s or non-String-keyed [Map]s to their JSON representation.
  ///
  /// It should not be called for [SerializableModel] types. These
  /// handle the "[Record] in container" mapping internally already.
  ///
  /// It is only supposed to be called from generated protocol code.
  ///
  /// Returns either a `List<dynamic>` (for List, Sets, and Maps with
  /// non-String keys) or a `Map<String, dynamic>` in case the input was
  /// a `Map<String, …>`.
  Object? mapContainerToJson(Object obj) {
    if (obj is! Iterable && obj is! Map) {
      throw ArgumentError.value(
        obj,
        'obj',
        'The object to serialize should be of type List, Map, or Set',
      );
    }

    dynamic mapIfNeeded(Object? obj) {
      return switch (obj) {
        Record record => mapRecordToJson(record),
        Iterable iterable => mapContainerToJson(iterable),
        Map map => mapContainerToJson(map),
        Object? value => value,
      };
    }

    switch (obj) {
      case Map<String, dynamic>():
        return {
          for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
        };
      case Map():
        return [
          for (var entry in obj.entries)
            {
              'k': mapIfNeeded(entry.key),
              'v': mapIfNeeded(entry.value),
            },
        ];

      case Iterable():
        return [
          for (var e in obj) mapIfNeeded(e),
        ];
    }

    return obj;
  }
}
