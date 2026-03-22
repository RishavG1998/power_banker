import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    this.colorValue,
  });

  final int id;
  final String name;
  final int? colorValue;

  @override
  List<Object?> get props => [id, name, colorValue];
}
