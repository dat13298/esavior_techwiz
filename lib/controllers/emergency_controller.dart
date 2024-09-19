import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../views/notification/emergency_notification.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
OverlayEntry? _overlayEntry;

Future<void> playNotificationSound() async {
  await _audioPlayer.play(AssetSource('emergency.mp3'));
}

Future<void> stopNotificationSound() async {
  await _audioPlayer.stop();
}

void showEmergencyNotification(BuildContext context, String message) {
  final overlayState = Overlay.of(context);

  // Nếu đã có một overlayEntry, loại bỏ nó trước khi tạo cái mới
  _overlayEntry?.remove();

  _overlayEntry = OverlayEntry(
    builder: (context) => EmergencyNotification(
      message: message,
      onConfirm: () {
        stopNotificationSound();
        // Loại bỏ overlayEntry khi xác nhận
        _overlayEntry?.remove();
      },
    ),
  );

  overlayState?.insert(_overlayEntry!);

  playNotificationSound();
}
