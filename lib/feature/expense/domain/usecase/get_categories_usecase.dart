// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/usecase.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/util/no_params.dart';
import '../../data/model/expense_category_model.dart';

class GetCategoriesUseCase
    implements UseCase<Result<List<ExpenseCategoryModel>>, Nothing> {
  GetCategoriesUseCase();

  @override
  Result<List<ExpenseCategoryModel>> call(Nothing params) {
    return Success(ExpenseCategoryModel.allCategories);
  }
}
