import 'package:flutter/material.dart';
import 'package:wowsinfo/models/Cacheable.dart';
import 'package:wowsinfo/services/data/AppConfiguration.dart';
import 'package:wowsinfo/services/storage/BaseStorage.dart';

/// This includes app locale, theme colour and brightness (light, dark or system)
class AppSettingsManager with ChangeNotifier {
  // Handles how to save AppConfiguration
  BaseStorage _storage;

  AppConfiguration<String, AppBrightness> _appBrightness;
  ThemeMode get appThemeBrightness => _appBrightness.value.themeMode;
  set appThemeBrightness(ThemeMode b) {
    if (b != appThemeBrightness) {
      _appBrightness.value.brightness = b;
      _appBrightness.save();
      _generateTheme();
      notifyListeners();
    }
  }

  AppConfiguration<String, AppThemeColour> _themeColour;
  MaterialColor get primaryColour => _themeColour.value.colour;
  set primaryColour(MaterialColor c) {
    if (c != primaryColour) {
      _themeColour.value.colour = c;
      _themeColour.save();
      _generateTheme();
      notifyListeners();
    }
  }

  AppConfiguration<String, AppLocale> _appLocale;
  Locale get appLocale => _appLocale.value.locale;
  set appLocale(Locale l) {
    if (l != appLocale) {
      _appLocale.value.locale = l;
      _appLocale.save();
      notifyListeners();
    }
  }

  ThemeData _theme;
  ThemeData _darkTheme;
  ThemeData get theme => _theme;
  ThemeData get darkTheme => _darkTheme;

  AppSettingsManager(this._storage) {
    _appBrightness = AppConfiguration(_storage, 'brightness');
    _themeColour = AppConfiguration(_storage, 'colour');
    _appLocale = AppConfiguration(_storage, 'locale');

    // Generate theme based on the data we have
    this._generateTheme();
  }

  Future<void> load() async {
    _appBrightness.load();
    _themeColour.load();
    _appLocale.load();
  }

  /// This will update ThemeData
  _generateTheme() {
    final colour = primaryColour;
    _theme = ThemeData(
      primarySwatch: colour,
    );

    _darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: colour,
      accentColor: colour.shade500,
      indicatorColor: colour.shade500,
    );
  }
}

/// This saves the material app main theme colour
/// - It uses blue colour by default, 5
class AppThemeColour implements Cacheable {
  /// All material colour
  static const THEME_COLOUR_LIST = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    // Orange is removed
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  // This is the main theme colour
  MaterialColor _colour;
  MaterialColor get colour => _colour;
  set colour(MaterialColor c) {
    if (c == _colour) return;
    _colour = c;
  }

  AppThemeColour(int index) {
    this._colour = THEME_COLOUR_LIST[index ?? 5];
  }

  @override
  bool isValid() => _colour != null;

  @override
  output() => THEME_COLOUR_LIST.indexOf(_colour);
}

/// This saves the material app's brightness
/// - It follows system theme by default, 2
class AppBrightness implements Cacheable {
  /// light, dark or follow system
  static const THEME_BRIGHTNESS_MODE = [
    ThemeMode.light,
    ThemeMode.dark,
    ThemeMode.system,
  ];

  // It is called ThemeMode but it is all about app brightness
  ThemeMode _brightness;
  bool get isDarkMode => _brightness == ThemeMode.dark;
  bool get isLightMode => _brightness == ThemeMode.light;
  ThemeMode get themeMode => _brightness;
  set brightness(ThemeMode b) {
    if (b == _brightness) return;
    _brightness = b;
  }

  AppBrightness(int index) {
    _brightness = THEME_BRIGHTNESS_MODE[index ?? 2];
  }

  @override
  bool isValid() => _brightness != null;

  @override
  output() => THEME_BRIGHTNESS_MODE.indexOf(_brightness);
}

/// This saves the material app's main locel
/// - If the locale is null, it means that the app will follow `system language`
class AppLocale implements Cacheable {
  // Locale can be null, it simply follows system!
  Locale _locale;
  Locale get locale => _locale;
  set locale(Locale l) {
    if (l == _locale) return;
    _locale = l;
  }

  AppLocale(String code) {
    if (code != null) {
      if (code.contains('_')) {
        final codes = code.split('_');
        _locale =
            Locale.fromSubtags(countryCode: codes[0], scriptCode: codes[1]);
      } else {
        _locale = Locale(code);
      }
    }
  }

  /// Convert locale object to a string
  String _localeToCode() {
    final scriptCode = _locale.scriptCode;
    final langCode = _locale.languageCode;
    if (scriptCode != null) return langCode + '_' + scriptCode;
    return langCode;
  }

  @override
  bool isValid() => true;

  @override
  output() => _localeToCode();
}
