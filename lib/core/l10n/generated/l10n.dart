// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Finance Tracker`
  String get appTitle {
    return Intl.message(
      'Finance Tracker',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailHint {
    return Intl.message(
      'Email',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordHint {
    return Intl.message(
      'Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordHint {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Do you have an account?`
  String get haveAccount {
    return Intl.message(
      'Do you have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get records {
    return Intl.message(
      'Expenses',
      name: 'records',
      desc: '',
      args: [],
    );
  }

  /// `Charts`
  String get charts {
    return Intl.message(
      'Charts',
      name: 'charts',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpense {
    return Intl.message(
      'Add Expense',
      name: 'addExpense',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an amount`
  String get pleaseEnterAmount {
    return Intl.message(
      'Please enter an amount',
      name: 'pleaseEnterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid amount`
  String get pleaseEnterValidAmount {
    return Intl.message(
      'Please enter a valid amount',
      name: 'pleaseEnterValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Select a category`
  String get selectCategory {
    return Intl.message(
      'Select a category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Please select a category`
  String get pleaseSelectCategory {
    return Intl.message(
      'Please select a category',
      name: 'pleaseSelectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get enterDescription {
    return Intl.message(
      'Enter description',
      name: 'enterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get pleaseEnterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'pleaseEnterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Adding...`
  String get adding {
    return Intl.message(
      'Adding...',
      name: 'adding',
      desc: '',
      args: [],
    );
  }

  /// `Saving...`
  String get saving {
    return Intl.message(
      'Saving...',
      name: 'saving',
      desc: '',
      args: [],
    );
  }

  /// `Expense added successfully`
  String get expenseAddedSuccessfully {
    return Intl.message(
      'Expense added successfully',
      name: 'expenseAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Expense updated successfully`
  String get expenseUpdatedSuccessfully {
    return Intl.message(
      'Expense updated successfully',
      name: 'expenseUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load categories`
  String get failedToLoadCategories {
    return Intl.message(
      'Failed to load categories',
      name: 'failedToLoadCategories',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add expense`
  String get failedToAddExpense {
    return Intl.message(
      'Failed to add expense',
      name: 'failedToAddExpense',
      desc: '',
      args: [],
    );
  }

  /// `No expenses found`
  String get noExpensesFound {
    return Intl.message(
      'No expenses found',
      name: 'noExpensesFound',
      desc: '',
      args: [],
    );
  }

  /// `Search expenses...`
  String get searchExpenses {
    return Intl.message(
      'Search expenses...',
      name: 'searchExpenses',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get allCategories {
    return Intl.message(
      'All Categories',
      name: 'allCategories',
      desc: '',
      args: [],
    );
  }

  /// `Loading expenses...`
  String get loadingExpenses {
    return Intl.message(
      'Loading expenses...',
      name: 'loadingExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Error loading expenses`
  String get errorLoadingExpenses {
    return Intl.message(
      'Error loading expenses',
      name: 'errorLoadingExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Total Spent: {amount}`
  String totalSpent(Object amount) {
    return Intl.message(
      'Total Spent: $amount',
      name: 'totalSpent',
      desc: '',
      args: [amount],
    );
  }

  /// `Select Month`
  String get selectMonth {
    return Intl.message(
      'Select Month',
      name: 'selectMonth',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Expenses: {amount}`
  String dayTotal(Object amount) {
    return Intl.message(
      'Expenses: $amount',
      name: 'dayTotal',
      desc: '',
      args: [amount],
    );
  }

  /// `No description`
  String get noDescription {
    return Intl.message(
      'No description',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Money Tracker`
  String get moneyTracker {
    return Intl.message(
      'Money Tracker',
      name: 'moneyTracker',
      desc: '',
      args: [],
    );
  }

  /// `Expenses`
  String get expenses {
    return Intl.message(
      'Expenses',
      name: 'expenses',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Start by adding your first expense`
  String get startAddingExpenses {
    return Intl.message(
      'Start by adding your first expense',
      name: 'startAddingExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete Expense`
  String get deleteExpense {
    return Intl.message(
      'Delete Expense',
      name: 'deleteExpense',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this expense?`
  String get deleteConfirmation {
    return Intl.message(
      'Are you sure you want to delete this expense?',
      name: 'deleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Expense deleted successfully`
  String get deleteSuccess {
    return Intl.message(
      'Expense deleted successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting expense`
  String get deleteError {
    return Intl.message(
      'Error deleting expense',
      name: 'deleteError',
      desc: '',
      args: [],
    );
  }

  /// `Error updating expense`
  String get updateError {
    return Intl.message(
      'Error updating expense',
      name: 'updateError',
      desc: '',
      args: [],
    );
  }

  /// `Update Expense`
  String get updateExpense {
    return Intl.message(
      'Update Expense',
      name: 'updateExpense',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message(
      'Preferences',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Edit Name`
  String get editName {
    return Intl.message(
      'Edit Name',
      name: 'editName',
      desc: '',
      args: [],
    );
  }

  /// `Set Name`
  String get setName {
    return Intl.message(
      'Set Name',
      name: 'setName',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Select Theme`
  String get selectTheme {
    return Intl.message(
      'Select Theme',
      name: 'selectTheme',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Select Currency`
  String get selectCurrency {
    return Intl.message(
      'Select Currency',
      name: 'selectCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Export Data`
  String get exportData {
    return Intl.message(
      'Export Data',
      name: 'exportData',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sign out?`
  String get signOutConfirmation {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'signOutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Error loading profile`
  String get errorLoadingProfile {
    return Intl.message(
      'Error loading profile',
      name: 'errorLoadingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message(
      'Select Date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose expense date`
  String get dateHint {
    return Intl.message(
      'Choose expense date',
      name: 'dateHint',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date`
  String get pleaseSelectDate {
    return Intl.message(
      'Please select a date',
      name: 'pleaseSelectDate',
      desc: '',
      args: [],
    );
  }

  /// `Invalid request`
  String get badRequest {
    return Intl.message(
      'Invalid request',
      name: 'badRequest',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized access`
  String get unauthorized {
    return Intl.message(
      'Unauthorized access',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Access forbidden`
  String get forbidden {
    return Intl.message(
      'Access forbidden',
      name: 'forbidden',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found`
  String get notFound {
    return Intl.message(
      'Resource not found',
      name: 'notFound',
      desc: '',
      args: [],
    );
  }

  /// `Network error occurred`
  String get networkError {
    return Intl.message(
      'Network error occurred',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `Request was cancelled`
  String get requestCancelled {
    return Intl.message(
      'Request was cancelled',
      name: 'requestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Data format error`
  String get dataFormatError {
    return Intl.message(
      'Data format error',
      name: 'dataFormatError',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred`
  String get unknownError {
    return Intl.message(
      'An unknown error occurred',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `Authentication error occurred`
  String get authenticationError {
    return Intl.message(
      'Authentication error occurred',
      name: 'authenticationError',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userNotFound {
    return Intl.message(
      'User not found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get invalidCredentials {
    return Intl.message(
      'Invalid email or password',
      name: 'invalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Email is already in use`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email is already in use',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak`
  String get weakPassword {
    return Intl.message(
      'Password is too weak',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests. Please try again later`
  String get tooManyRequests {
    return Intl.message(
      'Too many requests. Please try again later',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `This account has been disabled`
  String get userDisabled {
    return Intl.message(
      'This account has been disabled',
      name: 'userDisabled',
      desc: '',
      args: [],
    );
  }

  /// `This operation is not allowed`
  String get operationNotAllowed {
    return Intl.message(
      'This operation is not allowed',
      name: 'operationNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get invalidPassword {
    return Intl.message(
      'Wrong password',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Server error occurred`
  String get serverError {
    return Intl.message(
      'Server error occurred',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout`
  String get connectionTimeout {
    return Intl.message(
      'Connection timeout',
      name: 'connectionTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Expense not found`
  String get expenseNotFound {
    return Intl.message(
      'Expense not found',
      name: 'expenseNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Invalid amount: {amount}`
  String invalidAmountWithValue(Object amount) {
    return Intl.message(
      'Invalid amount: $amount',
      name: 'invalidAmountWithValue',
      desc: '',
      args: [amount],
    );
  }

  /// `Category not found`
  String get categoryNotFound {
    return Intl.message(
      'Category not found',
      name: 'categoryNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Storage error occurred`
  String get storageError {
    return Intl.message(
      'Storage error occurred',
      name: 'storageError',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error: {details}`
  String unknownErrorWithDetails(Object details) {
    return Intl.message(
      'Unknown error: $details',
      name: 'unknownErrorWithDetails',
      desc: '',
      args: [details],
    );
  }

  /// `Expenses by Category`
  String get expensesByCategory {
    return Intl.message(
      'Expenses by Category',
      name: 'expensesByCategory',
      desc: '',
      args: [],
    );
  }

  /// `Category Breakdown`
  String get categoryBreakdown {
    return Intl.message(
      'Category Breakdown',
      name: 'categoryBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `{count} transactions`
  String transactionCount(Object count) {
    return Intl.message(
      '$count transactions',
      name: 'transactionCount',
      desc: '',
      args: [count],
    );
  }

  /// `Select a month to view statistics`
  String get selectMonthToView {
    return Intl.message(
      'Select a month to view statistics',
      name: 'selectMonthToView',
      desc: '',
      args: [],
    );
  }

  /// `Currently selected`
  String get selectedCategory {
    return Intl.message(
      'Currently selected',
      name: 'selectedCategory',
      desc: '',
      args: [],
    );
  }

  /// `Highest spending category`
  String get topSpendingCategory {
    return Intl.message(
      'Highest spending category',
      name: 'topSpendingCategory',
      desc: '',
      args: [],
    );
  }

  /// `Daily Expenses Trend`
  String get dailyExpensesTrend {
    return Intl.message(
      'Daily Expenses Trend',
      name: 'dailyExpensesTrend',
      desc: '',
      args: [],
    );
  }

  /// `Category Comparison`
  String get categoryComparison {
    return Intl.message(
      'Category Comparison',
      name: 'categoryComparison',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to view different charts`
  String get swipeToViewCharts {
    return Intl.message(
      'Swipe to view different charts',
      name: 'swipeToViewCharts',
      desc: '',
      args: [],
    );
  }

  /// `Spending Progress`
  String get spendingProgress {
    return Intl.message(
      'Spending Progress',
      name: 'spendingProgress',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Spending Pattern`
  String get monthlyHeatmap {
    return Intl.message(
      'Monthly Spending Pattern',
      name: 'monthlyHeatmap',
      desc: '',
      args: [],
    );
  }

  /// `Daily Avg`
  String get dailyAverage {
    return Intl.message(
      'Daily Avg',
      name: 'dailyAverage',
      desc: '',
      args: [],
    );
  }

  /// `Highest Day`
  String get highestDay {
    return Intl.message(
      'Highest Day',
      name: 'highestDay',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get lightSpending {
    return Intl.message(
      'Light',
      name: 'lightSpending',
      desc: '',
      args: [],
    );
  }

  /// `Heavy`
  String get heavySpending {
    return Intl.message(
      'Heavy',
      name: 'heavySpending',
      desc: '',
      args: [],
    );
  }

  /// `💰 Don’t forget today’s spend!`
  String get dailyExpenseReminderTitle {
    return Intl.message(
      '💰 Don’t forget today’s spend!',
      name: 'dailyExpenseReminderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add your expenses 🪙 and keep your budget on track 📊`
  String get dailyExpenseReminderBody {
    return Intl.message(
      'Add your expenses 🪙 and keep your budget on track 📊',
      name: 'dailyExpenseReminderBody',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent`
  String get passwordResetEmailSent {
    return Intl.message(
      'Password reset email sent',
      name: 'passwordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get forgotPasswordTitle {
    return Intl.message(
      'Reset Password',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a link to reset your password`
  String get forgotPasswordMessage {
    return Intl.message(
      'Enter your email address and we\'ll send you a link to reset your password',
      name: 'forgotPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Pie Chart`
  String get pieChart {
    return Intl.message(
      'Pie Chart',
      name: 'pieChart',
      desc: '',
      args: [],
    );
  }

  /// `Bar Chart`
  String get barChart {
    return Intl.message(
      'Bar Chart',
      name: 'barChart',
      desc: '',
      args: [],
    );
  }

  /// `Line Chart`
  String get lineChart {
    return Intl.message(
      'Line Chart',
      name: 'lineChart',
      desc: '',
      args: [],
    );
  }

  /// `Trend Chart`
  String get trendChart {
    return Intl.message(
      'Trend Chart',
      name: 'trendChart',
      desc: '',
      args: [],
    );
  }

  /// `Quick Stats`
  String get quickStats {
    return Intl.message(
      'Quick Stats',
      name: 'quickStats',
      desc: '',
      args: [],
    );
  }

  /// `Avg per Transaction`
  String get avgPerTransaction {
    return Intl.message(
      'Avg per Transaction',
      name: 'avgPerTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Highest Category`
  String get highestCategory {
    return Intl.message(
      'Highest Category',
      name: 'highestCategory',
      desc: '',
      args: [],
    );
  }

  /// `Lowest Category`
  String get lowestCategory {
    return Intl.message(
      'Lowest Category',
      name: 'lowestCategory',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get sortByAmount {
    return Intl.message(
      'Amount',
      name: 'sortByAmount',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get sortByCount {
    return Intl.message(
      'Count',
      name: 'sortByCount',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get sortByName {
    return Intl.message(
      'Name',
      name: 'sortByName',
      desc: '',
      args: [],
    );
  }

  /// `Filter Categories`
  String get filterCategories {
    return Intl.message(
      'Filter Categories',
      name: 'filterCategories',
      desc: '',
      args: [],
    );
  }

  /// `Show All`
  String get showAll {
    return Intl.message(
      'Show All',
      name: 'showAll',
      desc: '',
      args: [],
    );
  }

  /// `Top 5`
  String get showTop5 {
    return Intl.message(
      'Top 5',
      name: 'showTop5',
      desc: '',
      args: [],
    );
  }

  /// `Top 10`
  String get showTop10 {
    return Intl.message(
      'Top 10',
      name: 'showTop10',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get categoryFood {
    return Intl.message(
      'Food',
      name: 'categoryFood',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get categoryTransport {
    return Intl.message(
      'Transport',
      name: 'categoryTransport',
      desc: '',
      args: [],
    );
  }

  /// `Entertainment`
  String get categoryEntertainment {
    return Intl.message(
      'Entertainment',
      name: 'categoryEntertainment',
      desc: '',
      args: [],
    );
  }

  /// `Utilities`
  String get categoryUtilities {
    return Intl.message(
      'Utilities',
      name: 'categoryUtilities',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get categoryShopping {
    return Intl.message(
      'Shopping',
      name: 'categoryShopping',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get categoryHealth {
    return Intl.message(
      'Health',
      name: 'categoryHealth',
      desc: '',
      args: [],
    );
  }

  /// `Education`
  String get categoryEducation {
    return Intl.message(
      'Education',
      name: 'categoryEducation',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get categoryTravel {
    return Intl.message(
      'Travel',
      name: 'categoryTravel',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get categoryHome {
    return Intl.message(
      'Home',
      name: 'categoryHome',
      desc: '',
      args: [],
    );
  }

  /// `Fitness`
  String get categoryFitness {
    return Intl.message(
      'Fitness',
      name: 'categoryFitness',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get categoryOther {
    return Intl.message(
      'Other',
      name: 'categoryOther',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning`
  String get goodMorning {
    return Intl.message(
      'Good Morning',
      name: 'goodMorning',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon`
  String get goodAfternoon {
    return Intl.message(
      'Good Afternoon',
      name: 'goodAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good Evening`
  String get goodEvening {
    return Intl.message(
      'Good Evening',
      name: 'goodEvening',
      desc: '',
      args: [],
    );
  }

  /// `Loading dashboard...`
  String get loadingDashboard {
    return Intl.message(
      'Loading dashboard...',
      name: 'loadingDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load dashboard`
  String get failedToLoadDashboard {
    return Intl.message(
      'Failed to load dashboard',
      name: 'failedToLoadDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Initializing dashboard...`
  String get initializingDashboard {
    return Intl.message(
      'Initializing dashboard...',
      name: 'initializingDashboard',
      desc: '',
      args: [],
    );
  }

  /// `spent this month`
  String get spentThisMonth {
    return Intl.message(
      'spent this month',
      name: 'spentThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `{count} days remaining`
  String daysRemaining(int count) {
    return Intl.message(
      '$count days remaining',
      name: 'daysRemaining',
      desc: '',
      args: [count],
    );
  }

  /// `Today`
  String get todayLabel {
    return Intl.message(
      'Today',
      name: 'todayLabel',
      desc: '',
      args: [],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message(
      'This Week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `Daily Avg`
  String get dailyAvg {
    return Intl.message(
      'Daily Avg',
      name: 'dailyAvg',
      desc: '',
      args: [],
    );
  }

  /// `this month`
  String get thisMonthLabel {
    return Intl.message(
      'this month',
      name: 'thisMonthLabel',
      desc: '',
      args: [],
    );
  }

  /// `{count} transactions`
  String transactions(int count) {
    return Intl.message(
      '$count transactions',
      name: 'transactions',
      desc: '',
      args: [count],
    );
  }

  /// `Recent Expenses`
  String get recentExpenses {
    return Intl.message(
      'Recent Expenses',
      name: 'recentExpenses',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Top Categories`
  String get topCategories {
    return Intl.message(
      'Top Categories',
      name: 'topCategories',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message(
      'This Month',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Your recent expenses will appear here`
  String get recentExpensesEmptyTitle {
    return Intl.message(
      'Your recent expenses will appear here',
      name: 'recentExpensesEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start tracking your spending by adding your first expense!`
  String get recentExpensesEmptyMessage {
    return Intl.message(
      'Start tracking your spending by adding your first expense!',
      name: 'recentExpensesEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get main {
    return Intl.message(
      'Dashboard',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `{minutes}m ago`
  String minutesAgo(Object minutes) {
    return Intl.message(
      '${minutes}m ago',
      name: 'minutesAgo',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours}h ago`
  String hoursAgo(Object hours) {
    return Intl.message(
      '${hours}h ago',
      name: 'hoursAgo',
      desc: '',
      args: [hours],
    );
  }

  /// `{days}d ago`
  String daysAgo(Object days) {
    return Intl.message(
      '${days}d ago',
      name: 'daysAgo',
      desc: '',
      args: [days],
    );
  }

  /// `Set PIN Code`
  String get setPinCode {
    return Intl.message(
      'Set PIN Code',
      name: 'setPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPin',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN Code`
  String get enterPinCode {
    return Intl.message(
      'Enter PIN Code',
      name: 'enterPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Create a 4-digit PIN to secure your app`
  String get createPinMessage {
    return Intl.message(
      'Create a 4-digit PIN to secure your app',
      name: 'createPinMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your PIN again`
  String get enterPinAgain {
    return Intl.message(
      'Please enter your PIN again',
      name: 'enterPinAgain',
      desc: '',
      args: [],
    );
  }

  /// `Enter your PIN to access the app`
  String get enterPinToAccess {
    return Intl.message(
      'Enter your PIN to access the app',
      name: 'enterPinToAccess',
      desc: '',
      args: [],
    );
  }

  /// `PINs do not match`
  String get pinsDoNotMatch {
    return Intl.message(
      'PINs do not match',
      name: 'pinsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect PIN`
  String get incorrectPin {
    return Intl.message(
      'Incorrect PIN',
      name: 'incorrectPin',
      desc: '',
      args: [],
    );
  }

  /// `Use Biometric`
  String get useBiometric {
    return Intl.message(
      'Use Biometric',
      name: 'useBiometric',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'uz'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
