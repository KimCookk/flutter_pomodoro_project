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
    this.focusTime = 3,
    this.shortBreak = 3,
    this.longBreak = 5,
    this.rounds = 2,
  });
}

class PomodoroViewState {
  final bool isFeedbackDialogVisible;

  PomodoroViewState({this.isFeedbackDialogVisible = false});

  PomodoroViewState copyWith({bool? isFeedbackDialogVisible}) {
    return PomodoroViewState(
      isFeedbackDialogVisible:
          isFeedbackDialogVisible ?? this.isFeedbackDialogVisible,
    );
  }
}
