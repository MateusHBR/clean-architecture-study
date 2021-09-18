import 'package:flutter/material.dart';

mixin LogoutManager {
  void handleLogout(Stream<bool> isSessionExpired, context) {
    isSessionExpired.listen((expired) {
      if (expired) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
}
