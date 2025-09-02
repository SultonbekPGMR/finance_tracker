// Created by Sultonbek Tulanov on 02-September 2025
import 'package:finance_tracker/core/util/extension/build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _descriptionController.text = widget.expense!.description;
      _selectedCategory = ExpenseCategoryModel.fromString(
        widget.expense!.category,
      );
      _selectedDate = widget.expense!.createdAt;
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
      _showValidationErrors();
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
      date: _selectedDate,
    );
  }

  void _updateExpense(ExpenseFormData data) {
    context.read<ExpenseDetailsCubit>().updateExpense(
      expense: widget.expense!,
      amount: data.amount,
      category: data.category,
      description: data.description,
      date: data.date,
    );
  }

  void _addExpense(ExpenseFormData data) {
    context.read<ExpenseDetailsCubit>().addExpense(
      amount: data.amount,
      category: data.category,
      description: data.description,
      date: data.date,
    );
  }

  void _showValidationErrors() {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.pleaseSelectCategory),
          backgroundColor: context.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getDisplayDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (dateOnly == today) {
      return context.l10n.today;
    } else if (dateOnly == yesterday) {
      return context.l10n.yesterday;
    } else {
      return DateFormat('EEE, MMM dd, yyyy').format(_selectedDate);
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
                content: Text(context.l10n.expenseUpdatedSuccessfully),
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
                  const SizedBox(height: 16),
                  _buildDateCard(),
                  const SizedBox(height: 16),
                  _buildCategoryCard(categories),
                  const SizedBox(height: 16),
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
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: context.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.amount,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: context.textTheme.headlineLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.enterAmount,
                hintStyle: context.textTheme.headlineLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: context.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(20),
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

  Widget _buildDateCard() {
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
      child: InkWell(
        onTap: _selectDate,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: context.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.selectDate,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getDisplayDate(),
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
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
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: context.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.category,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                  vertical: 12,
                  horizontal: 16,
                ),
                hintText: context.l10n.selectCategory,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              isDense: false,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: categories.map((category) {
                return DropdownMenuItem<ExpenseCategoryModel>(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: category.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            category.icon,
                            style: const TextStyle(fontSize: 16),
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
            Row(
              children: [
                Icon(
                  Icons.notes,
                  color: context.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.description,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
              maxLines: 3,
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
              child: isLoading
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
  final DateTime date;

  ExpenseFormData({
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });
}