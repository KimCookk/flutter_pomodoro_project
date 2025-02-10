import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/view/starts_rating_provider.dart';

class SelectRating extends ConsumerWidget {
  const SelectRating({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRating = ref.watch(starsRatingProvider); // 상태 구독
    final ratingNotifier = ref.read(starsRatingProvider.notifier); // 상태 변경 접근

    final iconArray = ["😡", "😠", "😐", "🙂", "😊"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return TextButton(
          onPressed: () {
            ratingNotifier.setRating(index + 1); // 상태 변경
          },
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(2)), // 패딩 조정
            minimumSize:
                WidgetStateProperty.all(const Size(30, 30)), // 최소 크기 설정
            alignment: Alignment.center,
            backgroundColor: index == selectedRating - 1
                ? WidgetStateProperty.all(Colors.green)
                : WidgetStateProperty.all(Colors.transparent),
          ),
          child: Text(
            iconArray[index],
            style: const TextStyle(
              fontSize: 24, // 이모지 크기
              height: 1.0, // 줄 높이 조정
            ),
            textAlign: TextAlign.center,
          ),
        );
      }),
    );
  }
}
