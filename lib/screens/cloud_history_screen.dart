import 'package:albarq_tools/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CloudHistoryScreen extends StatefulWidget {
  const CloudHistoryScreen({Key? key}) : super(key: key);

  @override
  State<CloudHistoryScreen> createState() => _CloudHistoryScreenState();
}

class _CloudHistoryScreenState extends State<CloudHistoryScreen> {
  final CountingBloc ctrl = CountingBloc();

  @override
  void initState() {
    ctrl.list();
    super.initState();
  }

  listener(context, state) {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(brightness: Brightness.dark);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Online storage"),
      ),
      body: BlocProvider(
        create: (context) => ctrl,
        child: BlocListener<CountingBloc, CountingState>(
          listener: listener,
          child: BlocBuilder<CountingBloc, CountingState>(
            builder: (context, state) {
              print(state.runtimeType);
              return Column(
                children: [
                  if (state is CountingError)
                    Container(
                      height: 50,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.red[800], borderRadius: BorderRadius.circular(4)),
                      child: Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: ctrl.lista.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = ctrl.lista.elementAt(index);
                          return ListTile(
                            leading: item.reportUrl == null
                                ? null
                                : InkWell(
                                    onTap: () => launchUrlString(item.reportUrl!),
                                    child: const Icon(Icons.download),
                                  ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.note ?? '---',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  item.createdAt.replaceAll('T', '   ').split('.').first,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text('Total ${item.ordersCount}'),
                              ],
                            ),
                            onTap: null,
                            // onTap: () {
                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultScreen(model: item)));
                            // },
                          );
                        },
                      ),
                    ),
                  ),
                  if (state is CountingLoading) const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
