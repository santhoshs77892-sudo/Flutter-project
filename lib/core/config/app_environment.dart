enum AppEnvironment {
  dev,
  staging,
  prod;

  static AppEnvironment current = AppEnvironment.dev;

  bool get isProduction => this == AppEnvironment.prod;
}
