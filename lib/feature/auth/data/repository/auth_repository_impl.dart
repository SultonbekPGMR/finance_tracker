// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/feature/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepositoryImpl implements AuthRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  bool isSignedIn() {
    return auth.currentUser != null;
  }

  @override
  Future<Result<bool>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Result<bool>> signUp(String email, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
