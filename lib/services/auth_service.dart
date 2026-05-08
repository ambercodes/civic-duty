import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth? _firebaseAuth;

  static bool get isConfigured => Firebase.apps.isNotEmpty;

  FirebaseAuth get _auth => _firebaseAuth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges {
    if (!isConfigured) {
      return const Stream<User?>.empty();
    }
    return _auth.authStateChanges();
  }

  User? get currentUser => isConfigured ? _auth.currentUser : null;

  Future<String?> idToken() async {
    return currentUser?.getIdToken();
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      throw StateError('Firebase is not configured.');
    }
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.sendEmailVerification();
    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    if (!isConfigured) {
      throw StateError('Firebase is not configured.');
    }
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() {
    if (!isConfigured) {
      return Future<void>.value();
    }
    return _auth.signOut();
  }

  Future<void> reloadUser() async {
    if (!isConfigured) {
      return;
    }
    await currentUser?.reload();
  }

  Future<void> sendEmailVerification() async {
    if (!isConfigured) {
      return;
    }
    await currentUser?.sendEmailVerification();
  }
}
