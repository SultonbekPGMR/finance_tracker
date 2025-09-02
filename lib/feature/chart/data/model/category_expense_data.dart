// Created by Sultonbek Tulanov on 02-September 2025
import '../../../expense/data/model/expense_category_model.dart';

class CategoryExpenseData {
  final ExpenseCategoryModel category;
  final double totalAmount;
  final int transactionCount;

  CategoryExpenseData({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
  });
  @override
  String toString() {
    return 'CategoryExpenseData(category: $category, totalAmount: $totalAmount, transactionCount: $transactionCount)';
  }
}
 
