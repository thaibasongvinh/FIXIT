class UserSettings {
  final String? userId;
  final String themeMode;
  final String language;

  UserSettings({
    this.userId,
    required this.themeMode,
    required this.language,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['userId'] as String?,
      themeMode: json['themeMode'] as String? ?? 'system',
      language: json['language'] as String? ?? 'vi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      'themeMode': themeMode,
      'language': language,
    };
  }

  UserSettings copyWith({
    String? userId,
    String? themeMode,
    String? language,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}
