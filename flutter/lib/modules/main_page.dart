import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:who_was_here/constants/constants.dart';
import 'package:who_was_here/models/log.dart';
import 'package:who_was_here/utils/services/localization.dart';
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
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
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
        content: Localization.string(context).connectionErrorMessage,
      );
    });

    socket.onError((data) {
      if (kDebugMode) {
        print(data);
      }

      showDefaultSnackBar(
        context: context,
        content: Localization.string(context).somethingWentWrong,
      );
    });

    socket.onConnect((data) {
      if (kDebugMode) {
        print('socket connected');
      }

      showDefaultSnackBar(
        context: context,
        content: Localization.string(context).socketConnected,
      );

      _socket?.emit('all');
    });

    socket.on('all', (data) {
      final logs = (data as Iterable<dynamic>).map((e) => Log.fromJson(e));

      showDefaultSnackBar(
        context: context,
        content: Localization.string(context).listingAllEvents,
      );

      setState(() {
        _logs = logs.toList();
      });
    });

    socket.on('new', (data) {
      final log = Log.fromJson(data);

      showDefaultSnackBar(
        context: context,
        content: Localization.string(context).newEventDetected,
      );

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
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            Constants.appName,
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6?.color,
            ),
          ),
          subtitle: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final caption = Theme.of(context).primaryTextTheme.caption;

              if (snapshot.hasError) {
                return Text(
                  Localization.string(context).somethingWentWrong,
                  style: caption,
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data!;

                return Text(
                  '${data.appName} ${data.version}+${data.buildNumber}',
                  style: caption,
                );
              }

              return Text(
                Localization.string(context).loading,
                style: caption,
              );
            },
          ),
        ),
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
            '${Localization.formatDateDateShortMonth(context, DateTime.now())} - ${_logs.length} ${_logs.length == 1 ? Localization.string(context).item : Localization.string(context).items}',
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
                Localization.dateFormat(context).format(log.getCreatedAt),
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
