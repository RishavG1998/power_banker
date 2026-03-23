import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/repositories/transaction_repository.dart';

class AddTransactionState extends Equatable {
  const AddTransactionState({
    this.title = '',
    this.amountText = '',
    this.isExpense = true,
    this.date,
    this.categoryId,
    this.categories = const [],
    this.submitting = false,
    this.errorMessage,
    this.completed = false,
  });

  final String title;
  final String amountText;
  final bool isExpense;
  final DateTime? date;
  final int? categoryId;
  final List<Category> categories;
  final bool submitting;
  final String? errorMessage;
  final bool completed;

  AddTransactionState copyWith({
    String? title,
    String? amountText,
    bool? isExpense,
    DateTime? date,
    int? categoryId,
    List<Category>? categories,
    bool? submitting,
    String? errorMessage,
    bool clearError = false,
    bool? completed,
  }) {
    return AddTransactionState(
      title: title ?? this.title,
      amountText: amountText ?? this.amountText,
      isExpense: isExpense ?? this.isExpense,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      categories: categories ?? this.categories,
      submitting: submitting ?? this.submitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [
        title,
        amountText,
        isExpense,
        date,
        categoryId,
        categories,
        submitting,
        errorMessage,
        completed,
      ];
}

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this._repo) : super(AddTransactionState(date: DateTime.now())) {
    _catSub = _repo.watchCategories().listen((cats) {
      emit(state.copyWith(
        categories: cats,
        categoryId: state.categoryId ?? (cats.isNotEmpty ? cats.first.id : null),
      ));
    });
  }

  final TransactionRepository _repo;
  late final StreamSubscription<List<Category>> _catSub;

  void setTitle(String value) => emit(state.copyWith(title: value, clearError: true));

  void setAmountText(String value) => emit(state.copyWith(amountText: value, clearError: true));

  void setExpense(bool value) => emit(state.copyWith(isExpense: value));

  void setDate(DateTime value) => emit(state.copyWith(date: value));

  void setCategoryId(int? id) => emit(state.copyWith(categoryId: id));

  Future<void> submit() async {
    final title = state.title.trim();
    if (title.isEmpty) {
      emit(state.copyWith(errorMessage: 'Enter a title'));
      return;
    }
    final raw = state.amountText.replaceAll(',', '.').trim();
    final amount = double.tryParse(raw);
    if (amount == null || amount <= 0) {
      emit(state.copyWith(errorMessage: 'Enter a valid amount'));
      return;
    }
    final minor = (amount * 100).round();
    final signed = state.isExpense ? -minor : minor;

    emit(state.copyWith(submitting: true, clearError: true));
    try {
      await _repo.addTransaction(
        title: title,
        amountMinorUnits: signed,
        currencyCode: 'INR',
        occurredAt: state.date ?? DateTime.now(),
        categoryId: state.categoryId,
      );
      emit(state.copyWith(submitting: false, completed: true));
    } catch (e) {
      emit(state.copyWith(submitting: false, errorMessage: 'Could not save'));
    }
  }

  @override
  Future<void> close() async {
    await _catSub.cancel();
    return super.close();
  }
}
