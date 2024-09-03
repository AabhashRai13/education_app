import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo_impl.mock.dart';

void main() {
  late OnBoardingLocalDataSource onBoardingLocalDataSource;
  late OnBoardingRepoImpl onBoardingRepoImpl;

  setUp(() {
    onBoardingLocalDataSource = MockOnBoardingLocalDataSource();
    onBoardingRepoImpl = OnBoardingRepoImpl(onBoardingLocalDataSource);
  });

  test('Should be a subclass of [OnBoardingRepo]', () {
    expect(onBoardingRepoImpl, isA<OnBoardingRepo>());
  });

  group('cacheFirstTimer', () {
    test(
        'should complete successfully when call'
        ' local source is successfull', () async {
      when(() => onBoardingLocalDataSource.cacheFirstTimer()).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await onBoardingRepoImpl.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => onBoardingLocalDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(onBoardingLocalDataSource);
    });
    test(
      'should return [CacheFailure] when call to local source is '
      'unsuccessful',
      () async {
        when(() => onBoardingLocalDataSource.cacheFirstTimer()).thenThrow(
          const CacheException(message: 'Insufficient storage'),
        );

        final result = await onBoardingRepoImpl.cacheFirstTimer();

        expect(
          result,
          Left<CacheFailure, dynamic>(
            CacheFailure(message: 'Insufficient storage', statusCode: 500),
          ),
        );
        verify(() => onBoardingLocalDataSource.cacheFirstTimer());
        verifyNoMoreInteractions(onBoardingLocalDataSource);
      },
    );
  });
}
