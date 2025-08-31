// Created by Sultonbek Tulanov on 30-August 2025

import 'package:result_dart/result_dart.dart';

abstract class AuthRepository {
  bool isSignedIn();
  Future<ResultDart<bool,String>> signIn(String email, String password);
  Future<ResultDart<bool,String>> signUp(String email, String password);
  Future<ResultDart<bool,String>> signOut();
}
