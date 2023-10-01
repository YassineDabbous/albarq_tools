class Login {
  String? phone;
  String? password;
  Login({this.phone, this.password});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['device_name'] = 'Flutter app'; // Platform.isAndroid ? 'Flutter on Android' : 'Flutter on iPhone';
    return data;
  }
}

class OrderCountingRequest {
  int count;
  String? note;
  Map<String, int> vouchers;
  OrderCountingRequest({required this.count, required this.vouchers, this.note});
  Map<String, dynamic> toJson() => {'orders_count': count, 'note': note, 'vouchers': vouchers}..removeWhere((key, value) => value == null);
}
