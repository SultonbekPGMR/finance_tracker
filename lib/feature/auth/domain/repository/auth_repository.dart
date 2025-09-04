// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/util/no_params.dart';
import 'package:finance_tracker/feature/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

abstract class AuthRepository {
  bool isSignedIn();
  UserModel? getCurrentUser();
  Future<Result<Nothing>> requestPasswordReset(String email);
  Future<Result<bool>> signIn(String email, String password);
  Future<Result<bool>> signUp(String email, String password);
  Future<Result<bool>> signOut();
}
