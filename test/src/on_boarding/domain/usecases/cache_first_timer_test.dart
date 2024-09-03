import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo onBoardingRepo;
  late CacheFirstTimer cacheFirstTimerUseCase;

  setUp(() {
    onBoardingRepo = MockOnBoardingRepo();
    cacheFirstTimerUseCase = CacheFirstTimer(onBoardingRepo);
  });

  test(
      'should call cacheFirstTimer from OnBoardingRepo'
      ' and return the right data', () async {
    when(() => onBoardingRepo.cacheFirstTimer()).thenAnswer(
      (_) async => Left(
        ServerFailure(
          message: 'Unkown error occured',
          statusCode: 500,
        ),
      ),
    );

    final result = await cacheFirstTimerUseCase();

    expect(
      result,
      equals(
        Left<Failure, dynamic>(
          ServerFailure(
            message: 'Unkown error occured',
            statusCode: 500,
          ),
        ),
      ),
    );
    verify(() => onBoardingRepo.cacheFirstTimer()).called(1);
    verifyNoMoreInteractions(onBoardingRepo);
  });
}
