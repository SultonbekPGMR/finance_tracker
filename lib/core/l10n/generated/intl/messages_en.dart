// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(amount) => "Expenses: ${amount}";

  static String m1(amount) => "Invalid amount: ${amount}";

  static String m2(amount) => "Total Spent: ${amount}";

  static String m3(count) => "${count} transactions";

  static String m4(details) => "Unknown error: ${details}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addExpense": MessageLookupByLibrary.simpleMessage("Add Expense"),
        "adding": MessageLookupByLibrary.simpleMessage("Adding..."),
        "allCategories": MessageLookupByLibrary.simpleMessage("All Categories"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Finance Tracker"),
        "authenticationError": MessageLookupByLibrary.simpleMessage(
            "Authentication error occurred"),
        "badRequest": MessageLookupByLibrary.simpleMessage("Invalid request"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "category": MessageLookupByLibrary.simpleMessage("Category"),
        "categoryBreakdown":
            MessageLookupByLibrary.simpleMessage("Category Breakdown"),
        "categoryComparison":
            MessageLookupByLibrary.simpleMessage("Category Comparison"),
        "categoryNotFound":
            MessageLookupByLibrary.simpleMessage("Category not found"),
        "charts": MessageLookupByLibrary.simpleMessage("Charts"),
        "confirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "connectionTimeout":
            MessageLookupByLibrary.simpleMessage("Connection timeout"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "dailyAverage": MessageLookupByLibrary.simpleMessage("Daily Avg"),
        "dailyExpensesTrend":
            MessageLookupByLibrary.simpleMessage("Daily Expenses Trend"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "dataFormatError":
            MessageLookupByLibrary.simpleMessage("Data format error"),
        "dateHint": MessageLookupByLibrary.simpleMessage("Choose expense date"),
        "dayTotal": m0,
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this expense?"),
        "deleteError":
            MessageLookupByLibrary.simpleMessage("Error deleting expense"),
        "deleteExpense": MessageLookupByLibrary.simpleMessage("Delete Expense"),
        "deleteSuccess": MessageLookupByLibrary.simpleMessage(
            "Expense deleted successfully"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "displayName": MessageLookupByLibrary.simpleMessage("Display Name"),
        "dontHaveAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "editName": MessageLookupByLibrary.simpleMessage("Edit Name"),
        "emailAlreadyInUse":
            MessageLookupByLibrary.simpleMessage("Email is already in use"),
        "emailHint": MessageLookupByLibrary.simpleMessage("Email"),
        "enterAmount": MessageLookupByLibrary.simpleMessage("Enter amount"),
        "enterDescription":
            MessageLookupByLibrary.simpleMessage("Enter description"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "errorLoadingExpenses":
            MessageLookupByLibrary.simpleMessage("Error loading expenses"),
        "errorLoadingProfile":
            MessageLookupByLibrary.simpleMessage("Error loading profile"),
        "expenseAddedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Expense added successfully"),
        "expenseNotFound":
            MessageLookupByLibrary.simpleMessage("Expense not found"),
        "expenseUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Expense updated successfully"),
        "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
        "expensesByCategory":
            MessageLookupByLibrary.simpleMessage("Expenses by Category"),
        "exportData": MessageLookupByLibrary.simpleMessage("Export Data"),
        "failedToAddExpense":
            MessageLookupByLibrary.simpleMessage("Failed to add expense"),
        "failedToLoadCategories":
            MessageLookupByLibrary.simpleMessage("Failed to load categories"),
        "forbidden": MessageLookupByLibrary.simpleMessage("Access forbidden"),
        "haveAccount":
            MessageLookupByLibrary.simpleMessage("Do you have an account?"),
        "heavySpending": MessageLookupByLibrary.simpleMessage("Heavy"),
        "highestDay": MessageLookupByLibrary.simpleMessage("Highest Day"),
        "income": MessageLookupByLibrary.simpleMessage("Income"),
        "info": MessageLookupByLibrary.simpleMessage("Info"),
        "invalidAmountWithValue": m1,
        "invalidCredentials":
            MessageLookupByLibrary.simpleMessage("Invalid email or password"),
        "invalidEmail":
            MessageLookupByLibrary.simpleMessage("Invalid email address"),
        "invalidPassword":
            MessageLookupByLibrary.simpleMessage("Wrong password"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "lightSpending": MessageLookupByLibrary.simpleMessage("Light"),
        "loadingExpenses":
            MessageLookupByLibrary.simpleMessage("Loading expenses..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "moneyTracker": MessageLookupByLibrary.simpleMessage("Money Tracker"),
        "monthlyHeatmap":
            MessageLookupByLibrary.simpleMessage("Monthly Spending Pattern"),
        "networkError":
            MessageLookupByLibrary.simpleMessage("Network error occurred"),
        "noDescription": MessageLookupByLibrary.simpleMessage("No description"),
        "noExpensesFound":
            MessageLookupByLibrary.simpleMessage("No expenses found"),
        "noInternetConnection":
            MessageLookupByLibrary.simpleMessage("No internet connection"),
        "notFound": MessageLookupByLibrary.simpleMessage("Resource not found"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "operationNotAllowed": MessageLookupByLibrary.simpleMessage(
            "This operation is not allowed"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordsDontMatch":
            MessageLookupByLibrary.simpleMessage("Passwords don\'t match"),
        "permissionDenied":
            MessageLookupByLibrary.simpleMessage("Permission denied"),
        "pleaseEnterAmount":
            MessageLookupByLibrary.simpleMessage("Please enter an amount"),
        "pleaseEnterDescription":
            MessageLookupByLibrary.simpleMessage("Please enter a description"),
        "pleaseEnterValidAmount":
            MessageLookupByLibrary.simpleMessage("Please enter a valid amount"),
        "pleaseSelectCategory":
            MessageLookupByLibrary.simpleMessage("Please select a category"),
        "pleaseSelectDate":
            MessageLookupByLibrary.simpleMessage("Please select a date"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "records": MessageLookupByLibrary.simpleMessage("Records"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "requestCancelled":
            MessageLookupByLibrary.simpleMessage("Request was cancelled"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving..."),
        "searchExpenses":
            MessageLookupByLibrary.simpleMessage("Search expenses..."),
        "selectCategory":
            MessageLookupByLibrary.simpleMessage("Select a category"),
        "selectCurrency":
            MessageLookupByLibrary.simpleMessage("Select Currency"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Select Date"),
        "selectLanguage":
            MessageLookupByLibrary.simpleMessage("Select Language"),
        "selectMonth": MessageLookupByLibrary.simpleMessage("Select Month"),
        "selectMonthToView": MessageLookupByLibrary.simpleMessage(
            "Select a month to view statistics"),
        "selectTheme": MessageLookupByLibrary.simpleMessage("Select Theme"),
        "selectedCategory":
            MessageLookupByLibrary.simpleMessage("Currently selected"),
        "serverError":
            MessageLookupByLibrary.simpleMessage("Server error occurred"),
        "setName": MessageLookupByLibrary.simpleMessage("Set Name"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "signOutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to sign out?"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "spendingProgress":
            MessageLookupByLibrary.simpleMessage("Spending Progress"),
        "startAddingExpenses": MessageLookupByLibrary.simpleMessage(
            "Start by adding your first expense"),
        "storageError":
            MessageLookupByLibrary.simpleMessage("Storage error occurred"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "swipeToViewCharts": MessageLookupByLibrary.simpleMessage(
            "Swipe to view different charts"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "tooManyRequests": MessageLookupByLibrary.simpleMessage(
            "Too many requests. Please try again later"),
        "topSpendingCategory":
            MessageLookupByLibrary.simpleMessage("Highest spending category"),
        "totalSpent": m2,
        "transactionCount": m3,
        "unauthorized":
            MessageLookupByLibrary.simpleMessage("Unauthorized access"),
        "unknownError":
            MessageLookupByLibrary.simpleMessage("An unknown error occurred"),
        "unknownErrorWithDetails": m4,
        "updateError":
            MessageLookupByLibrary.simpleMessage("Error updating expense"),
        "updateExpense": MessageLookupByLibrary.simpleMessage("Update Expense"),
        "userDisabled": MessageLookupByLibrary.simpleMessage(
            "This account has been disabled"),
        "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "weakPassword":
            MessageLookupByLibrary.simpleMessage("Password is too weak"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday")
      };
}
