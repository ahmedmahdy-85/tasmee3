import 'dart:io';

import 'package:flutter/material.dart';

Future<void> checkInternetConnectivity(bool online) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      online = true;
    }
  } on SocketException catch (_) {
    online = false;
  }
}
