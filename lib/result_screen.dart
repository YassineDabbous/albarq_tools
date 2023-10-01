import 'package:albarq_tools/data/data.dart';
import 'package:albarq_tools/history_screen.dart';
import 'package:albarq_tools/scanner_screen.dart';
import 'package:albarq_tools/screens/cloud_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class ResultScreen extends StatefulWidget {
  final Item model;

  const ResultScreen({super.key, required this.model});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final player = AudioPlayer();
  final CountingBloc ctrl = CountingBloc();
  bool isOnCloud = false;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  initPlayer() async {
    await player.setAsset('assets/sounds/delete.mp3'); // Schemes: (https: | file: | asset: )
  }

  playSound() async {
    player.seek(Duration.zero);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(brightness: Brightness.dark);
    final textTheme = theme.textTheme;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          // actionsIconTheme: theme.copyWith(brightness: Brightness.dark).appBarTheme.actionsIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Result'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.save),
              onSelected: (value) {
                switch (value) {
                  case '0':
                    save();
                    break;
                  case '1':
                    saveCloud();
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext bc) {
                return [
                  const PopupMenuItem(
                    child: Text("Save offline"),
                    value: '0',
                  ),
                  if (!isOnCloud)
                    const PopupMenuItem(
                      child: Text("Save online"),
                      value: '1',
                    ),
                ];
              },
            ),
            // IconButton(
            //   onPressed: isOnCloud ? null : saveCloud,
            //   icon: const Icon(Icons.cloud_sync),
            // ),
            // IconButton(
            //   onPressed: save,
            //   icon: const Icon(Icons.save),
            // ),
            IconButton(
              onPressed: () {
                if (!widget.model.isLogged) {
                  playSound();
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScannerScreen()));
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              BlocProvider(
                create: (context) => ctrl,
                child: BlocListener<CountingBloc, CountingState>(
                  listener: (context, state) {
                    if (state is CountingSaved) {
                      isOnCloud = true;
                      widget.model.isLogged = true;
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CloudHistoryScreen()));
                    }
                  },
                  child: BlocBuilder<CountingBloc, CountingState>(
                    builder: (context, state) {
                      if (state is CountingSaving) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (state is CountingSaved) {
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.green[800], borderRadius: BorderRadius.circular(4)),
                          child: const Center(child: Text('Saved', style: TextStyle(color: Colors.white))),
                        );
                      }
                      if (state is CountingError) {
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.circular(4)),
                          child: const Center(child: Text('Saving failed', style: TextStyle(color: Colors.white))),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Total:', style: textTheme.titleLarge),
                  Expanded(
                    child: Text(
                      widget.model.count.toString(),
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Date:', style: textTheme.titleLarge),
                  Expanded(
                    child: Text(
                      widget.model.prettyDate,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                    itemCount: widget.model.items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = widget.model.sortedDesc.entries.elementAt(index);
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
        ),
      ),
    );
  }

  save() => showDialog(
        context: context,
        builder: (ctx) {
          TextEditingController c = TextEditingController();
          return AlertDialog(
            content: SizedBox(
              height: 70,
              child: Column(
                children: [
                  const Text('Name'),
                  TextField(controller: c),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    saveList(widget.model..name = c.text).then((value) => setState(() => widget.model.isLogged = true));
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
                  },
                  child: const Text('save'))
            ],
          );
        },
      );

  saveCloud() => showDialog(
        context: context,
        builder: (ctx) {
          TextEditingController c = TextEditingController();
          return AlertDialog(
            content: SizedBox(
              height: 70,
              child: Column(
                children: [
                  const Text('Note'),
                  TextField(controller: c),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ctrl.save(count: widget.model.count, note: c.text, items: widget.model.items);
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('save'))
            ],
          );
        },
      );
}
