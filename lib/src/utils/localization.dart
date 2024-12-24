import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultLocale = Locale('tr', 'TR');

class LocalizationManager extends ChangeNotifier {
  static final LocalizationManager _instance = LocalizationManager._internal();

  factory LocalizationManager() {
    return _instance;
  }

  LocalizationManager._internal();

  Locale get currentLocale => preferredLocales.first;

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future<void> changeLanguage(Locale locale) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("preferred_language", locale.toString());
    await loadPreferredLocales();
    notifyListeners();
  }

  List<Locale>? _preferredLocales;

  List<Locale> get preferredLocales =>
      _preferredLocales ??
      [
        const Locale("en", "US"),
      ];

  Future<void> loadPreferredLocales() async {
    final pref = await SharedPreferences.getInstance();
    final preferred = pref.getString("preferred_language");
    final preferredSet = List<Locale>.from(PlatformDispatcher.instance.locales)
        .where((element) => element.countryCode != null)
        .toList();

    if (preferred != null) {
      preferredSet.removeWhere((element) => element.toString() == preferred);
      preferredSet.insert(0, parseLocale(preferred));
    }

    if (!preferredSet.contains(defaultLocale)) {
      preferredSet.add(defaultLocale);
    }
    _preferredLocales = preferredSet;
  }

  // Future<void> init() async {
  //   await _checkCache();
  //   final res = await API().public.getSupportedLanguages();
  //   _supportedLanguages =
  //       (res as Map).map((key, value) => MapEntry(parseLocale(key), value));

  //   final toRemove = [];

  //   for (var locale in preferredLocales) {
  //     final v = supportedLanguages[locale];
  //     if (v == null) {
  //       toRemove.add(locale);
  //     }
  //   }

  //   for (var locale in toRemove) {
  //     _preferredLocales!.remove(locale);
  //   }

  //   if (kDebugMode) {
  //     print(
  //         "Language Service initialized with ${_preferredLocales!.length} languages. \nSupported Languages: ${supportedLanguages.keys.map((e) => e.toString()).join(", ")}");
  //   }

  //   notifyListeners();
  // }

  Map<Locale, int>? _supportedLanguages;

  Map<Locale, int> get supportedLanguages =>
      _supportedLanguages ??
      {
        defaultLocale: 0,
      };

  // Future<void> removeLocalCaches() async {
  //   final tempDir = Directory.systemTemp;
  //   final dir = Directory("${tempDir.path}/imggen_locale");
  //   if (await dir.exists()) {
  //     await dir.delete(recursive: true);
  //   }
  // }

  // Future<void> _checkCache() async {
  //   final tempDir = Directory.systemTemp;
  //   final dir = Directory("${tempDir.path}/imggen_locale");
  //   if (!await dir.exists()) {
  //     await dir.create();
  //   }
  //   final files = await dir.list().toList();
  //   for (var file in files) {
  //     if (file is File) {
  //       final baseName = p.basename(file.path);
  //       final match = RegExp(r"locale-(?<v>\d+)-(?<lang>[a-z]{2}_[A-Z]{2})")
  //           .firstMatch(baseName);
  //       if (match != null) {
  //         final v = int.parse(match.group(1)!);
  //         final lang = match.group(2)!;
  //         final locale = parseLocale(lang);
  //         _localeCache[locale] = v;
  //       }
  //     }
  //   }
  //   return;
  // }

  // Future<Translations> getTranslations(Locale locale, int v) async {
  //   final tempDir = Directory.systemTemp.path;
  //   final dir = Directory(p.join(tempDir, "imggen_locale"));
  //   if (!await dir.exists()) {
  //     await dir.create();
  //   }
  //   final file = File(p.join(dir.path, "locale-$v-$locale.json"));

  //   if (await file.exists()) {
  //     final res = jsonDecode(await file.readAsString());

  //     return res;
  //   }

  //   final res = await API().public.getLocale(
  //         lang: locale.toString(),
  //       );
  //   await file.writeAsString(jsonEncode(res["translations"]));

  //   return res["translations"];
  // }
}

Locale parseLocale(String s) {
  final parts = s.split('_');
  return Locale(parts[0], parts[1]);
}
