// Created by Sultonbek Tulanov on 30-August 2025

import 'package:result_dart/result_dart.dart';

abstract class AuthRepository {
  bool isSignedIn();
  Future<Result<bool>> signIn(String email, String password);
  Future<Result<bool>> signUp(String email, String password);
  Future<Result<bool>> signOut();
}
