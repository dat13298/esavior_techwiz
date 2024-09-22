import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  String? _message;
  bool _isAdmin = false;

  String? get message => _message;

  bool get isAdmin => _isAdmin;

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }

  void setAdminStatus(bool status) {
    _isAdmin = status;
    notifyListeners();
  }
}
