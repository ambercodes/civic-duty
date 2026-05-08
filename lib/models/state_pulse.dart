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

  factory StatePulse.fromJson(Map<String, dynamic> json) {
    return StatePulse(
      state: (json['state_name'] ?? json['stateName'] ?? json['state'] ?? '')
          .toString(),
      participants: _readInt(json['participants']),
      populationBaseline: _readInt(
        json['citizen_voting_age_population'] ?? json['populationBaseline'],
      ),
    );
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
