import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/view/select_rating.dart';
import 'package:pomodoro_prototype/view/starts_rating.dart';
import 'package:pomodoro_prototype/view/starts_rating_provider.dart';

class FocusTimeRatingDialog extends ConsumerWidget {
  const FocusTimeRatingDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackController = TextEditingController();
    final selectedRating = ref.watch(starsRatingProvider);

    return AlertDialog(
      title: const Text('Rate Your Focus Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // **StarsRating 위젯 사용**
          const SelectRating(),
          const SizedBox(height: 20),
          Text('$selectedRating'),
          const SizedBox(height: 20),

          // 피드백 입력 필드
          TextField(
            controller: feedbackController,
            decoration: const InputDecoration(
              labelText: 'Why did you give this rating?',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // 취소 버튼
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final feedback = feedbackController.text;
            print('Rating: $selectedRating');
            print('Feedback: $feedback');

            // 팝업 닫기
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
