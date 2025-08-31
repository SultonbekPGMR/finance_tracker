// Created by Sultonbek Tulanov on 30-August 2025

import 'package:finance_tracker/feature/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

abstract class AuthRepository {
  bool isSignedIn();
  UserModel? getCurrentUser();
  Future<ResultDart<bool,String>> signIn(String email, String password);
  Future<ResultDart<bool,String>> signUp(String email, String password);
  Future<ResultDart<bool,String>> signOut();
}
