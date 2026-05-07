import 'dossier.dart';
import 'state_pulse.dart';

class CivicRatificationRecord {
  const CivicRatificationRecord({
    required this.recordId,
    required this.version,
    required this.publicationDate,
    required this.dossier,
    required this.totalParticipants,
    required this.ratifiedCount,
    required this.notRatifiedCount,
    required this.statesRepresented,
    required this.stateParticipation,
    required this.outcome,
    required this.methodology,
  });

  final String recordId;
  final String version;
  final String publicationDate;
  final Dossier dossier;
  final int totalParticipants;
  final int ratifiedCount;
  final int notRatifiedCount;
  final int statesRepresented;
  final List<StatePulse> stateParticipation;
  final String outcome;
  final String methodology;
}
