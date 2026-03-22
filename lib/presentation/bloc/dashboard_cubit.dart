import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/repositories/transaction_repository.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    required this.summary,
    required this.categories,
    required this.rangeFrom,
    required this.rangeTo,
  });

  final DashboardSummary summary;
  final List<Category> categories;
  final DateTime rangeFrom;
  final DateTime rangeTo;

  @override
  List<Object?> get props => [summary, categories, rangeFrom, rangeTo];
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._dashboardRepo, this._transactionRepo) : super(const DashboardLoading()) {
    _setDefaultMonth();
    _subscribe();
  }

  final DashboardRepository _dashboardRepo;
  final TransactionRepository _transactionRepo;

  StreamSubscription<DashboardSummary>? _summarySub;
  StreamSubscription<List<Category>>? _categoriesSub;

  DashboardSummary? _lastSummary;
  List<Category> _categories = [];
  late DateTime _from;
  late DateTime _to;

  void _setDefaultMonth() {
    final now = DateTime.now();
    _from = DateTime(now.year, now.month);
    _to = _endOfMonth(now);
  }

  DateTime _endOfMonth(DateTime d) {
    final last = DateTime(d.year, d.month + 1, 0);
    return DateTime(last.year, last.month, last.day, 23, 59, 59, 999);
  }

  void _subscribe() {
    _summarySub?.cancel();
    _categoriesSub?.cancel();

    _summarySub = _dashboardRepo.watchSummary(from: _from, to: _to).listen((s) {
      _lastSummary = s;
      _emitLoaded();
    });

    _categoriesSub = _transactionRepo.watchCategories().listen((c) {
      _categories = c;
      _emitLoaded();
    });
  }

  void _emitLoaded() {
    final s = _lastSummary;
    if (s == null) return;
    emit(DashboardLoaded(
      summary: s,
      categories: List.unmodifiable(_categories),
      rangeFrom: _from,
      rangeTo: _to,
    ));
  }

  /// Shift visible month (for dashboard toolbar).
  void setMonth(DateTime month) {
    _from = DateTime(month.year, month.month);
    _to = _endOfMonth(month);
    _lastSummary = null;
    emit(const DashboardLoading());
    _subscribe();
  }

  @override
  Future<void> close() async {
    await _summarySub?.cancel();
    await _categoriesSub?.cancel();
    return super.close();
  }
}
