import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_flavor.dart';

final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => const AppEnvironment.dev(),
);
