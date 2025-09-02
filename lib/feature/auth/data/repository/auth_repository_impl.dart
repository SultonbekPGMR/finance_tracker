// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/core/util/exception/localized_exception.dart';
import 'package:finance_tracker/feature/auth/data/model/user_model.dart';
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
  Future<Result<bool>> signIn(String email, String password) async {
    try {
      if (email.trim().isEmpty || password.isEmpty) {
        return Failure(InvalidCredentialsException());
      }
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Success(true);
      } else {
        return Failure(UserNotFoundException());
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<bool>> signOut() async {
    try {
      await auth.signOut();
      return Success(true);
    } on FirebaseAuthException catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<bool>> signUp(String email, String password) async {
    try {
      if (email.trim().isEmpty || password.isEmpty) {
        return Failure(InvalidCredentialsException());
      }
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return Success(true);
      } else {
        return Failure(Exception('Registration failed: No user created'));
      }
    } on FirebaseAuthException catch (e) {
      return Failure(e);
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = auth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel(user.uid, user.displayName ?? '', user.email ?? '');
  }
}
