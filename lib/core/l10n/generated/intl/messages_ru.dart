// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(amount) => "Расходы: ${amount}";

  static String m1(days) => "${days}д назад";

  static String m2(count) => "осталось ${count} дней";

  static String m3(hours) => "${hours}ч назад";

  static String m4(amount) => "Неверная сумма: ${amount}";

  static String m5(minutes) => "${minutes}м назад";

  static String m6(amount) => "Всего потрачено: ${amount}";

  static String m7(count) => "${count} транзакций";

  static String m8(count) => "${count} транзакций";

  static String m9(details) => "Неизвестная ошибка: ${details}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addExpense": MessageLookupByLibrary.simpleMessage("Добавить расход"),
        "adding": MessageLookupByLibrary.simpleMessage("Добавление..."),
        "allCategories": MessageLookupByLibrary.simpleMessage("Все категории"),
        "amount": MessageLookupByLibrary.simpleMessage("Сумма"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Трекер Финансов"),
        "authenticationError": MessageLookupByLibrary.simpleMessage(
            "Произошла ошибка аутентификации"),
        "avgPerTransaction":
            MessageLookupByLibrary.simpleMessage("Среднее за транзакцию"),
        "badRequest": MessageLookupByLibrary.simpleMessage("Неверный запрос"),
        "barChart": MessageLookupByLibrary.simpleMessage("Столбчатая"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "category": MessageLookupByLibrary.simpleMessage("Категория"),
        "categoryBreakdown":
            MessageLookupByLibrary.simpleMessage("Разбивка по категориям"),
        "categoryComparison":
            MessageLookupByLibrary.simpleMessage("Сравнение категорий"),
        "categoryEducation":
            MessageLookupByLibrary.simpleMessage("Образование"),
        "categoryEntertainment":
            MessageLookupByLibrary.simpleMessage("Развлечения"),
        "categoryFitness": MessageLookupByLibrary.simpleMessage("Фитнес"),
        "categoryFood": MessageLookupByLibrary.simpleMessage("Еда"),
        "categoryHealth": MessageLookupByLibrary.simpleMessage("Здоровье"),
        "categoryHome": MessageLookupByLibrary.simpleMessage("Дом"),
        "categoryNotFound":
            MessageLookupByLibrary.simpleMessage("Категория не найдена"),
        "categoryOther": MessageLookupByLibrary.simpleMessage("Прочее"),
        "categoryShopping": MessageLookupByLibrary.simpleMessage("Покупки"),
        "categoryTransport": MessageLookupByLibrary.simpleMessage("Транспорт"),
        "categoryTravel": MessageLookupByLibrary.simpleMessage("Путешествия"),
        "categoryUtilities":
            MessageLookupByLibrary.simpleMessage("Коммунальные услуги"),
        "charts": MessageLookupByLibrary.simpleMessage("Диаграммы"),
        "confirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("Подтвердите пароль"),
        "confirmPin": MessageLookupByLibrary.simpleMessage("Подтвердить PIN"),
        "connectionTimeout": MessageLookupByLibrary.simpleMessage(
            "Время ожидания соединения истекло"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
        "createPinMessage": MessageLookupByLibrary.simpleMessage(
            "Создайте 4-значный PIN-код для защиты приложения"),
        "currency": MessageLookupByLibrary.simpleMessage("Валюта"),
        "dailyAverage": MessageLookupByLibrary.simpleMessage("Среднее в день"),
        "dailyAvg": MessageLookupByLibrary.simpleMessage("Среднее в день"),
        "dailyExpenseReminderBody": MessageLookupByLibrary.simpleMessage(
            "Добавьте свои расходы 🪙 и контролируйте бюджет 📊"),
        "dailyExpenseReminderTitle": MessageLookupByLibrary.simpleMessage(
            "💰 Не забудьте о сегодняшних тратах!"),
        "dailyExpensesTrend":
            MessageLookupByLibrary.simpleMessage("Тренд ежедневных расходов"),
        "dark": MessageLookupByLibrary.simpleMessage("Темная"),
        "dataFormatError":
            MessageLookupByLibrary.simpleMessage("Ошибка формата данных"),
        "dateHint":
            MessageLookupByLibrary.simpleMessage("Выберите дату расхода"),
        "dayTotal": m0,
        "daysAgo": m1,
        "daysRemaining": m2,
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите удалить этот расход?"),
        "deleteError":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления расхода"),
        "deleteExpense": MessageLookupByLibrary.simpleMessage("Удалить расход"),
        "deleteSuccess":
            MessageLookupByLibrary.simpleMessage("Расход успешно удален"),
        "description": MessageLookupByLibrary.simpleMessage("Описание"),
        "displayName": MessageLookupByLibrary.simpleMessage("Отображаемое имя"),
        "dontHaveAccount":
            MessageLookupByLibrary.simpleMessage("Нет аккаунта?"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "editName": MessageLookupByLibrary.simpleMessage("Изменить имя"),
        "emailAlreadyInUse":
            MessageLookupByLibrary.simpleMessage("Email уже используется"),
        "emailHint": MessageLookupByLibrary.simpleMessage("Электронная почта"),
        "emailRequired":
            MessageLookupByLibrary.simpleMessage("Email обязателен"),
        "enterAmount": MessageLookupByLibrary.simpleMessage("Введите сумму"),
        "enterDescription":
            MessageLookupByLibrary.simpleMessage("Введите описание"),
        "enterPinAgain": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите PIN-код еще раз"),
        "enterPinCode": MessageLookupByLibrary.simpleMessage("Введите PIN-код"),
        "enterPinToAccess": MessageLookupByLibrary.simpleMessage(
            "Введите PIN-код для доступа к приложению"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "errorLoadingExpenses":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки расходов"),
        "errorLoadingProfile":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки профиля"),
        "expenseAddedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Расход успешно добавлен"),
        "expenseNotFound":
            MessageLookupByLibrary.simpleMessage("Расход не найден"),
        "expenseUpdatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Расход успешно обновлен"),
        "expenses": MessageLookupByLibrary.simpleMessage("Расходы"),
        "expensesByCategory":
            MessageLookupByLibrary.simpleMessage("Расходы по категориям"),
        "exportData": MessageLookupByLibrary.simpleMessage("Экспорт данных"),
        "failedToAddExpense":
            MessageLookupByLibrary.simpleMessage("Не удалось добавить расход"),
        "failedToLoadCategories": MessageLookupByLibrary.simpleMessage(
            "Не удалось загрузить категории"),
        "failedToLoadDashboard":
            MessageLookupByLibrary.simpleMessage("Не удалось загрузить панель"),
        "filterCategories":
            MessageLookupByLibrary.simpleMessage("Фильтр категорий"),
        "forbidden": MessageLookupByLibrary.simpleMessage("Доступ запрещен"),
        "forgotPassword": MessageLookupByLibrary.simpleMessage("Забыли пароль"),
        "forgotPasswordMessage": MessageLookupByLibrary.simpleMessage(
            "Введите ваш email адрес и мы отправим вам ссылку для сброса пароля"),
        "forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("Сброс пароля"),
        "goodAfternoon": MessageLookupByLibrary.simpleMessage("Добрый день"),
        "goodEvening": MessageLookupByLibrary.simpleMessage("Добрый вечер"),
        "goodMorning": MessageLookupByLibrary.simpleMessage("Доброе утро"),
        "haveAccount":
            MessageLookupByLibrary.simpleMessage("У вас есть аккаунт?"),
        "heavySpending": MessageLookupByLibrary.simpleMessage("Большие"),
        "highestCategory":
            MessageLookupByLibrary.simpleMessage("Наибольшая категория"),
        "highestDay":
            MessageLookupByLibrary.simpleMessage("День с наибольшими тратами"),
        "hoursAgo": m3,
        "income": MessageLookupByLibrary.simpleMessage("Доходы"),
        "incorrectPin":
            MessageLookupByLibrary.simpleMessage("Неправильный PIN-код"),
        "info": MessageLookupByLibrary.simpleMessage("Информация"),
        "initializingDashboard":
            MessageLookupByLibrary.simpleMessage("Инициализация панели..."),
        "invalidAmountWithValue": m4,
        "invalidCredentials":
            MessageLookupByLibrary.simpleMessage("Неверный email или пароль"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите корректный email"),
        "invalidPassword":
            MessageLookupByLibrary.simpleMessage("Неверный пароль"),
        "language": MessageLookupByLibrary.simpleMessage("Язык"),
        "light": MessageLookupByLibrary.simpleMessage("Светлая"),
        "lightSpending": MessageLookupByLibrary.simpleMessage("Небольшие"),
        "lineChart": MessageLookupByLibrary.simpleMessage("Линейная диаграмма"),
        "loadingDashboard":
            MessageLookupByLibrary.simpleMessage("Загрузка панели..."),
        "loadingExpenses":
            MessageLookupByLibrary.simpleMessage("Загрузка расходов..."),
        "login": MessageLookupByLibrary.simpleMessage("Вход"),
        "lowestCategory":
            MessageLookupByLibrary.simpleMessage("Наименьшая категория"),
        "main": MessageLookupByLibrary.simpleMessage("Главная"),
        "minutesAgo": m5,
        "moneyTracker": MessageLookupByLibrary.simpleMessage("Трекер денег"),
        "monthlyHeatmap":
            MessageLookupByLibrary.simpleMessage("Схема месячных трат"),
        "networkError":
            MessageLookupByLibrary.simpleMessage("Произошла ошибка сети"),
        "noDescription": MessageLookupByLibrary.simpleMessage("Без описания"),
        "noExpensesFound":
            MessageLookupByLibrary.simpleMessage("Расходы не найдены"),
        "noInternetConnection":
            MessageLookupByLibrary.simpleMessage("Нет подключения к интернету"),
        "notFound": MessageLookupByLibrary.simpleMessage("Ресурс не найден"),
        "notifications": MessageLookupByLibrary.simpleMessage("Уведомления"),
        "ok": MessageLookupByLibrary.simpleMessage("ОК"),
        "operationNotAllowed":
            MessageLookupByLibrary.simpleMessage("Эта операция не разрешена"),
        "passwordHint": MessageLookupByLibrary.simpleMessage("Пароль"),
        "passwordResetEmailSent": MessageLookupByLibrary.simpleMessage(
            "Письмо для сброса пароля отправлено"),
        "passwordsDontMatch":
            MessageLookupByLibrary.simpleMessage("Пароли не совпадают"),
        "permissionDenied":
            MessageLookupByLibrary.simpleMessage("Доступ запрещен"),
        "pieChart": MessageLookupByLibrary.simpleMessage("Круговая"),
        "pinsDoNotMatch":
            MessageLookupByLibrary.simpleMessage("PIN-коды не совпадают"),
        "pleaseEnterAmount":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, введите сумму"),
        "pleaseEnterDescription": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите описание"),
        "pleaseEnterValidAmount": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите корректную сумму"),
        "pleaseSelectCategory": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, выберите категорию"),
        "pleaseSelectDate":
            MessageLookupByLibrary.simpleMessage("Пожалуйста, выберите дату"),
        "preferences": MessageLookupByLibrary.simpleMessage("Настройки"),
        "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
        "quickStats":
            MessageLookupByLibrary.simpleMessage("Быстрая статистика"),
        "recentExpenses":
            MessageLookupByLibrary.simpleMessage("Недавние расходы"),
        "recentExpensesEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "Начните отслеживать свои траты, добавив первый расход!"),
        "recentExpensesEmptyTitle": MessageLookupByLibrary.simpleMessage(
            "Здесь появятся ваши недавние расходы"),
        "records": MessageLookupByLibrary.simpleMessage("Расходы"),
        "register": MessageLookupByLibrary.simpleMessage("Регистрация"),
        "reports": MessageLookupByLibrary.simpleMessage("Отчеты"),
        "requestCancelled":
            MessageLookupByLibrary.simpleMessage("Запрос был отменен"),
        "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "saving": MessageLookupByLibrary.simpleMessage("Сохранение..."),
        "searchExpenses":
            MessageLookupByLibrary.simpleMessage("Поиск расходов..."),
        "seeAll": MessageLookupByLibrary.simpleMessage("Посмотреть все"),
        "selectCategory":
            MessageLookupByLibrary.simpleMessage("Выберите категорию"),
        "selectCurrency":
            MessageLookupByLibrary.simpleMessage("Выберите валюту"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Выберите дату"),
        "selectLanguage": MessageLookupByLibrary.simpleMessage("Выберите язык"),
        "selectMonth": MessageLookupByLibrary.simpleMessage("Выберите месяц"),
        "selectMonthToView": MessageLookupByLibrary.simpleMessage(
            "Выберите месяц для просмотра статистики"),
        "selectTheme": MessageLookupByLibrary.simpleMessage("Выберите тему"),
        "selectedCategory":
            MessageLookupByLibrary.simpleMessage("Выбранная в данный момент"),
        "sendResetLink":
            MessageLookupByLibrary.simpleMessage("Отправить ссылку сброса"),
        "serverError":
            MessageLookupByLibrary.simpleMessage("Произошла ошибка сервера"),
        "setName": MessageLookupByLibrary.simpleMessage("Установить имя"),
        "setPinCode":
            MessageLookupByLibrary.simpleMessage("Установить PIN-код"),
        "showAll": MessageLookupByLibrary.simpleMessage("Показать все"),
        "showTop10": MessageLookupByLibrary.simpleMessage("Топ 10"),
        "showTop5": MessageLookupByLibrary.simpleMessage("Топ 5"),
        "signIn": MessageLookupByLibrary.simpleMessage("Войти"),
        "signOut": MessageLookupByLibrary.simpleMessage("Выйти"),
        "signOutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите выйти?"),
        "signUp": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "sortBy": MessageLookupByLibrary.simpleMessage("Сортировать по"),
        "sortByAmount": MessageLookupByLibrary.simpleMessage("Сумме"),
        "sortByCount": MessageLookupByLibrary.simpleMessage("Количеству"),
        "sortByName": MessageLookupByLibrary.simpleMessage("Названию"),
        "spendingProgress":
            MessageLookupByLibrary.simpleMessage("Прогресс трат"),
        "spentThisMonth":
            MessageLookupByLibrary.simpleMessage("потрачено в этом месяце"),
        "startAddingExpenses": MessageLookupByLibrary.simpleMessage(
            "Начните с добавления первого расхода"),
        "storageError":
            MessageLookupByLibrary.simpleMessage("Произошла ошибка хранилища"),
        "success": MessageLookupByLibrary.simpleMessage("Успешно"),
        "swipeToViewCharts": MessageLookupByLibrary.simpleMessage(
            "Проведите для просмотра различных диаграмм"),
        "system": MessageLookupByLibrary.simpleMessage("Системная"),
        "theme": MessageLookupByLibrary.simpleMessage("Тема"),
        "thisMonth": MessageLookupByLibrary.simpleMessage("В этом месяце"),
        "thisMonthLabel": MessageLookupByLibrary.simpleMessage("в этом месяце"),
        "thisWeek": MessageLookupByLibrary.simpleMessage("На этой неделе"),
        "today": MessageLookupByLibrary.simpleMessage("Сегодня"),
        "todayLabel": MessageLookupByLibrary.simpleMessage("Сегодня"),
        "tooManyRequests": MessageLookupByLibrary.simpleMessage(
            "Слишком много запросов. Попробуйте позже"),
        "topCategories": MessageLookupByLibrary.simpleMessage("Топ категорий"),
        "topSpendingCategory": MessageLookupByLibrary.simpleMessage(
            "Категория с наибольшими тратами"),
        "totalSpent": m6,
        "transactionCount": m7,
        "transactions": m8,
        "trendChart": MessageLookupByLibrary.simpleMessage("Диаграмма трендов"),
        "unauthorized":
            MessageLookupByLibrary.simpleMessage("Неавторизованный доступ"),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Произошла неизвестная ошибка"),
        "unknownErrorWithDetails": m9,
        "updateError":
            MessageLookupByLibrary.simpleMessage("Ошибка обновления расхода"),
        "updateExpense":
            MessageLookupByLibrary.simpleMessage("Обновить расход"),
        "useBiometric":
            MessageLookupByLibrary.simpleMessage("Использовать биометрию"),
        "userDisabled": MessageLookupByLibrary.simpleMessage(
            "Этот аккаунт был заблокирован"),
        "userNotFound":
            MessageLookupByLibrary.simpleMessage("Пользователь не найден"),
        "warning": MessageLookupByLibrary.simpleMessage("Предупреждение"),
        "weakPassword":
            MessageLookupByLibrary.simpleMessage("Пароль слишком слабый"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Добро пожаловать"),
        "yesterday": MessageLookupByLibrary.simpleMessage("Вчера")
      };
}
