// Created by Sultonbek Tulanov on 31-August 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/expense_category_model.dart';
import '../../data/model/expense_model.dart';
import '../bloc/details/expense_details_cubit.dart';

class ExpenseDetailsScreen extends StatefulWidget {
  final ExpenseModel? expense;

  const ExpenseDetailsScreen({super.key, this.expense});

  @override
  State<ExpenseDetailsScreen> createState() => _ExpenseDetailsScreenState();
}

class _ExpenseDetailsScreenState extends State<ExpenseDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExpenseCategoryModel? _selectedCategory;

  @override
  void initState() {
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedCategory = ExpenseCategoryModel.fromString(
        widget.expense!.category,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showCategoryValidationError();
      return;
    }

    final expenseData = _extractExpenseData();
    final isUpdate = widget.expense != null;

    isUpdate ? _updateExpense(expenseData) : _addExpense(expenseData);
  }

  bool _isFormValid() {
    return _formKey.currentState!.validate() && _selectedCategory != null;
  }

  ExpenseFormData _extractExpenseData() {
    return ExpenseFormData(
      amount: double.parse(_amountController.text),
      category: _selectedCategory!,
      description: _descriptionController.text.trim(),
    );
  }

  void _updateExpense(ExpenseFormData data) {
    context.read<ExpenseDetailsCubit>().updateExpense(
      expense: widget.expense!,
      amount: data.amount,
      category: data.category,
      description: data.description,
    );
  }

  void _addExpense(ExpenseFormData data) {
    context.read<ExpenseDetailsCubit>().addExpense(
      amount: data.amount,
      category: data.category,
      description: data.description,
    );
  }

  void _showCategoryValidationError() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pleaseSelectCategory),
          backgroundColor: context.colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          widget.expense != null
              ? context.l10n.updateExpense
              : context.l10n.addExpense,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
        backgroundColor: context.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: context.colorScheme.surfaceTint,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ExpenseDetailsCubit, ExpenseDetailsState>(
        listener: (context, state) {
          if (state is ExpenseDetailsAddedSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.expenseAddedSuccessfully),
                backgroundColor: context.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is ExpenseDetailsUpdatedSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.updateSuccess),
                backgroundColor: context.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          } else if (state is ExpenseDetailsSubmissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: context.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            ExpenseDetailsLoading() => Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            ),
            ExpenseDetailsLoaded loaded => _buildForm(loaded.categories),
            ExpenseDetailsSubmitting submitting => _buildForm(
              submitting.categories,
            ),
            ExpenseDetailsSubmissionError error => _buildForm(error.categories),
            ExpenseDetailsError() => Center(
              child: Text(
                context.l10n.errorLoadingExpenses,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
            ExpenseDetailsAddedSuccessfully() => const SizedBox(),
            ExpenseDetailsUpdatedSuccessfully() => const SizedBox(),
          };
        },
      ),
    );
  }

  Widget _buildForm(List<ExpenseCategoryModel> categories) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAmountCard(),
                  const SizedBox(height: 24),
                  _buildCategoryCard(categories),
                  const SizedBox(height: 24),
                  _buildDescriptionCard(),
                ],
              ),
            ),
          ),
        ),
        _buildBottomSaveButton(),
      ],
    );
  }

  Widget _buildAmountCard() {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.amount,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: context.textTheme.headlineMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.attach_money,
                    color: context.colorScheme.primary,
                    size: 32,
                  ),
                ),
                hintText: context.l10n.enterAmount,
                hintStyle: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: context.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.l10n.pleaseEnterAmount;
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return context.l10n.pleaseEnterValidAmount;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(List<ExpenseCategoryModel> categories) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.category,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExpenseCategoryModel>(
              value: _selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: context.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                hintText: context.l10n.selectCategory,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              isDense: false,
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  categories.map((category) {
                    return DropdownMenuItem<ExpenseCategoryModel>(
                      value: category,
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: category.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                category.icon,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category.displayName,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (ExpenseCategoryModel? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              validator: (value) {
                if (value == null) {
                  return context.l10n.pleaseSelectCategory;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.description,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: context.l10n.enterDescription,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: context.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurface,
              ),
              maxLines: 4,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n.pleaseEnterDescription;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return BlocBuilder<ExpenseDetailsCubit, ExpenseDetailsState>(
      builder: (context, state) {
        final isLoading = state is ExpenseDetailsSubmitting;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: FilledButton(
              onPressed: isLoading ? null : _submitForm,
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                minimumSize: const Size(double.infinity, 56),
              ),
              child:
                  isLoading
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.l10n.saving,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        context.l10n.save,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }
}

class ExpenseFormData {
  final double amount;
  final ExpenseCategoryModel category;
  final String description;

  ExpenseFormData({
    required this.amount,
    required this.category,
    required this.description,
  });
}
