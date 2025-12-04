import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class TranslationService extends Translations {
  static final fallbackLocale = Locale('en', 'US');
  static final locales = [Locale('en', 'US'), Locale('ur', 'PK')];

  Map<String, Map<String, String>> translations = {};

  Future<void> init() async {
    translations['en_US'] = await _loadJson('assets/lang/en_US.json');
    translations['ur_PK'] = await _loadJson('assets/lang/ur_PK.json');
  }

  Future<Map<String, String>> _loadJson(String path) async {
    final data = await rootBundle.loadString(path);
    return Map<String, String>.from(json.decode(data));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;
}
