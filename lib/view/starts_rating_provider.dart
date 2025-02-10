import 'package:flutter_riverpod/flutter_riverpod.dart';

// 선택된 평점을 관리하는 StateNotifier
class StarsRatingNotifier extends StateNotifier<int> {
  StarsRatingNotifier() : super(0);

  void setRating(int rating) {
    state = rating;
  }
}

// StateNotifierProvider 정의
final starsRatingProvider = StateNotifierProvider<StarsRatingNotifier, int>(
  (ref) => StarsRatingNotifier(),
);
