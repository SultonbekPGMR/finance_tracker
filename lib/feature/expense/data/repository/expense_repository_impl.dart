// Created by Sultonbek Tulanov on 31-August 2025
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repository/expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'expenses';

  ExpenseRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ExpenseModel>> getExpensesStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_convertSnapshotToExpenses);
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collection)
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return _convertSnapshotToExpenses(querySnapshot);
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _firestore.collection(_collection).add(expense.toJson());
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(expense.id)
          .update(expense.toJson());
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore.collection(_collection).doc(expenseId).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  List<ExpenseModel> _convertSnapshotToExpenses(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ExpenseModel.fromJson(data);
    }).toList();
  }
}
