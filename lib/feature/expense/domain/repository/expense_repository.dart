// Created by Sultonbek Tulanov on 31-August 2025

import '../../data/model/expense_model.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseModel>> getExpensesStream(String userId , {DateTime? month});
  Future<List<ExpenseModel>> getExpenses(String userId,{DateTime? month});
  Future<void> addExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);

// Future<List<Expense>> getExpensesByCategory(String userId, String category);
// Future<Map<String, double>> getCategoryTotals(String userId, DateTime month);
}
 
