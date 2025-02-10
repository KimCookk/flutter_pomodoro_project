import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_prototype/view/starts_rating_provider.dart';

class StarsRating extends ConsumerWidget {
  const StarsRating({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRating = ref.watch(starsRatingProvider); // 상태 구독
    final ratingNotifier = ref.read(starsRatingProvider.notifier); // 상태 변경 접근

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            selectedRating > index ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 35,
          ),
          onPressed: () {
            ratingNotifier.setRating(index + 1); // 상태 변경
          },
        );
      }),
    );
  }
}
