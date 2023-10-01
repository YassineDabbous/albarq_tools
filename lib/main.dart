import 'package:albarq_tools/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        defaultScale: true,
        defaultScaleFactor: 1.1,
        //maxWidth: 1200,
        minWidth: 480,
        breakpoints: const [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        // background: Container(
        //   color: Color(0xFFF5F5F5),
        // ),
      ),
    ),
  );
}

// class MyHome extends StatelessWidget {
//   const MyHome({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Demo Home Page')),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const ScannerScreen(),
//                   ),
//                 );
//               },
//               child: const Text('MobileScanner with Controller'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
