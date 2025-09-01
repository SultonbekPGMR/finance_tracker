// Created by Sultonbek Tulanov on 01-September 2025
import '../../data/model/expense_model.dart';

sealed class ExpenseListItem {}

class ExpenseHeaderItem extends ExpenseListItem {
  final String dateKey;
  final DateTime date;
  final double totalAmount;

  ExpenseHeaderItem(this.dateKey, this.date, this.totalAmount);
}

class ExpenseDataItem extends ExpenseListItem {
  final ExpenseModel expense;

  ExpenseDataItem(this.expense);
}
