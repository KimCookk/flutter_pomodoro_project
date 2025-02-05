import 'package:pomodoro_prototype/model/pomodoro_model.dart';

class TimerTypeHelper {
  static String getLabel(TimerType type) {
    switch (type) {
      case TimerType.focus:
        return 'Focus Time';
      case TimerType.shortBreak:
        return 'Short Break Time';
      case TimerType.longBreak:
        return 'Long Break Time';
    }
  }
}
