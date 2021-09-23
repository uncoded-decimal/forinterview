import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc {
  static final AuthBloc _singleton = AuthBloc._internal();
  factory AuthBloc() {
    return _singleton;
  }
  AuthBloc._internal();

  final BehaviorSubject<User?> _authSubject = BehaviorSubject();
  Stream<User?> get currentUser => _authSubject.stream;

  void setupAuthData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _authSubject.sink.add(auth.currentUser);

    /// readily listen to auth state changes and
    /// update the stream to the UI
    FirebaseAuth.instance
        .authStateChanges()
        .listen((user) => _authSubject.sink.add(user));
  }

  void loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _authSubject.sink.addError(e.message ?? "An error occured");
    } catch (e) {
      final error = e.toString().replaceAll("Exception: ", "");
      _authSubject.sink.addError(error);
    }
  }

  void signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _authSubject.sink.addError(e.message ?? "An error occured");
    } catch (e) {
      final error = e.toString().replaceAll("Exception: ", "");
      _authSubject.sink.addError(error);
    }
  }

  void loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) throw Exception("Cancelled by user");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      final error = e.toString().replaceAll("Exception: ", "");
      _authSubject.sink.addError(error);
    }
  }

  void logout() async {
    final user = _authSubject.value!;
    for (var element in user.providerData) {
      if (element.providerId == 'google.com') {
        await GoogleSignIn().signOut();
        break;
      }
    }
    await FirebaseAuth.instance.signOut();
  }

  dispose() {
    _authSubject.close();
  }
}
