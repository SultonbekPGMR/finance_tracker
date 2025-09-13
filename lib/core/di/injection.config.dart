// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:finance_tracker/core/di/injection.dart' as _i610;
import 'package:finance_tracker/core/service/notificaion/notification_service.dart'
    as _i160;
import 'package:finance_tracker/core/service/notificaion/notification_service_impl.dart'
    as _i1036;
import 'package:finance_tracker/feature/auth/data/repository/auth_repository_impl.dart'
    as _i281;
import 'package:finance_tracker/feature/auth/data/service/app_lock_service.dart'
    as _i139;
import 'package:finance_tracker/feature/auth/data/service/app_lock_service_impl.dart'
    as _i393;
import 'package:finance_tracker/feature/auth/domain/repository/auth_repository.dart'
    as _i981;
import 'package:finance_tracker/feature/auth/domain/usecase/get_current_user_usecase.dart'
    as _i848;
import 'package:finance_tracker/feature/auth/domain/usecase/request_password_reset_usecase.dart'
    as _i160;
import 'package:finance_tracker/feature/auth/domain/usecase/sign_in_usecase.dart'
    as _i568;
import 'package:finance_tracker/feature/auth/domain/usecase/sign_up_usecase.dart'
    as _i789;
import 'package:finance_tracker/feature/auth/presentation/bloc/app_lock_cubit.dart'
    as _i31;
import 'package:finance_tracker/feature/auth/presentation/bloc/auth_bloc.dart'
    as _i376;
import 'package:finance_tracker/feature/auth/presentation/bloc/auth_state_cubit.dart'
    as _i572;
import 'package:finance_tracker/feature/chart/domain/usecase/get_chart_data_usecase.dart'
    as _i477;
import 'package:finance_tracker/feature/chart/presentation/bloc/chart_cubit.dart'
    as _i263;
import 'package:finance_tracker/feature/dashboard/domain/usecase/get_dashboard_data_usecase.dart'
    as _i629;
import 'package:finance_tracker/feature/dashboard/presentation/bloc/dashboard_cubit.dart'
    as _i162;
import 'package:finance_tracker/feature/expense/data/repository/expense_repository_impl.dart'
    as _i842;
import 'package:finance_tracker/feature/expense/domain/repository/expense_repository.dart'
    as _i93;
import 'package:finance_tracker/feature/expense/domain/usecase/add_expense_usecase.dart'
    as _i153;
import 'package:finance_tracker/feature/expense/domain/usecase/delete_expense_usecase.dart'
    as _i389;
import 'package:finance_tracker/feature/expense/domain/usecase/get_categories_usecase.dart'
    as _i556;
import 'package:finance_tracker/feature/expense/domain/usecase/get_expense_by_id_usecase.dart'
    as _i28;
import 'package:finance_tracker/feature/expense/domain/usecase/get_expense_stream_usecase.dart'
    as _i170;
import 'package:finance_tracker/feature/expense/domain/usecase/get_expenses_by_filter_usecase.dart'
    as _i0;
import 'package:finance_tracker/feature/expense/domain/usecase/get_expenses_usecase.dart'
    as _i285;
import 'package:finance_tracker/feature/expense/domain/usecase/update_expense_usecase.dart'
    as _i3;
import 'package:finance_tracker/feature/expense/presentation/bloc/expense_details/expense_details_cubit.dart'
    as _i919;
import 'package:finance_tracker/feature/expense/presentation/bloc/expenses_bloc.dart'
    as _i1031;
import 'package:finance_tracker/feature/expense/presentation/bloc/filtered_expenses/filtered_expenses_cubit.dart'
    as _i48;
import 'package:finance_tracker/feature/profile/data/repository/user_repository_impl.dart'
    as _i47;
import 'package:finance_tracker/feature/profile/domain/repository/user_repository.dart'
    as _i892;
import 'package:finance_tracker/feature/profile/presentation/bloc/profile_cubit.dart'
    as _i779;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i556.GetCategoriesUseCase>(() => _i556.GetCategoriesUseCase());
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => firebaseModule.firebaseFirestore);
    gh.lazySingleton<_i981.AuthRepository>(() => _i281.AuthRepositoryImpl());
    gh.lazySingleton<_i160.NotificationService>(
        () => _i1036.FirebaseNotificationService());
    gh.lazySingleton<_i59.FirebaseAuth>(
      () => firebaseModule.firebaseAuth,
      instanceName: 'FirebaseAuth',
    );
    gh.lazySingleton<_i139.AppLockService>(() => _i393.AppLockServiceImpl());
    gh.factory<_i31.AppLockCubit>(
        () => _i31.AppLockCubit(gh<_i139.AppLockService>()));
    gh.lazySingleton<_i93.ExpenseRepository>(() =>
        _i842.ExpenseRepositoryImpl(firestore: gh<_i974.FirebaseFirestore>()));
    gh.factory<_i848.GetCurrentUserUseCase>(
        () => _i848.GetCurrentUserUseCase(gh<_i981.AuthRepository>()));
    gh.factory<_i160.RequestPasswordResetUseCase>(
        () => _i160.RequestPasswordResetUseCase(gh<_i981.AuthRepository>()));
    gh.factory<_i568.SignInUseCase>(
        () => _i568.SignInUseCase(gh<_i981.AuthRepository>()));
    gh.factory<_i789.SignUpUseCase>(
        () => _i789.SignUpUseCase(gh<_i981.AuthRepository>()));
    gh.factory<_i477.GetChartDataUseCase>(() => _i477.GetChartDataUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i285.GetExpensesUseCase>(() => _i285.GetExpensesUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i572.AuthStatusCubit>(
        () => _i572.AuthStatusCubit(gh<_i848.GetCurrentUserUseCase>()));
    gh.factory<_i629.GetDashboardDataUseCase>(
        () => _i629.GetDashboardDataUseCase(
              gh<_i93.ExpenseRepository>(),
              gh<_i848.GetCurrentUserUseCase>(),
            ));
    gh.factory<_i153.AddExpenseUseCase>(() => _i153.AddExpenseUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i389.DeleteExpenseUseCase>(() => _i389.DeleteExpenseUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i0.GetExpensesByFilterUseCase>(
        () => _i0.GetExpensesByFilterUseCase(
              gh<_i93.ExpenseRepository>(),
              gh<_i848.GetCurrentUserUseCase>(),
            ));
    gh.factory<_i28.GetExpenseByIdUseCase>(() => _i28.GetExpenseByIdUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.factory<_i170.GetExpensesStreamUseCase>(
        () => _i170.GetExpensesStreamUseCase(
              gh<_i93.ExpenseRepository>(),
              gh<_i848.GetCurrentUserUseCase>(),
            ));
    gh.factory<_i3.UpdateExpenseUseCase>(() => _i3.UpdateExpenseUseCase(
          gh<_i93.ExpenseRepository>(),
          gh<_i848.GetCurrentUserUseCase>(),
        ));
    gh.lazySingleton<_i892.UserRepository>(() => _i47.UserRepositoryImpl(
        gh<_i59.FirebaseAuth>(instanceName: 'FirebaseAuth')));
    gh.factory<_i48.FilteredExpensesCubit>(
        () => _i48.FilteredExpensesCubit(gh<_i0.GetExpensesByFilterUseCase>()));
    gh.factory<_i919.ExpenseDetailsCubit>(() => _i919.ExpenseDetailsCubit(
          gh<_i153.AddExpenseUseCase>(),
          gh<_i556.GetCategoriesUseCase>(),
          gh<_i3.UpdateExpenseUseCase>(),
        ));
    gh.factory<_i1031.ExpensesBloc>(() => _i1031.ExpensesBloc(
          gh<_i389.DeleteExpenseUseCase>(),
          gh<_i556.GetCategoriesUseCase>(),
          gh<_i170.GetExpensesStreamUseCase>(),
        ));
    gh.factory<_i263.ChartCubit>(
        () => _i263.ChartCubit(gh<_i477.GetChartDataUseCase>()));
    gh.factory<_i779.ProfileCubit>(() => _i779.ProfileCubit(
          gh<_i892.UserRepository>(),
          gh<_i981.AuthRepository>(),
        ));
    gh.factory<_i376.AuthBloc>(() => _i376.AuthBloc(
          gh<_i568.SignInUseCase>(),
          gh<_i789.SignUpUseCase>(),
          gh<_i572.AuthStatusCubit>(),
          gh<_i160.RequestPasswordResetUseCase>(),
        ));
    gh.factory<_i162.DashboardCubit>(
        () => _i162.DashboardCubit(gh<_i629.GetDashboardDataUseCase>()));
    return this;
  }
}

class _$FirebaseModule extends _i610.FirebaseModule {}
