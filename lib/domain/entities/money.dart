import 'package:equatable/equatable.dart';

/// Amount stored in minor units (e.g. cents) to avoid float drift.
class Money extends Equatable {
  const Money({required this.minorUnits, required this.currencyCode});

  final int minorUnits;
  final String currencyCode;

  double get major => minorUnits / 100;

  @override
  List<Object?> get props => [minorUnits, currencyCode];
}
