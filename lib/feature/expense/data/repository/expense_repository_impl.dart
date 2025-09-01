// Created by Sultonbek Tulanov on 31-August 2025
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repository/expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;
  final uuid = const Uuid();
  final String collection = 'expenses';

  ExpenseRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance {
    // Call this method once to update all existing expenses
    // updateExpensesWithRandomAugustDates();
  }

  // only for testing
  Future<void> updateExpensesWithRandomAugustDates() async {
    try {
      final snapshot = await firestore.collection(collection).get();
      final random = Random();
      final batch = firestore.batch();

      final augustStart = DateTime(2025, 8, 1);
      final augustEnd = DateTime(2025, 8, 31, 23, 59, 59);
      final totalDays = augustEnd.difference(augustStart).inDays;

      // Category data with descriptions and amount ranges
      final categoryData = {
        'food': {
          'descriptions': [
            'Dinner at Italian restaurant',
            'Lunch with colleagues',
            'Coffee and pastry',
            'Weekly groceries',
            'Pizza delivery night',
            'Breakfast at local cafe',
            'Sushi dinner date',
            'Fast food quick meal',
          ],
          'amounts': [1500, 2500, 800, 12000, 3500, 1200, 4500, 900]
        },
        'transport': {
          'descriptions': [
            'Gas station fill-up',
            'Uber ride to airport',
            'Monthly bus pass',
            'Downtown parking fee',
            'Taxi ride home',
            'Car oil change',
            'Metro card refill',
          ],
          'amounts': [8000, 4500, 3200, 800, 1500, 7500, 2000]
        },
        'entertainment': {
          'descriptions': [
            'Movie tickets',
            'Concert at venue',
            'Netflix subscription',
            'Gaming purchase',
            'Theatre show',
            'Bowling night',
            'Museum entry',
          ],
          'amounts': [2400, 15000, 1200, 6000, 8500, 3500, 1500]
        },
        'shopping': {
          'descriptions': [
            'New clothing items',
            'Electronics purchase',
            'Home decoration',
            'Books and magazines',
            'Gift for friend',
            'Phone accessories',
            'Shoes shopping',
          ],
          'amounts': [25000, 45000, 18000, 3500, 8000, 4500, 22000]
        },
        'utilities': {
          'descriptions': [
            'Monthly electricity bill',
            'Internet subscription',
            'Water bill payment',
            'Phone plan monthly',
            'Gas bill for heating',
            'Trash collection fee',
          ],
          'amounts': [15000, 5500, 8500, 4200, 12000, 2500]
        },
        'health': {
          'descriptions': [
            'Doctor consultation',
            'Pharmacy prescription',
            'Dental checkup',
            'Gym membership',
            'Vitamins purchase',
            'Eye exam',
          ],
          'amounts': [12000, 3500, 18000, 8500, 4000, 15000]
        },
      };

      final categories = categoryData.keys.toList();

      for (final doc in snapshot.docs) {
        // Random date in August 2025
        final randomDays = random.nextInt(totalDays + 1);
        final randomHour = random.nextInt(24);
        final randomMinute = random.nextInt(60);

        final randomDate = augustStart.add(
          Duration(days: randomDays, hours: randomHour, minutes: randomMinute),
        );

        // Random category
        final category = categories[random.nextInt(categories.length)];
        final data = categoryData[category]!;

        // Random description and amount from the category
        final descriptions = data['descriptions'] as List<String>;
        final amounts = data['amounts'] as List<int>;
        final randomIndex = random.nextInt(descriptions.length);

        final description = descriptions[randomIndex];
        final amount = amounts[randomIndex];

        batch.update(doc.reference, {
          'createdAt': randomDate.millisecondsSinceEpoch,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
          'category': category,
          'description': description,
          'amount': amount,
        });
      }

      await batch.commit();
      print('Updated ${snapshot.docs.length} expenses with realistic August 2025 data');

    } catch (e) {
      throw Exception('Failed to update expenses: $e');
    }
  }

  @override
  Stream<List<ExpenseModel>> getExpensesStream(
    String userId, {
    DateTime? month,
  }) {

    Query query = firestore
        .collection(collection)
        .where('userId', isEqualTo: userId);

    if (month != null) {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
      query = query
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch,
          )
          .where(
            'createdAt',
            isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch,
          );
    }



    return query
        .orderBy('createdAt', descending: true)
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
      await firestore
          .collection(collection)
          .doc(expense.id)
          .set(expense.toJson()).timeout(Duration(seconds: 3));
    }on TimeoutException {
      // Safe to ignore: Firestore wrote locally and will sync later.
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
