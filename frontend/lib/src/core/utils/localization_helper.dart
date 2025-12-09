import 'dart:convert';
import 'package:flutter/material.dart';

String getLocalized(BuildContext context, dynamic content) {
  if (content == null) return '';

  Map<String, dynamic>? map;

  if (content is Map) {
    map = Map<String, dynamic>.from(content);
  } else if (content is String) {
    try {
      // Try to parse as JSON
      final decoded = jsonDecode(content);
      if (decoded is Map) {
        map = Map<String, dynamic>.from(decoded);
      } else {
        return content; // Not a map (maybe just a string)
      }
    } catch (e) {
      return content; // Not JSON, return as is
    }
  }

  if (map != null) {
    final locale = Localizations.localeOf(context).languageCode;
    if (map.containsKey(locale)) return map[locale].toString();
    if (map.containsKey('zh') &&
        (locale == 'zh' || locale == 'zh_TW' || locale == 'zh_HK'))
      return map['zh'].toString();
    if (map.containsKey('en')) return map['en'].toString();
    if (map.values.isNotEmpty) return map.values.first.toString();
  }

  return content.toString();
}
