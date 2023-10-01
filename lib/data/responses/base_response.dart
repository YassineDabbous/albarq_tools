// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'base_response.g.dart';

String prettyJson(dynamic json, {int indent = 2}) {
  var spaces = ' ' * indent;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

void printPrettyJson(dynamic json, {int indent = 2}) {
  prettyJson(json, indent: indent).split('\n').forEach((element) => print(element));
}

@JsonSerializable(genericArgumentFactories: true)
class BasicResponse<T> {
  final String? message;
  final List<String>? errors;
  final Map<String, dynamic>? validation;
  final T? data;

  BasicResponse({
    required this.message,
    required this.errors,
    required this.validation,
    required this.data,
  });

  factory BasicResponse.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    //debugPrint(json.toString());
    return _$BasicResponseFromJson<T>(json, fromJsonT);
  }
}

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PaginationResponse<T> {
  int? total;
  List<T>? data;

  PaginationResponse({required this.data, required this.total});

  factory PaginationResponse.fromJson(dynamic json, T Function(dynamic json) fromJsonT) => _$PaginationResponseFromJson<T>(json, fromJsonT);
}

@JsonSerializable()
class Links {
  String? url;
  Object? label; // marra string marra int
  bool? active;

  Links({required this.url, required this.label, required this.active});
  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);
  Map<String, dynamic> toJson() => _$LinksToJson(this);
}
