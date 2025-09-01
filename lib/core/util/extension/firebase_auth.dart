// Created by Sultonbek Tulanov on 01-September 2025
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../feature/auth/data/model/user_model.dart';

extension FirebaseAuthUserModel on FirebaseAuth {
  /// Returns the current user as a [UserModel], or null if not signed in
  UserModel? get currentUserModel {
    final user = currentUser;
    if (user == null) return null;
    return UserModel(
      user.uid,
      user.displayName ?? '',
      user.email ?? '',
    );
  }
}
 
