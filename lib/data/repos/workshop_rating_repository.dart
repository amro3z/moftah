class WorkshopRatingSummary {
  final double average;
  final int reviewsCount;

  const WorkshopRatingSummary({
    required this.average,
    required this.reviewsCount,
  });
}

class WorkshopRatingRepository {
  WorkshopRatingRepository._();

  static final WorkshopRatingRepository instance = WorkshopRatingRepository._();

  final Map<String, double> _totalScores = {};
  final Map<String, int> _reviewCounts = {};

  WorkshopRatingSummary getSummary(String workshopExternalId) {
    final count = _reviewCounts[workshopExternalId] ?? 0;
    final total = _totalScores[workshopExternalId] ?? 0;

    return WorkshopRatingSummary(
      average: count == 0 ? 0 : total / count,
      reviewsCount: count,
    );
  }

  void addRating({
    required String workshopExternalId,
    required double rating,
  }) {
    if (rating < 0 || rating > 5) {
      throw ArgumentError.value(rating, 'rating', 'Rating must be between 0 and 5');
    }

    _totalScores[workshopExternalId] =
        (_totalScores[workshopExternalId] ?? 0) + rating;
    _reviewCounts[workshopExternalId] =
        (_reviewCounts[workshopExternalId] ?? 0) + 1;
  }
}
