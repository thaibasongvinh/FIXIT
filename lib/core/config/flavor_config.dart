enum Flavor { dev, prod }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String apiBaseUrl,
  }) {
    _instance ??= FlavorConfig._internal(flavor, name, apiBaseUrl);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.apiBaseUrl);

  static FlavorConfig get instance => _instance!;

  static bool isDev() => _instance?.flavor == Flavor.dev;
  static bool isProd() => _instance?.flavor == Flavor.prod;
}
