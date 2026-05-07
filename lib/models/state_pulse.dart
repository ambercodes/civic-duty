class StatePulse {
  const StatePulse({
    required this.state,
    required this.participants,
    required this.populationBaseline,
  });

  final String state;
  final int participants;
  final int populationBaseline;

  double get coveragePercent {
    if (populationBaseline == 0) {
      return 0;
    }

    return participants / populationBaseline * 100;
  }
}
