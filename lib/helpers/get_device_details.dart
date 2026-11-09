import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<Map<String, dynamic>> getDeviceDetails() async {
  final deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return {
      'platform': 'android',
      'model': androidInfo.model,
      'manufacturer': androidInfo.manufacturer,
      'version': androidInfo.version.release,
      'sdkInt': androidInfo.version.sdkInt,
      'device': androidInfo.device,
    };
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return {
      'platform': 'ios',
      'name': iosInfo.name,
      'model': iosInfo.model,
      'systemName': iosInfo.systemName,
      'systemVersion': iosInfo.systemVersion,
      'identifierForVendor': iosInfo.identifierForVendor,
    };
  } else {
    return {'platform': 'unknown'};
  }
}
