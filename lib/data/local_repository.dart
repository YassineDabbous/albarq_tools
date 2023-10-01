import 'dart:convert';

import 'package:albarq_tools/data/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future clear() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future saveList(Item item) async {
  final oldList = (await getSaved()) ?? [];
  oldList.add(item);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(History.key, jsonEncode(History(logs: oldList).toJson()));
}

Future<List<Item>?> getSaved() async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getString(History.key);
  if (data != null) {
    final history = History.fromJson(jsonDecode(data));
    return history.logs; //.map((e) => Item.fromJson(e)..isLogged = true).toList();
  }
  return null;
}
