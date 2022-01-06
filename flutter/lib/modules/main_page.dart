import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:who_was_here/constants/constants.dart';
import 'package:who_was_here/models/log.dart';
import 'package:who_was_here/utils/services/shared_preferences.dart';
import 'package:who_was_here/utils/show_default_snackbar.dart';
import 'package:who_was_here/widgets/settings_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  io.Socket? _socket;

  List<Log> _logs = [];

  Future<void> _settings() async {
    final ans = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return const SettingsWidget();
      },
    );

    if (ans == true) await _setupSocket();
  }

  Future<void> _setupSocket() async {
    final host = await Prefs.host;

    _socket?.clearListeners();

    final socket = io.io(
      'http://$host:4001',
      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.onConnectError((data) {
      if (kDebugMode) {
        print(data);
      }

      showDefaultSnackBar(
        context: context,
        content: 'Something went wrong while attempting to connect.',
      );
    });

    socket.onError((data) {
      if (kDebugMode) {
        print(data);
      }

      showDefaultSnackBar(content: 'Something went wrong.', context: context);
    });

    socket.onConnect((data) {
      if (kDebugMode) {
        print('socket connected');
      }

      showDefaultSnackBar(content: 'Socket connected.', context: context);

      _socket?.emit('all');
    });

    socket.on('all', (data) {
      final logs = (data as Iterable<dynamic>).map((e) => Log.fromJson(e));

      showDefaultSnackBar(content: 'Listing all events.', context: context);

      setState(() {
        _logs = logs.toList();
      });
    });

    socket.on('new', (data) {
      final log = Log.fromJson(data);

      showDefaultSnackBar(content: 'New event detected.', context: context);

      _logs.insert(0, log);

      setState(() {});
    });

    setState(() {
      _socket = socket;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _setupSocket();
    });
  }

  @override
  void dispose() {
    _socket?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        actions: [
          IconButton(
            onPressed: _settings,
            icon: const Icon(MdiIcons.cog),
          ),
        ],
      ),
      floatingActionButton: Material(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${DateFormat('yMMMd').format(DateTime.now())} - ${_logs.length} item${_logs.length == 1 ? '' : 's'}',
          ),
        ),
      ),
      body: ListView.builder(
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
              leading: log.getCreatedAt.hour >= 18 || log.getCreatedAt.hour < 5
                  ? const Icon(MdiIcons.moonWaxingCrescent)
                  : const Icon(MdiIcons.whiteBalanceSunny),
            ),
          );
        },
      ),
    );
  }
}