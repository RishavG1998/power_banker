import '../../domain/entities/category.dart' as domain;
import '../datasources/local/app_database.dart';

domain.Category mapCategoryRow(CategoryRow row) {
  return domain.Category(
    id: row.id,
    name: row.name,
    colorValue: row.colorValue,
  );
}
