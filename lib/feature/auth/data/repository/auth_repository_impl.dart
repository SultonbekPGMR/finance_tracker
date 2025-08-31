// Created by Sultonbek Tulanov on 30-August 2025

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
  Future<ResultDart<bool, String>> signIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return Success(true);
      } else {
        return Failure('No user found');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        default:
          errorMessage = 'Authentication failed. ${e.message}';
      }
      return Failure(errorMessage);
    } catch (e) {
      return Failure('Something went wrong: $e');
    }
  }

  @override
  Future<ResultDart<bool, String>> signOut() async {
    try {
      await auth.signOut();
      return Success(true);
    } catch (e) {
      return Failure('Sign out failed: $e');
    }
  }

  @override
  Future<ResultDart<bool, String>> signUp(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return Success(true);
      } else {
        return Failure('Registration failed: No user created');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      return Failure(errorMessage);
    } catch (e) {
      return Failure('Registration failed: $e');
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
