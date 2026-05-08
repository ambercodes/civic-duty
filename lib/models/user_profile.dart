class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.is18Plus,
    required this.citizenshipAttested,
    required this.verificationLevel,
    this.displayAlias,
    this.birthYear,
    this.stateCode,
    this.profileCompletedAt,
  });

  final String id;
  final String email;
  final bool emailVerified;
  final String? displayAlias;
  final int? birthYear;
  final bool is18Plus;
  final String? stateCode;
  final bool citizenshipAttested;
  final String verificationLevel;
  final String? profileCompletedAt;

  bool get isComplete {
    return emailVerified &&
        is18Plus &&
        stateCode != null &&
        citizenshipAttested &&
        profileCompletedAt != null;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      emailVerified: json['emailVerified'] == true,
      displayAlias: json['displayAlias']?.toString(),
      birthYear: _readInt(json['birthYear']),
      is18Plus: json['is18Plus'] == true,
      stateCode: json['stateCode']?.toString(),
      citizenshipAttested: json['citizenshipAttested'] == true,
      verificationLevel: (json['verificationLevel'] ?? '').toString(),
      profileCompletedAt: json['profileCompletedAt']?.toString(),
    );
  }

  static int? _readInt(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }
}
