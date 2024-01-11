import 'package:chatapp/components/functions.dart';
import 'package:chatapp/pages/otpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController phoneController = TextEditingController();
  getOtp() {
    if (phoneController.text.isEmpty) {
      uiHelper.CustomAlertBox(context, "Error", "Phone Number cannot be empty");
    } else {
      try {
        FirebaseAuth.instance.verifyPhoneNumber(
            verificationCompleted: (PhoneAuthCredential credential) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String verificationid, int? resendtoken) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => otpPage(
                            verificationid: verificationid,
                          )));
            },
            codeAutoRetrievalTimeout: (String verificationid) {},
            phoneNumber: phoneController.text.toString());
      } catch (e) {
        uiHelper.CustomAlertBox(context, "Error", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width - 50,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: height * 0.45,
                  child: Image.asset(
                    'assets/login.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    suffixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60.0,
                ),
                ElevatedButton(
                  child: Text('Get OTP'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffEE7B23),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  // color: Color(0xffEE7B23),
                  onPressed: () {
                    getOtp();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
