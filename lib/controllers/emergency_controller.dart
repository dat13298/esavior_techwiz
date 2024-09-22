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

void showEmergencyNotification(BuildContext context, String message, String title) {
  final overlayState = Overlay.of(context);

  _overlayEntry?.remove();

  _overlayEntry = OverlayEntry(
    builder: (context) => EmergencyNotification(

      message: message,
      onConfirm: () {
        stopNotificationSound();
        _overlayEntry?.remove();
      }, title: title,
    ),
  );

  overlayState.insert(_overlayEntry!);

  playNotificationSound();
}
