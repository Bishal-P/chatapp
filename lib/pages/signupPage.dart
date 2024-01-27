import 'package:chatapp/components/functions.dart';
import 'package:chatapp/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emialController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      uiHelper.CustomAlertBox(
          context, "Error", "Password and Confirm Password does not match");
      return;
    }
    if (emialController.text.isEmpty) {
      uiHelper.CustomAlertBox(context, "Error", "Email cannot be empty");
      return;
    }
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emialController.text, password: passwordController.text)
          .then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => loginPage())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        uiHelper.CustomAlertBox(
            context, "Alert", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email and Password cannot be empty"),
        backgroundColor: Colors.redAccent,
        elevation: 10, //shadow
      ));
        uiHelper.CustomAlertBox(
            context, "Info", "The account already exists for that email.");
      }
    } catch (e) {
      uiHelper.CustomAlertBox(context, "Error", e.toString());
    }

    // userCredential =await FirebaseAuth.instance
    //     .createUserWithEmailAndPassword(
    //         email: emialController.text, password: passwordController.text)
    //     .then((signedUser) {
    //   // FirebaseFire.instance.collection('users').doc(signedUser.user.uid).set({
    //   //   'email': signedUser.user.email,
    //   //   'uid': signedUser.user.uid,
    //   });

    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => loginPage()));
    // }).catchError((e) {
    //   uiHelper.CustomAlertBox(context, "Error", e.message);
    // });
  }

  @override
  Widget build(BuildContext context) {
    uiHelper.checkUser(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Create your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      // TextField(
                      //   decoration: InputDecoration(
                      //       hintText: "Username",
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(18),
                      //           borderSide: BorderSide.none),
                      //       fillColor: Colors.purple.withOpacity(0.1),
                      //       filled: true,
                      //       prefixIcon: const Icon(Icons.person)),
                      // ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emialController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: Colors.purple.withOpacity(0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.email)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.password),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.purple.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.password),
                        ),
                        obscureText: true,
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.purple,
                        ),
                      )),

                  // const Center(child: Text("Or")),

                  // Container(
                  //   height: 45,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(25),
                  //     border: Border.all(
                  //       color: Colors.purple,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.white.withOpacity(0.5),
                  //         spreadRadius: 1,
                  //         blurRadius: 1,
                  //         offset: const Offset(0, 1), // changes position of shadow
                  //       ),
                  //     ],
                  //   ),
                  //   child: TextButton(
                  //     onPressed: () {},
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Container(
                  //           height: 30.0,
                  //           width: 30.0,
                  //           decoration: const BoxDecoration(
                  //             image: DecorationImage(
                  //                 image:   AssetImage('assets/images/login_signup/google.png'),
                  //                 fit: BoxFit.cover),
                  //             shape: BoxShape.circle,
                  //           ),
                  //         ),

                  //         const SizedBox(width: 18),

                  //         const Text("Sign In with Google",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: Colors.purple,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => loginPage()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.purple),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
