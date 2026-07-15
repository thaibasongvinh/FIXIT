enum AppFlavor {
  dev,
  prod;

  String get name => switch (this) {
        AppFlavor.dev => 'dev',
        AppFlavor.prod => 'prod',
      };

  String get label => switch (this) {
        AppFlavor.dev => 'DEV',
        AppFlavor.prod => 'PROD',
      };

  String get appTitle => switch (this) {
        AppFlavor.dev => 'FIXIT_DEV',
        AppFlavor.prod => 'FIXIT',
      };

  bool get isDev => this == AppFlavor.dev;
}

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    this.enableSeedData = false,
    this.allowClientWalletMutation = false,
    required this.appwriteEndpoint,
    required this.appwriteProjectId,
    required this.appwriteDatabaseId,
  });

  const AppEnvironment.dev({
    bool enableSeedData = false,
    String? appwriteEndpoint,
    String? appwriteProjectId,
    String appwriteDatabaseId = 'database-default',
  }) : this(
          flavor: AppFlavor.dev,
          enableSeedData: enableSeedData,
          allowClientWalletMutation: true,
          appwriteEndpoint: appwriteEndpoint ?? 'https://sgp.cloud.appwrite.io/v1',
          appwriteProjectId: appwriteProjectId ?? '6a145b8d001aa82f4dd5',
          appwriteDatabaseId: appwriteDatabaseId,
        );

  const AppEnvironment.prod({
    required String appwriteEndpoint,
    required String appwriteProjectId,
    String appwriteDatabaseId = 'database-default',
  }) : this(
          flavor: AppFlavor.prod,
          allowClientWalletMutation: false,
          appwriteEndpoint: appwriteEndpoint,
          appwriteProjectId: appwriteProjectId,
          appwriteDatabaseId: appwriteDatabaseId,
        );

  final AppFlavor flavor;
  final bool enableSeedData;
  final bool allowClientWalletMutation;
  final String appwriteEndpoint;
  final String appwriteProjectId;
  final String appwriteDatabaseId;

  String get appTitle => flavor.appTitle;
}
