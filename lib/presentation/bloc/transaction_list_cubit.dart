import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/transaction_repository.dart';

sealed class TransactionListState extends Equatable {
  const TransactionListState();

  @override
  List<Object?> get props => [];
}

class TransactionListLoading extends TransactionListState {
  const TransactionListLoading();
}

class TransactionListReady extends TransactionListState {
  const TransactionListReady(this.transactions);

  final List<domain.Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

class TransactionListCubit extends Cubit<TransactionListState> {
  TransactionListCubit(this._repo) : super(const TransactionListLoading()) {
    _sub = _repo.watchTransactions().listen((list) {
      emit(TransactionListReady(list));
    });
  }

  final TransactionRepository _repo;
  late final StreamSubscription<List<domain.Transaction>> _sub;

  Future<void> delete(int id) => _repo.deleteTransaction(id);

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
