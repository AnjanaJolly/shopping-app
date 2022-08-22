import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../cubit/main_cubit.dart';
import 'authentication_cubit_state.dart';

class AuthenticationCubit extends MainCubit<AuthCubitState> {
  AuthenticationCubit([AuthCubitState? initialState])
      : super(initialState ?? InitialState());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String verID = " ";
  get user => _auth.currentUser;

  void signInWithGoogle() async {
    emit(LoginLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // ignore: unnecessary_null_comparison
        if (userCredential != null || userCredential.toString().isNotEmpty) {
          emit(LoginSuccessState(isSuccess: true, credential: userCredential));
        }
      } on FirebaseAuthException catch (e) {
        emit(LoginFailureState(isSuccess: false, response: e.code));
      } catch (e) {
        emit(LoginFailureState(
            isSuccess: false,
            response: 'Error occurred using Google Sign-In. Try again.'));
      }
    } else {
      emit(LoginFailureState(
          isSuccess: false,
          response: 'Error occurred using Google Sign-In. Try again.'));
    }
  }

  Future<void> verifyPhone(String number) async {
    emit(LoginLoadingState());
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential) {
          emit(OTPVerificationMainState(message: credential.signInMethod));
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(LoginFailureState(response: e.message!));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(OTPSentSuccessState());
          verID = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
          //  emit(LoginFailureState(response: 'TimeOut'));
        },
      );
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(response: e.message!));
    }
  }

  Future<void> verifyOTP(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: smsCode,
      );

      final user =
          (await FirebaseAuth.instance.signInWithCredential(credential));
      emit(OtpLoginSuccessState(credential: user));
    } on FirebaseAuthException catch (e) {
      emit(LoginFailureState(response: e.message!));
    }
  }
}
