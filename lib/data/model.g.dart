// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as int?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      accountType: json['account_type'] as int?,
      token: json['token'] as String?,
      rating: json['rating'] as int?,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'account_type': instance.accountType,
      'name': instance.name,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'token': instance.token,
      'rating': instance.rating,
    };

OrderCountingLog _$OrderCountingLogFromJson(Map<String, dynamic> json) =>
    OrderCountingLog(
      id: json['id'] as int,
      ordersCount: json['orders_count'] as int,
      createdAt: json['created_at'] as String,
      reportUrl: json['report_url'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderCountingLogToJson(OrderCountingLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orders_count': instance.ordersCount,
      'created_at': instance.createdAt,
      'report_url': instance.reportUrl,
      'note': instance.note,
    };
