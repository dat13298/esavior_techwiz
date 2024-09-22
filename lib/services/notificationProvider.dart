import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  String? _message;
  bool _isAdmin = false; // Trạng thái admin

  String? get message => _message;
  bool get isAdmin => _isAdmin; // Getter cho trạng thái admin

  void setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  void clearMessage() {
    _message = null;
    notifyListeners();
  }

  void setAdminStatus(bool status) {
    _isAdmin = status; // Cập nhật trạng thái admin
    print("set duoc roi");
    notifyListeners();
  }
}
