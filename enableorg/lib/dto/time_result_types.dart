enum ResultType {
  latest,
  sixMonthsAgo,
  oneYearAgo,
}

class ResultTypeHelper {
  static DateTime getDateTime(ResultType resultType) {
    final now = DateTime.now();

    switch (resultType) {
      case ResultType.latest:
        return now;
      case ResultType.sixMonthsAgo:
        return now.subtract(
            Duration(days: 6 * 30)); // Assuming each month has 30 days
      case ResultType.oneYearAgo:
        return now.subtract(Duration(days: 365)); // Approximately 1 year
      default:
        return now; // Default to current time for unknown result types
    }
  }

  static int getMonthsAgo(ResultType resultType) {
    switch (resultType) {
      case ResultType.latest:
        return 0;
      case ResultType.sixMonthsAgo:
        return 6; // Assuming each month has 30 days
      case ResultType.oneYearAgo:
        return 12; // Approximately 1 year
      default:
        return 0; // Default to current time for unknown result types
    }
  }
}
