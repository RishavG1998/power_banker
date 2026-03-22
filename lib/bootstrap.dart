import 'package:flutter/widgets.dart';

import 'core/di/app_dependencies.dart';

Future<AppDependencies> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  return AppDependencies.create();
}
