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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../books/book_kind.dart' as _idzj8z5t;

/// A book recommended on a saint's page: either one they wrote or one written
/// about them. Public, like the rest of the saint's content.
abstract class SaintBook
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SaintBook._({
    this.id,
    required this.saintId,
    required this.title,
    this.author,
    required this.kind,
    this.year,
    this.publisher,
    this.note,
    this.url,
    int? position,
    DateTime? createdAt,
  }) : position = position ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory SaintBook({
    int? id,
    required int saintId,
    required String title,
    String? author,
    required _idzj8z5t.BookKind kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  }) = _SaintBookImpl;

  factory SaintBook.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintBook(
      id: jsonSerialization['id'] as int?,
      saintId: jsonSerialization['saintId'] as int,
      title: jsonSerialization['title'] as String,
      author: jsonSerialization['author'] as String?,
      kind: _idzj8z5t.BookKind.fromJson((jsonSerialization['kind'] as String)),
      year: jsonSerialization['year'] as int?,
      publisher: jsonSerialization['publisher'] as String?,
      note: jsonSerialization['note'] as String?,
      url: jsonSerialization['url'] as String?,
      position: jsonSerialization['position'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int saintId;

  String title;

  /// Author, e.g. "Marcelle Auclair". Empty for the saint's own works.
  String? author;

  _idzj8z5t.BookKind kind;

  /// Year of writing or of the edition recommended.
  int? year;

  String? publisher;

  /// Why it is worth reading, one or two sentences.
  String? note;

  /// Where to read or get it.
  String? url;

  /// Order within its group, lowest first.
  int position;

  DateTime createdAt;

  /// Returns a shallow copy of this [SaintBook]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SaintBook copyWith({
    int? id,
    int? saintId,
    String? title,
    String? author,
    _idzj8z5t.BookKind? kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintBook',
      if (id != null) 'id': id,
      'saintId': saintId,
      'title': title,
      if (author != null) 'author': author,
      'kind': kind.toJson(),
      if (year != null) 'year': year,
      if (publisher != null) 'publisher': publisher,
      if (note != null) 'note': note,
      if (url != null) 'url': url,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintBook',
      if (id != null) 'id': id,
      'saintId': saintId,
      'title': title,
      if (author != null) 'author': author,
      'kind': kind.toJson(),
      if (year != null) 'year': year,
      if (publisher != null) 'publisher': publisher,
      if (note != null) 'note': note,
      if (url != null) 'url': url,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintBookImpl extends SaintBook {
  _SaintBookImpl({
    int? id,
    required int saintId,
    required String title,
    String? author,
    required _idzj8z5t.BookKind kind,
    int? year,
    String? publisher,
    String? note,
    String? url,
    int? position,
    DateTime? createdAt,
  }) : super._(
         id: id,
         saintId: saintId,
         title: title,
         author: author,
         kind: kind,
         year: year,
         publisher: publisher,
         note: note,
         url: url,
         position: position,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SaintBook]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SaintBook copyWith({
    Object? id = _Undefined,
    int? saintId,
    String? title,
    Object? author = _Undefined,
    _idzj8z5t.BookKind? kind,
    Object? year = _Undefined,
    Object? publisher = _Undefined,
    Object? note = _Undefined,
    Object? url = _Undefined,
    int? position,
    DateTime? createdAt,
  }) {
    return SaintBook(
      id: id is int? ? id : this.id,
      saintId: saintId ?? this.saintId,
      title: title ?? this.title,
      author: author is String? ? author : this.author,
      kind: kind ?? this.kind,
      year: year is int? ? year : this.year,
      publisher: publisher is String? ? publisher : this.publisher,
      note: note is String? ? note : this.note,
      url: url is String? ? url : this.url,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
