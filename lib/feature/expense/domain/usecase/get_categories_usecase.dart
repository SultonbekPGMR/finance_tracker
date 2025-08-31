// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/expense_category_model.dart';

class GetCategoriesUseCase
    implements UseCase<ResultDart<List<ExpenseCategoryModel>, String>, Nothing> {

  GetCategoriesUseCase();

  @override
  ResultDart<List<ExpenseCategoryModel>, String> call(Nothing params) {
    try {
      final categories = ExpenseCategoryModel.allCategories;
      return Success(categories);
    } catch (e) {
      return Failure('Failed to get categories: $e');
    }
  }
}
 
