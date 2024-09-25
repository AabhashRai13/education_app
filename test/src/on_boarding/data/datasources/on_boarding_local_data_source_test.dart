import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences sharedPreferences;
  late OnBoardingLocalDataSource onBoardingLocalDataSource;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    onBoardingLocalDataSource = OnBoardingLocalDataSrcImpl(sharedPreferences);
  });

  group('cacheFirstTimer', () {
    test('should call SharedPreferences to cache the first timer', () async {
      when(() => sharedPreferences.setBool(any(), false))
          .thenAnswer((_) async => true);

      await onBoardingLocalDataSource.cacheFirstTimer();

      verify(() => sharedPreferences.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'should throw a CacheException when there'
        ' is an error caching the first timer', () async {
      when(() => sharedPreferences.setBool(any(), any()))
          .thenThrow(Exception());

      final result = onBoardingLocalDataSource.cacheFirstTimer;

      expect(result, throwsA(isA<CacheException>()));
      verify(() => sharedPreferences.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('checkIfUserFirstTimer', () {
    test(
        'check if user is a first timer'
        ' by calling  shared preferences', () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(true);

      final result = await onBoardingLocalDataSource.checkIfUserIsFirstTimer();

      expect(result, true);

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('should return true if there is no data in storage', () async {
      when(() => sharedPreferences.getBool(any())).thenReturn(null);

      final result = await onBoardingLocalDataSource.checkIfUserIsFirstTimer();

      expect(result, true);

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });

    test(
        'should throw a [CacheException] when there is an error '
        'retrieving the data', () {
      when(() => sharedPreferences.getBool(any())).thenThrow(Exception());

      final result = onBoardingLocalDataSource.checkIfUserIsFirstTimer;

      expect(result, throwsA(isA<CacheException>()));

      verify(() => sharedPreferences.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(sharedPreferences);
    });
  });
}
