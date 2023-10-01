import 'package:albarq_tools/data/data.dart';
import 'package:albarq_tools/helpers.dart';
import 'package:albarq_tools/result_screen.dart';
import 'package:albarq_tools/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;
  List<Item>? lista;
  final player = AudioPlayer();

  @override
  void initState() {
    load();
    // initPlayer();
    super.initState();
  }

  initPlayer() async {
    await player.setAsset('assets/sounds/delete.mp3');
  }

  playSound() async {
    player.seek(Duration.zero);
    player.play();
  }

  load() async {
    lista = await getSaved();
    try {} catch (e) {
      print(e);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(brightness: Brightness.dark);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Offline storage'),
          actions: [
            IconButton(
              onPressed: () => dialogConfirmation(
                  context: context,
                  onConfirm: () {
                    clear();
                    playSound();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScannerScreen()));
                  }),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
            ),
            const SizedBox(width: 30),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScannerScreen()));
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : (lista == null
                  ? const Center(child: Text('no history'))
                  : Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                              itemCount: lista?.length ?? 0,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final item = lista!.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    item.name.isEmpty ? '---' : item.name,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(item.prettyDate),
                                      SizedBox(height: 8),
                                      Text('Total ${item.count}'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultScreen(model: item)));
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
