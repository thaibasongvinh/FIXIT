import '../../app/bootstrap.dart';
import '../config/app_flavor.dart';

Future<void> main() => bootstrap(
      const AppEnvironment.prod(
        appwriteEndpoint: 'https://sgp.cloud.appwrite.io/v1',
        appwriteProjectId: '6a145b8d001aa82f4dd5',
      ),
    );
