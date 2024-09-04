import 'package:education_app/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource {
  const OnBoardingLocalDataSource();

  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}

const kFirstTimerKey = 'first_timer';

class OnBoardingLocalDataSourceImpl extends OnBoardingLocalDataSource {
  const OnBoardingLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await sharedPreferences.setBool(kFirstTimerKey, false);
    } catch (e) {
      throw const CacheException(
        message: 'Error caching first timer',
      );
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      return sharedPreferences.getBool(kFirstTimerKey) ?? true;
    } catch (e) {
      throw const CacheException(
        message: 'Error retrieving first timer',
      );
    }
  }
}
