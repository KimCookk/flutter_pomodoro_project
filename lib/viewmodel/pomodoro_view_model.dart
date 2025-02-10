import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/main.dart';
import '../model/pomodoro_model.dart';

final pomodoroSettingsProvider =
    StateNotifierProvider<PomodoroSettingsNotifier, PomodoroSettings>(
  (ref) => PomodoroSettingsNotifier(),
);

final pomodoroTimerProvider =
    StateNotifierProvider<PomodoroTimerNotifier, PomodoroTimerState>(
  (ref) => PomodoroTimerNotifier(ref),
);

final pomodoroViewStateProvider =
    StateNotifierProvider<PomodoroViewStateNotifier, PomodoroViewState>(
  (ref) => PomodoroViewStateNotifier(),
);

final tabVisibilityProvider = StateProvider<bool>((ref) => true);

class PomodoroSettingsNotifier extends StateNotifier<PomodoroSettings> {
  PomodoroSettingsNotifier() : super(PomodoroSettings());

  void updateSettings(
      int focusTime, int shortBreak, int longBreak, int rounds) {
    state = PomodoroSettings(
      focusTime: focusTime,
      shortBreak: shortBreak,
      longBreak: longBreak,
      rounds: rounds,
    );
  }
}

class PomodoroViewStateNotifier extends StateNotifier<PomodoroViewState> {
  PomodoroViewStateNotifier() : super(PomodoroViewState());

  void showFeedbackDialog() {
    state = state.copyWith(isFeedbackDialogVisible: true);
  }

  void hideFeedbackDialog() {
    state = state.copyWith(isFeedbackDialogVisible: false);
  }
}

class PomodoroTimerNotifier extends StateNotifier<PomodoroTimerState> {
  final Ref ref;
  Timer? _timer;
  int _remainingSeconds;
  bool _isFocusSession = true;
  int _currentRound = 1;

  PomodoroTimerNotifier(this.ref)
      : _remainingSeconds = ref.read(pomodoroSettingsProvider).focusTime,
        super(PomodoroTimerState(
          timerType: TimerType.focus,
          timerStatus: TimerStatus.stopped,
          remainingSeconds: ref.read(pomodoroSettingsProvider).focusTime,
        ));

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(timerStatus: TimerStatus.processing);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        state = state.copyWith(remainingSeconds: _remainingSeconds);
      } else {
        timer.cancel();
        showTimerFinishedNotification(state.timerType.name);
        _nextSession();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(timerStatus: TimerStatus.paused);
  }

  void stopTimer() {
    _timer?.cancel();
    _remainingSeconds = getSettingTimeSeconds();
    state = state.copyWith(timerStatus: TimerStatus.stopped);
    state = state.copyWith(remainingSeconds: _remainingSeconds);
  }

  bool isProcessing() {
    return state.timerStatus == TimerStatus.processing;
  }

  void _nextSession() {
    final settings = ref.read(pomodoroSettingsProvider);
    if (_isFocusSession) {
      if (_currentRound < settings.rounds) {
        _remainingSeconds = settings.shortBreak;
        _isFocusSession = false;

        state = state.copyWith(
          timerType: TimerType.shortBreak,
          timerStatus: TimerStatus.paused,
          remainingSeconds: _remainingSeconds,
        );
        ref.read(pomodoroViewStateProvider.notifier).showFeedbackDialog();
      } else {
        _remainingSeconds = settings.longBreak;
        _currentRound = 1;
        _isFocusSession = false;
        state = state.copyWith(
          timerType: TimerType.longBreak,
          timerStatus: TimerStatus.paused,
          remainingSeconds: _remainingSeconds,
        );
      }
    } else {
      _remainingSeconds = settings.focusTime;
      _isFocusSession = true;
      _currentRound++;
      state = state.copyWith(
        timerType: TimerType.focus,
        timerStatus: TimerStatus.paused,
        remainingSeconds: _remainingSeconds,
      );
    }
    //startTimer();
  }

  int getSettingTimeSeconds() {
    final settings = ref.read(pomodoroSettingsProvider);
    final timerType = state.timerType;
    switch (timerType) {
      case TimerType.focus:
        {
          return settings.focusTime;
        }

      case TimerType.shortBreak:
        {
          return settings.shortBreak;
        }

      case TimerType.longBreak:
        {
          return settings.longBreak;
        }
    }
  }

  Future<void> showTimerFinishedNotification(String timerType) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'pomodoro_timer_channel',
      'Pomodoro Timer',
      channelDescription: 'Notifications for Pomodoro Timer events',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Timer Completed',
      'Your $timerType session has ended. Time for a break!',
      platformDetails,
      payload: 'timer_finished',
    );
  }
}
