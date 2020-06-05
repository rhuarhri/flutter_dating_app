import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

//TODO sign in does not currently work

void signInWithGoogle() async
{
  GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;

  AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  AuthResult authResult = await _auth.signInWithCredential(credential);

  FirebaseUser user = authResult.user;





}