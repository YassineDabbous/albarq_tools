import 'package:albarq_tools/data/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

class History {
  static String key = 'history';
  final List<Item> logs;
  History({required this.logs});
  factory History.fromJson(dynamic json) {
    print('---------------------------------------');
    print(json);
    print('---------------------------------------');
    return History(logs: (json['logs'] as Iterable).map((e) => Item.fromJson(e)).toList());
  }
  Map toJson() => {'logs': logs.map((e) => e.toJson()).toList()};
}

class Item {
  String name;
  final String date;
  final int count;
  final Map<String, int> items;
  bool isLogged = false;
  get prettyDate => date.split('.').first.replaceAll(' ', '     ');
  get sortedDesc => Map.fromEntries(items.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
  Item({required this.name, required this.date, required this.count, required this.items});
  factory Item.fromJson(dynamic json) => Item(
        name: json['name'],
        date: json['date'],
        count: json['count'],
        items: (json['items'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as int),
        ),
      );
  Map toJson() => {'name': name, 'date': date, 'count': count, 'items': items};
}

@JsonSerializable()
class Profile {
  int? id;
  int? accountType;
  String? name;
  String? phone;
  String? avatar;
  String? token;
  int? rating;
  String get photo => '$kUrl/storage/$avatar';

  Profile({this.id, this.phone, this.name, this.avatar, this.accountType, this.token, this.rating});
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class OrderCountingLog {
  final int id;
  int ordersCount;
  String createdAt;
  String? reportUrl;
  String? note;

  OrderCountingLog({required this.id, required this.ordersCount, required this.createdAt, this.reportUrl, this.note});
  factory OrderCountingLog.fromJson(Map<String, dynamic> json) => _$OrderCountingLogFromJson(json);
}
