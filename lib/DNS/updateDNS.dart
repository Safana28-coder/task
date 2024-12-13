import 'package:flutter/services.dart';

class DNSUpdater {
  static const platform = MethodChannel('dns_configurator');

  static Future<String> updateDNS(String dns) async {
    try {
      final result = await platform.invokeMethod('updateDNS', {'dns': dns});
      return result;
    } catch (e) {
      return "Failed to update DNS: $e";
    }
  }
}
