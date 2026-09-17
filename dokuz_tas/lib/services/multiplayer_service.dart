import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

enum DeviceType { host, client }

enum SessionState { notConnected, connecting, connected }

class Device {
  final String deviceId;
  final String deviceName;
  SessionState state;
  
  Device(this.deviceId, this.deviceName, this.state);
}

class MultiplayerService {
  static final MultiplayerService _instance = MultiplayerService._internal();
  factory MultiplayerService() => _instance;
  MultiplayerService._internal();

  final Strategy _strategy = Strategy.P2P_CLUSTER;
  final String _userName = 'Oyuncu_${DateTime.now().millisecondsSinceEpoch % 1000}';
  bool _isInit = false;

  Device? connectedDevice;
  DeviceType? deviceType;

  final List<Device> _devicesList = [];

  final _devicesController = StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get devicesStream => _devicesController.stream;

  final _dataController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.location.isDenied) {
         await Permission.location.request();
      }
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.location,
        Permission.nearbyWifiDevices,
      ].request();
      
      bool allGranted = statuses.values.every((status) => status.isGranted);
      return allGranted;
    } else if (Platform.isIOS) {
      var status = await Permission.bluetooth.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> initService() async {
    if (_isInit) return;
    _isInit = true;
  }

  void _updateDeviceList() {
    _devicesController.sink.add(List.from(_devicesList));
  }

  Future<void> startHosting() async {
    if (!_isInit) await initService();
    deviceType = DeviceType.host;
    await stopAll();

    try {
      await Nearby().startAdvertising(
        _userName,
        _strategy,
        onConnectionInitiated: _onConnectionInit,
        onConnectionResult: (id, status) {
          if (status == Status.CONNECTED) {
            _setDeviceState(id, SessionState.connected);
          } else {
            _setDeviceState(id, SessionState.notConnected);
          }
        },
        onDisconnected: (id) {
          _setDeviceState(id, SessionState.notConnected);
        },
      );
    } catch (e) {
      print('Error starting hosting: $e');
      _dataController.sink.add({'error': 'Sunucu başlatılamadı: $e'});
    }
  }

  Future<void> startBrowsing() async {
    if (!_isInit) await initService();
    deviceType = DeviceType.client;
    await stopAll();

    try {
      await Nearby().startDiscovery(
        _userName,
        _strategy,
        onEndpointFound: (id, name, serviceId) {
          if (!_devicesList.any((d) => d.deviceId == id)) {
            _devicesList.add(Device(id, name, SessionState.notConnected));
            _updateDeviceList();
          }
        },
        onEndpointLost: (id) {
          _devicesList.removeWhere((d) => d.deviceId == id);
          if (connectedDevice?.deviceId == id) connectedDevice = null;
          _updateDeviceList();
        },
      );
    } catch (e) {
      print('Error starting browsing: $e');
      _dataController.sink.add({'error': 'Cihaz araması başlatılamadı: $e'});
    }
  }

  void _onConnectionInit(String id, ConnectionInfo info) {
    if (!_devicesList.any((d) => d.deviceId == id)) {
      _devicesList.add(Device(id, info.endpointName, SessionState.connecting));
    } else {
      _setDeviceState(id, SessionState.connecting);
    }
    
    // Otomatik olarak bağlantıyı kabul et
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endpointId, payload) {
        if (payload.type == PayloadType.BYTES && payload.bytes != null) {
          try {
            final String message = utf8.decode(payload.bytes!);
            final decoded = jsonDecode(message);
            _dataController.sink.add(decoded);
          } catch (e) {
            print('Error decoding payload: $e');
          }
        }
      },
      onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {},
    );
  }

  void _setDeviceState(String id, SessionState state) {
    for (var device in _devicesList) {
      if (device.deviceId == id) {
        device.state = state;
        if (state == SessionState.connected) {
          connectedDevice = device;
          Nearby().stopDiscovery();
          Nearby().stopAdvertising();
        } else if (state == SessionState.notConnected) {
          if (connectedDevice?.deviceId == id) connectedDevice = null;
        }
      }
    }
    _updateDeviceList();
  }

  void invitePeer(Device device) {
    _setDeviceState(device.deviceId, SessionState.connecting);
    Nearby().requestConnection(
      _userName,
      device.deviceId,
      onConnectionInitiated: _onConnectionInit,
      onConnectionResult: (id, status) {
        if (status == Status.CONNECTED) {
          _setDeviceState(id, SessionState.connected);
        } else {
          _setDeviceState(id, SessionState.notConnected);
        }
      },
      onDisconnected: (id) {
        _setDeviceState(id, SessionState.notConnected);
      },
    ).catchError((e) {
       _setDeviceState(device.deviceId, SessionState.notConnected);
       return false;
    });
  }

  void disconnect() {
    if (connectedDevice != null) {
      Nearby().disconnectFromEndpoint(connectedDevice!.deviceId);
      _setDeviceState(connectedDevice!.deviceId, SessionState.notConnected);
    }
  }

  Future<void> stopAll() async {
    await Nearby().stopAdvertising();
    await Nearby().stopDiscovery();
    await Nearby().stopAllEndpoints();
    _devicesList.clear();
    connectedDevice = null;
    _updateDeviceList();
  }

  void sendMove(int index) {
    if (connectedDevice != null) {
      final message = jsonEncode({'action': 'tap', 'index': index});
      Nearby().sendBytesPayload(connectedDevice!.deviceId, Uint8List.fromList(message.codeUnits));
    }
  }
  
  void sendRestart() {
    if (connectedDevice != null) {
      final message = jsonEncode({'action': 'restart'});
      Nearby().sendBytesPayload(connectedDevice!.deviceId, Uint8List.fromList(message.codeUnits));
    }
  }

  void dispose() {
    stopAll();
    _devicesController.close();
    _dataController.close();
  }
}
