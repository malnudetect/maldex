import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  singinWithGoogle() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication gAuth = await guser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
