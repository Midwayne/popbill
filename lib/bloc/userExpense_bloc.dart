import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popbill/models/user_expense.dart';
import 'package:popbill/services/auth_services.dart';

// Events
abstract class ExpenseEvent {}

class FetchExpenses extends ExpenseEvent {
  final int filterYear;
  final int filterMonth;

  FetchExpenses({required this.filterYear, required this.filterMonth});
}

// States
abstract class ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<UserExpense> expenses;
  final double totalPeriodExpense;

  ExpenseLoaded({required this.expenses, required this.totalPeriodExpense});
}

class ExpenseError extends ExpenseState {
  final String errorMessage;

  ExpenseError({required this.errorMessage});
}

// Cubit
class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit() : super(ExpenseLoading());

  Future<void> fetchExpenses(int filterYear, int filterMonth) async {
    emit(ExpenseLoading());

    try {
      List<UserExpense> expenses = await AuthService().getExpenses(
        filterYear: filterYear,
        filterMonth: filterMonth,
      );

      double totalPeriodExpense =
          expenses.fold(0, (double previousValue, UserExpense expense) {
        return previousValue + expense.amount;
      });

      emit(ExpenseLoaded(
          expenses: expenses, totalPeriodExpense: totalPeriodExpense));
    } catch (e) {
      emit(ExpenseError(
          errorMessage: 'An error occurred while fetching expenses.'));
    }
  }
}
