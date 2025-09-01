// Created by Sultonbek Tulanov on 31-August 2025
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;
  final uuid = const Uuid();
  final String collection = 'expenses';

  ExpenseRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ExpenseModel>> getExpensesStream(String userId, {DateTime? month}) {
    Query query = firestore
        .collection(collection)
        .where('userId', isEqualTo: userId);

    if (month != null) {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      query = query
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch);
    }

    return query.orderBy('createdAt', descending: true)
        .snapshots()
        .map(_convertSnapshotToExpenses);
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    try {
      final querySnapshot =
          await firestore
              .collection(collection)
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
      expense = expense.copyWith(id: uuid.v4());
      await firestore.collection(collection).doc(expense.id).set(expense.toJson());
    } catch (e) {
      throw Exception('Failed to details expense: $e');
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await firestore
          .collection(collection)
          .doc(expense.id)
          .update(expense.toJson());
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await firestore.collection(collection).doc(expenseId).delete();
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
