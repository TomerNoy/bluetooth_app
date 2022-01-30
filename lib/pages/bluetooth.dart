import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../theme.dart';

class Bluetooth extends StatelessWidget {
  const Bluetooth({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      child: SafeArea(
        child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (_, snapshot) {
            /// bluetooth on/off detection
            if (snapshot.data == BluetoothState.on) {
              /// init scan is a wrapper for scanning bluetooth devices on init
              return InitScan(child: BluetoothPage(title: title));
            }
            return const BluetoothOff();
          },
        ),
      ),
    );
  }
}

/// shows when bluetooth is disabled
class BluetoothOff extends StatelessWidget {
  const BluetoothOff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.bluetooth_disabled, size: 60),
            SizedBox(height: 16),
            Text('Bluetooth is disabled'),
          ],
        ),
      ),
    );
  }
}

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({Key? key, required this.title}) : super(key: key);

  /// styling widgets
  static const TextStyle titleStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  final String title;

  @override
  Widget build(BuildContext context) {
    /// search button scanning mode on
    Widget searchOn = IconButton(
      icon: Stack(
        alignment: Alignment.center,
        children: const [
          Icon(Icons.stop),
          SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        ],
      ),

      /// if scanning is on we'll just stop it
      onPressed: () => FlutterBlue.instance.stopScan(),
    );

    /// search button scanning mode off
    Widget searchOff = IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        /// if scanning is off we'll rescan
        FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          StreamBuilder<bool>(
            stream: FlutterBlue.instance.isScanning,
            initialData: false,

            /// build scan button on stream change
            builder: (_, snapshot) => snapshot.data! ? searchOn : searchOff,
          )
        ],
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: const [],

        /// build page content on scan results
        builder: (_, snapshot) {
          List<ScanResult> children = [];
          print(snapshot.connectionState);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// filter out unnamed and id duplicates
          for (ScanResult e in snapshot.data!) {
            if (e.device.name.isNotEmpty ||
                e.advertisementData.localName.isNotEmpty) {
              if (!children
                  .map((e) => e.device.id)
                  .toList()
                  .contains(e.device.id)) children.add(e);
            }
          }

          if (children.isNotEmpty) {
            return Column(
              children: [
                /// shows total devices found
                Container(
                  width: double.infinity,
                  child: Text('Total found ${children.length}'),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                ),

                /// shows bluetooth device list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: children.map(
                        (e) {
                          return ExpansionTile(
                            leading:
                                const Icon(Icons.bluetooth, color: primary),
                            title: Column(
                              children: [
                                rowTitles('Name', 'Type'),
                                rowContent(e.device.name, e.device.type.name),
                              ],
                            ),
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.rss_feed,
                                  color: Colors.grey,
                                ),
                                title: Column(
                                  children: [
                                    rowTitles('RSSI', 'ID'),
                                    rowContent('${e.rssi}', e.device.id.id)
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                )
              ],
            );
          }
          return const Center(child: Icon(Icons.bluetooth_searching, size: 60));
        },
      ),
    );
  }

  Row rowTitles(String s1, String s2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(s1, style: titleStyle), Text(s2, style: titleStyle)],
    );
  }

  Row rowContent(String s1, String s2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(s1, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        Text(s2)
      ],
    );
  }
}

/// stateful wrapper for init in a stateless widget
class InitScan extends StatefulWidget {
  const InitScan({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _InitScanState createState() => _InitScanState();
}

class _InitScanState extends State<InitScan> {
  @override
  void initState() {
    /// first scan of bluetooth devices
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
