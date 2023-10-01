import 'package:albarq_tools/data/model.dart';
import 'package:albarq_tools/history_screen.dart';
import 'package:albarq_tools/result_screen.dart';
import 'package:albarq_tools/screens/cloud_history_screen.dart';
import 'package:albarq_tools/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  String? barcode;
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
    initPlayer();
  }

  initPlayer() async {
    await player.setAsset('assets/sounds/beep.mp3'); // Schemes: (https: | file: | asset: )
  }

  playSound() async {
    player.seek(Duration.zero);
    player.play();
  }

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text('Scanner'),
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
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case '0':
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
                  break;
                case '1':
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CloudHistoryScreen()));
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  child: Text("Local storage"),
                  value: '0',
                ),
                PopupMenuItem(
                  child: Text("Cloud storage"),
                  value: '1',
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: BoxFit.contain,
                onDetect: (barcode, args) {
                  playSound();
                  setState(() {
                    this.barcode = barcode.rawValue;
                    if (products.containsKey(this.barcode)) {
                      products[this.barcode!] = products[this.barcode!]! + 1;
                    } else {
                      products.addAll({this.barcode!: 1});
                    }
                  });
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 80,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.torchState,
                          builder: (context, state, child) =>
                              state == TorchState.off ? const Icon(Icons.flash_off, color: Colors.grey) : const Icon(Icons.flash_on, color: Colors.yellow),
                        ),
                        onPressed: () => controller.toggleTorch(),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        color: Colors.white,
                        icon: isStarted ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
                        onPressed: () => setState(() {
                          isStarted ? controller.stop() : controller.start();
                          isStarted = !isStarted;
                        }),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          barcode ?? '---',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.cameraFacingState,
                          builder: (context, state, child) => state == CameraFacing.front ? const Icon(Icons.camera_front) : const Icon(Icons.camera_rear),
                        ),
                        onPressed: () => controller.switchCamera(),
                      ),
                      // IconButton(
                      //   onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen())),
                      //   icon: const Icon(color: Colors.white, Icons.density_small_sharp),
                      // ),
                      const SizedBox(width: 20),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
