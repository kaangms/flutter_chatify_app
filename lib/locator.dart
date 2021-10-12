import 'package:flutter_chatify_app/repository/user_repository.dart';
import 'package:flutter_chatify_app/services/concrete/fake_api/fake_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_auth_service.dart';
import 'package:flutter_chatify_app/services/concrete/firebase/firebase_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
}
