import 'package:flutter/material.dart';

import '../screens/auth/complete_profile_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/concerns/concern_archive_screen.dart';
import '../screens/concerns/concern_detail_screen.dart';
import '../screens/concerns/concern_threshold_status_screen.dart';
import '../screens/concerns/concerns_list_screen.dart';
import '../screens/concerns/submit_concern_screen.dart';
import '../screens/cost_of_operating_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/dossier_screen.dart';
import '../screens/education_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/ratification_screen.dart';
import '../screens/read_confirmation_screen.dart';
import '../screens/record_screen.dart';
import '../widgets/auth_gate.dart';

class AppRoutes {
  const AppRoutes._();

  static const landing = '/';
  static const dashboard = '/dashboard';
  static const dossier = '/dossier';
  static const confirmReview = '/confirm-review';
  static const ratify = '/ratify';
  static const record = '/record';
  static const concerns = '/concerns';
  static const submitConcern = '/submit-concern';
  static const concernArchive = '/concerns/archive';
  static const concernThreshold = '/concerns/threshold';
  static const login = '/login';
  static const signup = '/signup';
  static const verifyEmail = '/verify-email';
  static const completeProfile = '/complete-profile';
  static const whatIsCivicDuty = '/what-is-civic-duty';
  static const whatIsADossier = '/what-is-a-dossier';
  static const ratificationMeaning = '/what-does-ratification-mean';
  static const verificationLevels = '/verification-levels';
  static const participationMethodology = '/participation-methodology';
  static const scopeBoundaries = '/scope-boundaries';
  static const sandboxDisclaimer = '/sandbox-disclaimer';
  static const costOfOperating = '/cost-of-operating';

  static Map<String, WidgetBuilder> get routes {
    return {
      landing: (_) => const LandingScreen(),
      login: (_) => const LoginScreen(),
      signup: (_) => const SignupScreen(),
      verifyEmail: (_) => const VerifyEmailScreen(),
      completeProfile: (_) => const AuthGate(child: CompleteProfileScreen()),
      dashboard: (_) => const DashboardScreen(),
      dossier: (_) =>
          const AuthGate(requireProfile: true, child: DossierScreen()),
      confirmReview: (_) =>
          const AuthGate(requireProfile: true, child: ReadConfirmationScreen()),
      ratify: (_) =>
          const AuthGate(requireProfile: true, child: RatificationScreen()),
      record: (_) => const RecordScreen(),
      concerns: (_) => const ConcernsListScreen(),
      submitConcern: (_) =>
          const AuthGate(requireProfile: true, child: SubmitConcernScreen()),
      concernArchive: (_) => const ConcernArchiveScreen(),
      whatIsCivicDuty: (_) =>
          EducationScreen(page: EducationPages.whatIsCivicDuty),
      whatIsADossier: (_) =>
          EducationScreen(page: EducationPages.whatIsADossier),
      ratificationMeaning: (_) =>
          EducationScreen(page: EducationPages.ratificationMeaning),
      verificationLevels: (_) =>
          EducationScreen(page: EducationPages.verificationLevels),
      participationMethodology: (_) =>
          EducationScreen(page: EducationPages.participationMethodology),
      scopeBoundaries: (_) =>
          EducationScreen(page: EducationPages.scopeBoundaries),
      sandboxDisclaimer: (_) =>
          EducationScreen(page: EducationPages.sandboxDisclaimer),
      costOfOperating: (_) => const CostOfOperatingScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    if (name.startsWith('/dossier/')) {
      final id = Uri.decodeComponent(name.substring('/dossier/'.length));
      return MaterialPageRoute(
        builder: (_) => AuthGate(
          requireProfile: true,
          child: DossierScreen(dossierIdOrSlug: id),
        ),
        settings: settings,
      );
    }

    if (name.startsWith('/ratify/')) {
      final id = Uri.decodeComponent(name.substring('/ratify/'.length));
      return MaterialPageRoute(
        builder: (_) => AuthGate(
          requireProfile: true,
          child: RatificationScreen(dossierIdOrSlug: id),
        ),
        settings: settings,
      );
    }

    if (name.startsWith('/confirm-review/')) {
      final id = Uri.decodeComponent(name.substring('/confirm-review/'.length));
      return MaterialPageRoute(
        builder: (_) => AuthGate(
          requireProfile: true,
          child: ReadConfirmationScreen(dossierIdOrSlug: id),
        ),
        settings: settings,
      );
    }

    if (name.startsWith('/records/')) {
      final slug = Uri.decodeComponent(name.substring('/records/'.length));
      return MaterialPageRoute(
        builder: (_) => RecordScreen(recordSlug: slug),
        settings: settings,
      );
    }

    if (name.startsWith('$concernThreshold/')) {
      final id = Uri.decodeComponent(
        name.substring('$concernThreshold/'.length),
      );
      return MaterialPageRoute(
        builder: (_) => ConcernThresholdStatusScreen(concernIdOrSlug: id),
        settings: settings,
      );
    }

    if (name.startsWith('$concerns/')) {
      final id = Uri.decodeComponent(name.substring('$concerns/'.length));
      return MaterialPageRoute(
        builder: (_) => ConcernDetailScreen(concernIdOrSlug: id),
        settings: settings,
      );
    }

    return null;
  }
}
