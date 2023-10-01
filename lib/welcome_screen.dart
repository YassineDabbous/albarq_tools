import 'dart:convert';

import 'package:albarq_tools/barcode_screen.dart';
import 'package:albarq_tools/data/data.dart';
import 'package:albarq_tools/scanner_screen.dart';
import 'package:albarq_tools/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class CheckResponse {
  final bool status;
  final String message;
  CheckResponse({
    required this.status,
    required this.message,
  });
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = true;
  CheckResponse? data;
  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  checkAuth() async {
    final profile = await auth.getCurrentUser();
    if (profile == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } else {
      go();
    }
  }

  check() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var client = http.Client();
    try {
      var uri = Uri.parse('https://albarqiq.com/api/tools/reciept-counter/${packageInfo.buildNumber}');
      // print(uri.toString());
      final response = await client.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      // print(decodedResponse);
      data = CheckResponse(
        status: decodedResponse['status'] as bool,
        message: decodedResponse['message'] as String,
      );
    } finally {
      client.close();
      isLoading = false;
      setState(() {});
      if (data?.status == true) {
        go();
      }
    }
  }

  go() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BarcodeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: isLoading ? const CircularProgressIndicator() : (data == null ? const Text('welcome') : Text(data?.message ?? 'contact the developer')),
      ),
    );
  }
}
