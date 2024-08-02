import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _refresh;

  String? get username => _username;
  String? get refresh => _refresh;

  void setTokens(String token, String username) {
    _refresh = token;
    _username = username;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void clearTokens() {
    _refresh = null;
    _username = null;
    notifyListeners();
  }
}
