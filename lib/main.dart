import 'package:flutter/material.dart';

import 'app.dart';
import 'bootstrap.dart';

void main() async {
  final deps = await bootstrap();
  runApp(PowerBankerApp(deps: deps));
}
