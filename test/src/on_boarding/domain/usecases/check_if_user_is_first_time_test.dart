import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late MockOnBoardingRepo onBoardingRepo;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;

  setUp(() {
    onBoardingRepo = MockOnBoardingRepo();
    checkIfUserIsFirstTimer = CheckIfUserIsFirstTimer(onBoardingRepo);
  });

  test(
      'should get a response from the [MockOnBoardingRepo]'
      ' and return the left case', () async {
    when(() => onBoardingRepo.checkIfUserIsFirstTimer()).thenAnswer(
      (_) async => Left(
        ServerFailure(
          message: 'Unkown error occured',
          statusCode: 500,
        ),
      ),
    );

    final result = await checkIfUserIsFirstTimer();

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
    verify(() => onBoardingRepo.checkIfUserIsFirstTimer()).called(1);
    verifyNoMoreInteractions(onBoardingRepo);
  });

  test(
      'should get a response from the [MockOnBoardingRepo]'
      ' and return the right case', () async {
    when(() => onBoardingRepo.checkIfUserIsFirstTimer()).thenAnswer(
      (_) async => const Right(true),
    );

    final result = await checkIfUserIsFirstTimer();

    expect(
      result,
      equals(
        const Right<dynamic, bool>(true),
      ),
    );
    verify(() => onBoardingRepo.checkIfUserIsFirstTimer()).called(1);
    verifyNoMoreInteractions(onBoardingRepo);
  });
}
