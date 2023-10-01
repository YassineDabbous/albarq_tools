import 'package:albarq_tools/barcode_screen.dart';
import 'package:albarq_tools/data/data.dart';
import 'package:albarq_tools/history_screen.dart';
import 'package:albarq_tools/scanner_screen.dart';
import 'package:albarq_tools/screens/cloud_history_screen.dart';
import 'package:albarq_tools/screens/login_screen.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  LoginBloc ctrl = LoginBloc();

  @override
  void initState() {
    super.initState();
    whoAmI();
  }

  Profile? me;
  whoAmI() async {
    me = await AuthManager().getCurrentUser();
    setState(() {});
  }

  logout() {
    AuthManager().logout().then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(brightness: Brightness.dark);
    return Theme(
      data: theme,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const Spacer(),
        Center(
          child: SizedBox(
            width: 100,
            child: me?.avatar != null ? Image.network(me!.photo) : Image.asset('assets/imgs/logo.png'),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          me?.name ?? '---',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
        ),
        //
        //
        //
        //
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BarcodeScreen())),
          icon: const Icon(Icons.document_scanner, color: Colors.white),
          label: Text('Barcode Scanner', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
        ),
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScannerScreen())),
          icon: const Icon(Icons.camera, color: Colors.white),
          label: Text('Camera scanner', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
        ),
        //
        //
        //
        //
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen())),
          icon: const Icon(Icons.phone_android, color: Colors.white),
          label: Text('Offline storage', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
        ),
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CloudHistoryScreen())),
          icon: const Icon(Icons.cloud, color: Colors.white),
          label: Text('Online storage', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
        ),
        //
        //
        //
        //
        const SizedBox(height: 30),
        TextButton.icon(
          onPressed: logout,
          icon: const Icon(Icons.logout, color: Colors.white),
          label: Text(
            'Logout',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
        //
        //
        //
        const Spacer(),
        const SizedBox(height: 60),
      ]),
    );
  }
}
