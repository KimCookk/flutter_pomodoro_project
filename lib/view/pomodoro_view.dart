// view/pomodoro_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/model/timer_type_helper.dart';
import 'package:pomodoro_prototype/view/focus_time_rating_dialog.dart';
import '../viewmodel/pomodoro_view_model.dart';
import '../model/pomodoro_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTabVisible = ref.watch(tabVisibilityProvider);
    final timerState = ref.watch(pomodoroTimerProvider);
    final pomodoroViewState = ref.watch(pomodoroViewStateProvider);

    if (pomodoroViewState.isFeedbackDialogVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return FocusTimeRatingDialog();
            }); // 다이얼로그 호출
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        leading: IconButton(
          icon: Icon(Icons.message_sharp),
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return FocusTimeRatingDialog();
              }),
        ),
        actions: [
          IconButton(
            icon: Icon(isTabVisible ? Icons.visibility_off : Icons.visibility),
            onPressed: () =>
                ref.read(tabVisibilityProvider.notifier).state = !isTabVisible,
          ),
        ],
      ),
      body: TabViewScreen(
        timerState: timerState,
        isTabVisible: isTabVisible,
      ),
    );
  }
}

class TabViewScreen extends StatelessWidget {
  final PomodoroTimerState timerState;
  final bool isTabVisible;
  const TabViewScreen({
    super.key,
    required this.timerState,
    required this.isTabVisible,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TabBarView(
              children: [
                TimerView(timerState: timerState),
                Center(child: Text('Tasks View')),
                Center(child: Text('Settings View')),
              ],
            ),
          ),
          isTabVisible
              ? TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.timer), text: 'Timer'),
                    Tab(icon: Icon(Icons.list), text: 'Tasks'),
                    Tab(icon: Icon(Icons.settings), text: 'Settings'),
                  ],
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                )
              : SizedBox(
                  height: 20.0,
                ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

class TimerView extends ConsumerWidget {
  final PomodoroTimerState timerState;
  const TimerView({super.key, required this.timerState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerNotifier = ref.read(pomodoroTimerProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TimerTypeHelper.getLabel(timerState.timerType),
          style: const TextStyle(fontSize: 30),
        ),
        const SizedBox(height: 20),
        Text(
          timerState.formattedTime,
          style: const TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: timerNotifier.isProcessing()
                  ? timerNotifier.pauseTimer
                  : timerNotifier.startTimer,
              child: timerNotifier.isProcessing()
                  ? const Text('Pause')
                  : const Text('Start'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: timerNotifier.stopTimer,
              child: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}

class TabNavigationBar extends StatelessWidget {
  const TabNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.timer), text: 'Timer'),
              Tab(icon: Icon(Icons.list), text: 'Tasks'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
