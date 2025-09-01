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

  static String m0(amount) => "Total: ${amount}";

  static String m1(amount) => "Total Spent: ${amount}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addExpense": MessageLookupByLibrary.simpleMessage("Add Expense"),
        "addedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Expense added successfully"),
        "adding": MessageLookupByLibrary.simpleMessage("Adding..."),
        "allCategories": MessageLookupByLibrary.simpleMessage("All Categories"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Finance Tracker"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "category": MessageLookupByLibrary.simpleMessage("Category"),
        "charts": MessageLookupByLibrary.simpleMessage("Charts"),
        "confirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
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
        "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
        "exportData": MessageLookupByLibrary.simpleMessage("Export Data"),
        "failedToAddExpense":
            MessageLookupByLibrary.simpleMessage("Failed to add expense"),
        "failedToLoadCategories":
            MessageLookupByLibrary.simpleMessage("Failed to load categories"),
        "haveAccount":
            MessageLookupByLibrary.simpleMessage("Do you have an account?"),
        "income": MessageLookupByLibrary.simpleMessage("Income"),
        "info": MessageLookupByLibrary.simpleMessage("Info"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "loadingExpenses":
            MessageLookupByLibrary.simpleMessage("Loading expenses..."),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "moneyTracker": MessageLookupByLibrary.simpleMessage("Money Tracker"),
        "noDescription": MessageLookupByLibrary.simpleMessage("No description"),
        "noExpensesFound":
            MessageLookupByLibrary.simpleMessage("No expenses found"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordsDontMatch":
            MessageLookupByLibrary.simpleMessage("Passwords don\'t match"),
        "pleaseEnterAmount":
            MessageLookupByLibrary.simpleMessage("Please enter an amount"),
        "pleaseEnterDescription":
            MessageLookupByLibrary.simpleMessage("Please enter a description"),
        "pleaseEnterValidAmount":
            MessageLookupByLibrary.simpleMessage("Please enter a valid amount"),
        "pleaseSelectCategory":
            MessageLookupByLibrary.simpleMessage("Please select a category"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "records": MessageLookupByLibrary.simpleMessage("Records"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saving": MessageLookupByLibrary.simpleMessage("Saving..."),
        "searchExpenses":
            MessageLookupByLibrary.simpleMessage("Search expenses..."),
        "selectCategory":
            MessageLookupByLibrary.simpleMessage("Select a category"),
        "selectCurrency":
            MessageLookupByLibrary.simpleMessage("Select Currency"),
        "selectLanguage":
            MessageLookupByLibrary.simpleMessage("Select Language"),
        "selectMonth": MessageLookupByLibrary.simpleMessage("Select Month"),
        "selectTheme": MessageLookupByLibrary.simpleMessage("Select Theme"),
        "setName": MessageLookupByLibrary.simpleMessage("Set Name"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
        "signOutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to sign out?"),
        "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "startAddingExpenses": MessageLookupByLibrary.simpleMessage(
            "Start by adding your first expense"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "totalSpent": m1,
        "updateError":
            MessageLookupByLibrary.simpleMessage("Error updating expense"),
        "updateExpense": MessageLookupByLibrary.simpleMessage("Update Expense"),
        "updateSuccess": MessageLookupByLibrary.simpleMessage(
            "Expense updated successfully"),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday")
      };
}
