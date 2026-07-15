export '../../app/fixit_app.dart';

import '../../app/bootstrap.dart';
import '../config/app_flavor.dart';

Future<void> main() => bootstrap(
      AppEnvironment.dev(
        enableSeedData: const bool.fromEnvironment(
          'ENABLE_APPWRITE_SEED',
          defaultValue: true,
        ),
      ),
    );
