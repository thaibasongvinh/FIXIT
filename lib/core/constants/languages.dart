class AppLanguage {
  final String name;
  final String code;
  final String flag;

  const AppLanguage({
    required this.name,
    required this.code,
    required this.flag,
  });
}

const List<AppLanguage> supportedLanguages = [
  AppLanguage(name: 'Tiếng Việt', code: 'vi', flag: '🇻🇳'),
  AppLanguage(name: 'English', code: 'en', flag: '🇺🇸'),
  AppLanguage(name: '日本語', code: 'ja', flag: '🇯🇵'),
  AppLanguage(name: '한국어', code: 'ko', flag: '🇰🇷'),
  AppLanguage(name: '中文', code: 'zh', flag: '🇨🇳'),
  AppLanguage(name: 'Français', code: 'fr', flag: '🇫🇷'),
  AppLanguage(name: 'Deutsch', code: 'de', flag: '🇩🇪'),
  AppLanguage(name: 'Español', code: 'es', flag: '🇪🇸'),
  AppLanguage(name: 'Italiano', code: 'it', flag: '🇮🇹'),
  AppLanguage(name: 'Português', code: 'pt', flag: '🇵🇹'),
  AppLanguage(name: 'Русский', code: 'ru', flag: '🇷🇺'),
  AppLanguage(name: 'العربية', code: 'ar', flag: '🇸🇦'),
  AppLanguage(name: 'हिन्दी', code: 'hi', flag: '🇮🇳'),
  AppLanguage(name: 'Bahasa Indonesia', code: 'id', flag: '🇮🇩'),
  AppLanguage(name: 'Bahasa Melayu', code: 'ms', flag: '🇲🇾'),
  AppLanguage(name: 'ไทย', code: 'th', flag: '🇹🇭'),
  AppLanguage(name: 'Filipino', code: 'tl', flag: '🇵🇭'),
  AppLanguage(name: 'Türkçe', code: 'tr', flag: '🇹🇷'),
  AppLanguage(name: 'Nederlands', code: 'nl', flag: '🇳🇱'),
  AppLanguage(name: 'Polski', code: 'pl', flag: '🇵🇱'),
  AppLanguage(name: 'Svenska', code: 'sv', flag: '🇸🇪'),
  AppLanguage(name: 'Afghani', code: 'ps', flag: '🇦🇫'),
  AppLanguage(name: 'Հայերեն', code: 'hy', flag: '🇦🇲'),
  AppLanguage(name: 'Azərbaycan', code: 'az', flag: '🇦🇿'),
  AppLanguage(name: 'بحريني', code: 'ar', flag: '🇧🇭'),
  AppLanguage(name: 'বাংলা', code: 'bn', flag: '🇧🇩'),
  AppLanguage(name: 'Dzongkha', code: 'dz', flag: '🇧🇹'),
  AppLanguage(name: 'Melayu Brunei', code: 'ms', flag: '🇧🇳'),
  AppLanguage(name: 'ខ្មែر', code: 'km', flag: '🇰🇭'),
  AppLanguage(name: 'Ελληνικά', code: 'el', flag: '🇨🇾'),
  AppLanguage(name: 'ქართული', code: 'ka', flag: '🇬🇪'),
  AppLanguage(name: 'فارسی', code: 'fa', flag: '🇮🇷'),
  AppLanguage(name: 'Kurdî', code: 'ku', flag: '🇮🇶'),
  AppLanguage(name: 'עברית', code: 'he', flag: '🇮🇱'),
  AppLanguage(name: 'اردو', code: 'ur', flag: '🇵🇰'),
  AppLanguage(name: 'සිංහල', code: 'si', flag: '🇱🇰'),
  AppLanguage(name: 'Lao', code: 'lo', flag: '🇱🇦'),
  AppLanguage(name: 'Монгол', code: 'mn', flag: '🇲🇳'),
  AppLanguage(name: 'ဗမာစာ', code: 'my', flag: '🇲🇲'),
  AppLanguage(name: 'नेपाली', code: 'ne', flag: '🇳🇵'),
  AppLanguage(name: 'Тоҷиκӣ', code: 'tg', flag: '🇹🇯'),
  AppLanguage(name: 'Türkmen dili', code: 'tk', flag: '🇹🇲'),
  AppLanguage(name: 'Oʻzbek', code: 'uz', flag: '🇺🇿'),
];
