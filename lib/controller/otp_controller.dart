import 'dart:async';

import 'package:get/get.dart';

class OtpController extends GetxController {
  RxBool timerCompleted = false.obs;
  final RxInt _seconds = 25.obs;
  late Timer _timer;
  final RxBool _timerRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  void startTimer() {
    if (!_timerRunning.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_seconds.value > 0) {
          _seconds.value -= 1;
        } else {
          timer.cancel();
          _timerRunning.value = false;
          timerCompleted.value = true;
        }
      });
      _timerRunning.value = true;
    }
  }

  void restartTimer() {
    _seconds.value = 25;
    timerCompleted.value = false;
    startTimer();
  }

  String getFormattedTime() {
    int seconds = _seconds.value;
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
