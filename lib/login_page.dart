import 'package:compleat_one_project/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendOTP() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a phone number');
      return;
    }
    if (phoneNumber.length < 10) {
      Fluttertoast.showToast(msg: 'Please enter a valid phone number');
      return;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushNamed(context, '/otpscreen');
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: 'Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pushNamed(context, '/otpscreen', arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle auto-retrieval timeout
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Page'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/image1.png', height: 150), // Add an image to assets folder
              SizedBox(height: 20),
              Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We need to register your phone before getting started!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(color: Colors.white54),
                  prefix: Text('+91 ', style: TextStyle(color: Colors.white)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _sendOTP();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent, backgroundColor: Colors.white,
                ),
                child: Text('Send the code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class  LoginPage extends StatefulWidget {
//   const  LoginPage({super.key});
//
//   @override
//   State< LoginPage> createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State< LoginPage> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _verificationId = '';
//
//   Future<void> _verifyPhoneNumber() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: _phoneController.text,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         // Handle successful login
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         // Handle error
//         print(e.message);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//       },
//     );
//   }
//
//   Future<void> _signInWithOtp() async {
//     final credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: _otpController.text,
//     );
//
//     try {
//       await _auth.signInWithCredential(credential);
//       // Handle successful login
//     } catch (e) {
//       // Handle error
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OTP Authentication'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _verifyPhoneNumber,
//               child: const Text('Send OTP'),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _otpController,
//               decoration: const InputDecoration(
//                 labelText: 'OTP',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _signInWithOtp,
//               child: const Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
