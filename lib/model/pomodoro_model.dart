import 'dart:ffi';

enum TimerType { focus, shortBreak, longBreak }

enum TimerStatus { processing, stopped, paused }

class PomodoroTimerState {
  final TimerType timerType;
  final TimerStatus timerStatus;
  final int remainingSeconds;

  PomodoroTimerState({
    required this.timerType,
    required this.timerStatus,
    required this.remainingSeconds,
  });

  PomodoroTimerState copyWith({
    TimerType? timerType,
    TimerStatus? timerStatus,
    int? remainingSeconds,
  }) {
    return PomodoroTimerState(
      timerType: timerType ?? this.timerType,
      timerStatus: timerStatus ?? this.timerStatus,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60; // 몫 계산
    final seconds = remainingSeconds % 60; // 나머지 계산

    // 두 자리 형식으로 반환
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class PomodoroSettings {
  final int focusTime; // in minutes
  final int shortBreak; // in minutes
  final int longBreak; // in minutes
  final int rounds;

  PomodoroSettings({
    this.focusTime = 25,
    this.shortBreak = 5,
    this.longBreak = 15,
    this.rounds = 4,
  });
}
