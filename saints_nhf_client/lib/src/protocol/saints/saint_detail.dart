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
import 'package:saints_nhf_client/src/protocol/protocol.dart' as _ipd1p8hh;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../books/saint_book.dart' as _ir46iu8s;
import '../collection/collected_card.dart' as _izrixkci;
import '../saints/saint_info.dart' as _i38p9z6b;

/// A saint's public info plus the card, when the current user owns it.
abstract class SaintDetail
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SaintDetail._({
    required this.saint,
    this.card,
    required this.books,
  });

  factory SaintDetail({
    required _i38p9z6b.SaintInfo saint,
    _izrixkci.CollectedCard? card,
    required List<_ir46iu8s.SaintBook> books,
  }) = _SaintDetailImpl;

  factory SaintDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaintDetail(
      saint: _ipd1p8hh.Protocol().deserialize<_i38p9z6b.SaintInfo>(
        jsonSerialization['saint'],
      ),
      card: jsonSerialization['card'] == null
          ? null
          : _ipd1p8hh.Protocol().deserialize<_izrixkci.CollectedCard>(
              jsonSerialization['card'],
            ),
      books: _ipd1p8hh.Protocol().deserialize<List<_ir46iu8s.SaintBook>>(
        jsonSerialization['books'],
      ),
    );
  }

  _i38p9z6b.SaintInfo saint;

  _izrixkci.CollectedCard? card;

  /// Recommended reading, already ordered for display.
  List<_ir46iu8s.SaintBook> books;

  /// Returns a shallow copy of this [SaintDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SaintDetail copyWith({
    _i38p9z6b.SaintInfo? saint,
    _izrixkci.CollectedCard? card,
    List<_ir46iu8s.SaintBook>? books,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaintDetail',
      'saint': saint.toJson(),
      if (card != null) 'card': card?.toJson(),
      'books': books.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaintDetail',
      'saint': saint.toJsonForProtocol(),
      if (card != null) 'card': card?.toJsonForProtocol(),
      'books': books.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SaintDetailImpl extends SaintDetail {
  _SaintDetailImpl({
    required _i38p9z6b.SaintInfo saint,
    _izrixkci.CollectedCard? card,
    required List<_ir46iu8s.SaintBook> books,
  }) : super._(
         saint: saint,
         card: card,
         books: books,
       );

  /// Returns a shallow copy of this [SaintDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SaintDetail copyWith({
    _i38p9z6b.SaintInfo? saint,
    Object? card = _Undefined,
    List<_ir46iu8s.SaintBook>? books,
  }) {
    return SaintDetail(
      saint: saint ?? this.saint.copyWith(),
      card: card is _izrixkci.CollectedCard? ? card : this.card?.copyWith(),
      books: books ?? this.books.map((e0) => e0.copyWith()).toList(),
    );
  }
}
