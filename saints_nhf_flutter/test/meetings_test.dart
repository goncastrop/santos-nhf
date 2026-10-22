import 'package:flutter_test/flutter_test.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';
import 'package:saints_nhf_flutter/utils/meetings.dart';

SaintInfo _info(String name) => SaintInfo(
  id: name.hashCode,
  name: name,
  slug: name.toLowerCase().replaceAll(' ', '-'),
  birthApprox: false,
  deathApprox: false,
  bio: '',
);

void main() {
  test('one saint reads in singular', () {
    expect(
      metHeading([_info('San Juan Pablo II')]),
      'Con qué otro santo se conoció',
    );
  });

  test('one saint who is a woman reads in feminine', () {
    expect(
      metHeading([_info('Santa Teresa de Calcuta')]),
      'Con qué otra santa se conoció',
    );
  });

  test('one beata is called a beata, not a santa', () {
    expect(
      metHeading([_info('Beata Chiara Luce Badano')]),
      'Con qué otra beata se conoció',
    );
  });

  test('several saints read in plural, masculine when mixed', () {
    expect(
      metHeading([_info('Santa Teresa de Calcuta'), _info('San Óscar Romero')]),
      'Con qué otros santos se conoció',
    );
  });

  test('several saints who are all women read in feminine plural', () {
    expect(
      metHeading([_info('Santa Teresa de Jesús'), _info('Santa Mónica')]),
      'Con qué otras santas se conoció',
    );
  });
}
