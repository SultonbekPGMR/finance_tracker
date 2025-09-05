// Created by Sultonbek Tulanov on 31-August 2025
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/talker.dart';
import '../../domain/repository/expense_repository.dart';
import '../model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore firestore;
  final uuid = const Uuid();
  final String collection = 'expenses';

  ExpenseRepositoryImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance {
    // Call this method once to update all existing expenses
    // generateAmericanAverageSpendingLast3Months();
  }

  // only for testing
  Future<void> generateAmericanAverageSpendingLast3Months() async {
    try {
      final batch = firestore.batch();
      final random = Random();

      // Get last 3 months
      final now = DateTime.now();
      final months = [
        DateTime(now.year, now.month - 3, 1), // 3 months ago
        DateTime(now.year, now.month - 2, 1), // 2 month ago
        DateTime(now.year, now.month - 1, 1), // 1 month ago
      ];

      // Average American monthly spending by category (in cents for consistency)
      // Based on Bureau of Labor Statistics Consumer Expenditure Survey
      final categorySpendingData = {
        'food': {
          'monthlyAverage': 80000, // $800/month
          'descriptions': [
            'Grocery shopping at Walmart',
            'Dinner at Olive Garden',
            'McDonald\'s lunch break',
            'Starbucks coffee',
            'Pizza Hut family dinner',
            'Subway sandwich',
            'Local deli lunch',
            'Chipotle burrito bowl',
            'Kroger weekly groceries',
            'Panera breakfast',
            'Taco Bell late night',
            'Whole Foods organic groceries',
            'Chick-fil-A drive through',
            'Restaurant week dinner',
            'Food truck lunch',
          ],
          'frequency': 45, // transactions per month
        },
        'transport': {
          'monthlyAverage': 95000, // $950/month
          'descriptions': [
            'Shell gas station fill-up',
            'Uber ride downtown',
            'Car insurance payment',
            'Oil change at Jiffy Lube',
            'Monthly metro card',
            'Parking meter downtown',
            'Lyft to airport',
            'Car wash service',
            'Toll road fee',
            'Vehicle registration',
            'AAA membership renewal',
            'Tire rotation service',
          ],
          'frequency': 25,
        },
        'utilities': {
          'monthlyAverage': 32000, // $320/month
          'descriptions': [
            'Electric bill - ConEd',
            'Verizon phone bill',
            'Internet - Xfinity',
            'Gas bill - National Grid',
            'Water & sewer bill',
            'Trash collection fee',
            'Cable TV subscription',
            'Home security system',
          ],
          'frequency': 8,
        },
        'entertainment': {
          'monthlyAverage': 35000, // $350/month
          'descriptions': [
            'Netflix subscription',
            'AMC movie tickets',
            'Spotify premium',
            'Concert at local venue',
            'PlayStation game',
            'Disney+ subscription',
            'Bowling night out',
            'Mini golf weekend',
            'Museum admission',
            'Streaming service bundle',
            'Sports game tickets',
            'Comedy show tickets',
          ],
          'frequency': 18,
        },
        'shopping': {
          'monthlyAverage': 45000, // $450/month
          'descriptions': [
            'Amazon online purchase',
            'Target household items',
            'Best Buy electronics',
            'Macy\'s clothing sale',
            'Home Depot supplies',
            'Walmart essentials',
            'Nike shoe purchase',
            'Apple Store accessories',
            'CVS pharmacy items',
            'Barnes & Noble books',
            'Bed Bath & Beyond',
            'Old Navy clothing',
          ],
          'frequency': 22,
        },
        'health': {
          'monthlyAverage': 42000, // $420/month
          'descriptions': [
            'Health insurance premium',
            'Doctor copay visit',
            'Prescription at CVS',
            'Dental cleaning',
            'Eye exam appointment',
            'Gym membership - LA Fitness',
            'Urgent care visit',
            'Physical therapy session',
            'Vitamins at GNC',
            'Blood test lab work',
          ],
          'frequency': 12,
        },
      };

      int totalTransactions = 0;

      for (final month in months) {
        final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

        for (final categoryEntry in categorySpendingData.entries) {
          final category = categoryEntry.key;
          final data = categoryEntry.value;

          final monthlyAverage = data['monthlyAverage'] as int;
          final descriptions = data['descriptions'] as List<String>;
          final frequency = data['frequency'] as int;

          // Generate realistic spending distribution
          for (int i = 0; i < frequency; i++) {
            // Random day in the month
            final randomDay = random.nextInt(daysInMonth) + 1;
            final randomHour = random.nextInt(24);
            final randomMinute = random.nextInt(60);

            final transactionDate = DateTime(
              month.year,
              month.month,
              randomDay,
              randomHour,
              randomMinute,
            );

            // Calculate realistic amount with variation
            final baseAmount = monthlyAverage / frequency;
            final variation = baseAmount * 0.4; // 40% variation
            final minAmount = (baseAmount - variation).round();
            final maxAmount = (baseAmount + variation).round();
            final amount =
                minAmount + random.nextInt(maxAmount - minAmount + 1);

            // Random description from category
            final description =
                descriptions[random.nextInt(descriptions.length)];

            // Create expense document
            final docRef = firestore.collection(collection).doc();
            batch.set(docRef, {
              'id': docRef.id,
              'amount': amount,
              'category': category,
              'description': description,
              'createdAt': transactionDate.millisecondsSinceEpoch,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
              'userId': FirebaseAuth.instance.currentUser?.uid ?? 'demo_user',
              // Replace with actual user ID
            });

            totalTransactions++;
          }
        }
      }

      await batch.commit();

      print(
        'Generated $totalTransactions realistic American spending transactions for last 3 months',
      );
      print('Monthly averages:');
      categorySpendingData.forEach((category, data) {
        final average = (data['monthlyAverage'] as int) / 100;
        print('  $category: \$${average.toStringAsFixed(2)}');
      });
    } catch (e) {
      throw Exception('Failed to generate American spending data: $e');
    }
  }

  // Helper method to generate data for specific month if needed
  Future<void> generateDataForSpecificMonth(DateTime targetMonth) async {
    try {
      final batch = firestore.batch();
      final random = Random();

      // Same category data as above but for single month
      final categorySpendingData = {
        'food': {
          'monthlyAverage': 80000,
          'descriptions': [
            'Grocery shopping at Walmart',
            'Dinner at Olive Garden',
            'McDonald\'s lunch break',
            'Starbucks coffee',
            'Pizza Hut family dinner',
            'Subway sandwich',
            'Local deli lunch',
            'Chipotle burrito bowl',
            'Kroger weekly groceries',
            'Panera breakfast',
          ],
          'frequency': 45,
        },
        'transport': {
          'monthlyAverage': 95000,
          'descriptions': [
            'Shell gas station fill-up',
            'Uber ride downtown',
            'Car insurance payment',
            'Oil change at Jiffy Lube',
            'Monthly metro card',
            'Parking meter downtown',
            'Lyft to airport',
            'Car wash service',
          ],
          'frequency': 25,
        },
        'utilities': {
          'monthlyAverage': 32000,
          'descriptions': [
            'Electric bill - ConEd',
            'Verizon phone bill',
            'Internet - Xfinity',
            'Gas bill - National Grid',
            'Water & sewer bill',
            'Trash collection fee',
          ],
          'frequency': 8,
        },
        'entertainment': {
          'monthlyAverage': 35000,
          'descriptions': [
            'Netflix subscription',
            'AMC movie tickets',
            'Spotify premium',
            'Concert at local venue',
            'PlayStation game',
            'Disney+ subscription',
          ],
          'frequency': 18,
        },
        'shopping': {
          'monthlyAverage': 45000,
          'descriptions': [
            'Amazon online purchase',
            'Target household items',
            'Best Buy electronics',
            'Macy\'s clothing sale',
            'Home Depot supplies',
            'Walmart essentials',
          ],
          'frequency': 22,
        },
        'health': {
          'monthlyAverage': 42000,
          'descriptions': [
            'Health insurance premium',
            'Doctor copay visit',
            'Prescription at CVS',
            'Dental cleaning',
            'Eye exam appointment',
            'Gym membership - LA Fitness',
          ],
          'frequency': 12,
        },
      };

      final daysInMonth =
          DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
      int monthTransactions = 0;

      for (final categoryEntry in categorySpendingData.entries) {
        final category = categoryEntry.key;
        final data = categoryEntry.value;

        final monthlyAverage = data['monthlyAverage'] as int;
        final descriptions = data['descriptions'] as List<String>;
        final frequency = data['frequency'] as int;

        for (int i = 0; i < frequency; i++) {
          final randomDay = random.nextInt(daysInMonth) + 1;
          final randomHour = random.nextInt(24);
          final randomMinute = random.nextInt(60);

          final transactionDate = DateTime(
            targetMonth.year,
            targetMonth.month,
            randomDay,
            randomHour,
            randomMinute,
          );

          final baseAmount = monthlyAverage / frequency;
          final variation = baseAmount * 0.4;
          final minAmount = (baseAmount - variation).round();
          final maxAmount = (baseAmount + variation).round();
          final amount = minAmount + random.nextInt(maxAmount - minAmount + 1);

          final description = descriptions[random.nextInt(descriptions.length)];

          final docRef = firestore.collection(collection).doc();
          batch.set(docRef, {
            'id': docRef.id,
            'amount': amount,
            'category': category,
            'description': description,
            'createdAt': transactionDate.millisecondsSinceEpoch,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
            'userId': FirebaseAuth.instance.currentUser?.uid ?? 'demo_user',
          });

          monthTransactions++;
        }
      }

      await batch.commit();
      print(
        'Generated $monthTransactions transactions for ${targetMonth.month}/${targetMonth.year}',
      );
    } catch (e) {
      throw Exception('Failed to generate month data: $e');
    }
  }
  @override
  Stream<List<ExpenseModel>> getExpensesStream(
      String userId, {
        DateTime? month,
      }) {
    return firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      var expenses = _convertSnapshotToExpenses(snapshot);

      if (month != null) {
        final startOfMonth = DateTime(month.year, month.month, 1);
        final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

        expenses = expenses.where((expense) {
          final expenseTime = expense.createdAt.millisecondsSinceEpoch;
          return expenseTime >= startOfMonth.millisecondsSinceEpoch &&
              expenseTime <= endOfMonth.millisecondsSinceEpoch;
        }).toList();
      }

      return expenses;
    });
  }
  @override
  Future<List<ExpenseModel>> getExpenses(
    String userId, {
    DateTime? month,
  }) async {
    try {
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

      final querySnapshot =
          await query.orderBy('createdAt', descending: true).get();

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
          .set(expense.toJson())
          .timeout(Duration(seconds: 3));
    } on TimeoutException {
      // Safe to ignore: Firestore wrote locally and will sync later.
    } catch (e) {
      throw Exception('Failed to expense_details expense: $e');
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
