import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:who_was_here/constants/constants.dart';
import 'package:who_was_here/models/log.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late io.Socket _socket;

  List<Log> _logs = [];

  @override
  void initState() {
    super.initState();

    _socket = io.io(
      'http://localhost:4001',
      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    _socket.onConnectError((data) {
      if (kDebugMode) {
        print(data);
      }
    });

    _socket.onError((data) {
      if (kDebugMode) {
        print(data);
      }
    });

    _socket.onConnect((data) {
      if (kDebugMode) {
        print('socket connected');
      }

      _socket.emit('all');
    });

    _socket.on('all', (data) {
      final logs = (data as Iterable<dynamic>).map((e) => Log.fromJson(e));

      setState(() {
        _logs = logs.toList();
      });
    });

    _socket.on('new', (data) {
      final log = Log.fromJson(data);

      _logs.insert(0, log);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _socket.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListView.builder(
            itemCount: _logs.length,
            padding: const EdgeInsets.only(bottom: 128, top: 4),
            itemBuilder: (context, index) {
              final log = _logs.elementAt(index);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(log.tag),
                  subtitle: Text(
                    DateFormat().format(log.getCreatedAt),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  leading:
                      log.getCreatedAt.hour >= 18 || log.getCreatedAt.hour < 5
                          ? const Icon(MdiIcons.moonWaxingCrescent)
                          : const Icon(MdiIcons.whiteBalanceSunny),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(32)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${DateFormat('yMMMd').format(DateTime.now())} - ${_logs.length} item${_logs.length == 1 ? '' : 's'}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
