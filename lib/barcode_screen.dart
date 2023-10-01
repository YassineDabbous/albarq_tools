import 'package:albarq_tools/data/model.dart';
import 'package:albarq_tools/history_screen.dart';
import 'package:albarq_tools/result_screen.dart';
import 'package:albarq_tools/screens/cloud_history_screen.dart';
import 'package:albarq_tools/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  TextEditingController c = TextEditingController();
  var focusNode = FocusNode();

  String barcode = '---';
  Map<String, int> products = {
    // "123456": 1,
    // "321654": 2,
    // // "456789": 1,
    // "987654": 3,
    // "123789": 1,
  };
  final player = AudioPlayer(); // Create a player

  @override
  void initState() {
    super.initState();

    focusNode.requestFocus();
    // initPlayer();
  }

  initPlayer() async {
    await player.setAsset('assets/sounds/beep.mp3'); // Schemes: (https: | file: | asset: )
  }

  playSound() async {
    player.seek(Duration.zero);
    player.play();
  }

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(brightness: Brightness.dark);
    final textTheme = theme.textTheme;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Barcode'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CloudHistoryScreen())),
          //   icon: const Icon(color: Colors.white, Icons.cloud_done),
          // ),
          // const SizedBox(width: 30),
          // IconButton(
          //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen())),
          //   icon: const Icon(color: Colors.white, Icons.horizontal_split_sharp),
          // ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    model: Item(
                      name: DateTime.now().toString(),
                      items: products,
                      date: DateTime.now().toString(),
                      count: (products.isEmpty ? 0 : products.values.reduce((a, b) => a + b)),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.receipt_long, color: Colors.white),
          ),
        ],
      ),
      // backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextFormField(
                controller: c,
                focusNode: focusNode,
                onFieldSubmitted: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  playSound();
                  c.clear();
                  setState(() {
                    barcode = value.trim();
                    if (products.containsKey(barcode)) {
                      products[barcode] = products[barcode]! + 1;
                    } else {
                      products.addAll({barcode: 1});
                    }
                  });
                  focusNode.requestFocus();
                },
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'focus here',
                  // suffixIcon: Icon(Icons.receipt),
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 4),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text('Receipt Number', style: textTheme.titleSmall), Text('Duplication', style: textTheme.titleSmall)],
          ),
          const SizedBox(height: 4),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: products.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = products.entries.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.key),
                        Text(
                          item.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.value > 1 ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // save() => showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         TextEditingController c = TextEditingController();
  //         return AlertDialog(
  //           content: SizedBox(
  //             height: 70,
  //             child: Column(
  //               children: [
  //                 const Text('Name'),
  //                 TextField(controller: c),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   saveList(widget.model..name = c.text).then((value) => setState(() => widget.model.isLogged = true));
  //                   Navigator.of(ctx).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
  //                 },
  //                 child: const Text('save'))
  //           ],
  //         );
  //       },
  //     );
}
