import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/HomePage.dart';
import 'package:chatapp/pages/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key, BuildContext? context});
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emialController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    if (emialController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email and Password cannot be empty"),
        backgroundColor: Colors.redAccent,
        elevation: 10, //shadow
      ));
    } else {

      try {
 await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emialController.text, password: passwordController.text)
            .then((value) async {
          api.user = FirebaseAuth.instance.currentUser!;
          // api.createUser();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Successfull"),
            backgroundColor: Color.fromARGB(255, 105, 231, 137),
            elevation: 10, //shadow
          ));
          // Navigator.pop(context);
          if ((await api.userExist())) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          } else {
            await api.createUser().then((value) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage())));
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No user found for that email."),
            backgroundColor: Colors.redAccent,
            elevation: 10, //shadow
          ));
          // uiHelper.CustomAlertBox(
          //     context, "Alert", "No user found for that email.");
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password provided for that user."),
            backgroundColor: Colors.redAccent,
            elevation: 10, //shadow
          ));
          // uiHelper.CustomAlertBox(
          //     context, "Info", "Wrong password provided for that user.");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid Email or Password"),
            backgroundColor: Colors.redAccent,
            elevation: 10, //shadow
          ));
          // uiHelper.CustomAlertBox(context, "Error", e.code.toString());
        }
      } catch (e) {
        // print("Error : $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong."),
          backgroundColor: Colors.redAccent,
          elevation: 10, //shadow
        ));
        // uiHelper.CustomAlertBox(context, "Error", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Implement onTap
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: constraints.maxWidth * 0.9,
                    height: constraints.maxHeight * 0.45,
                    child: Image.asset(
                      'assets/login.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  ResponsiveTextField(
                    controller: emialController,
                    hintText: 'Email',
                    suffixIcon: const Icon(Icons.email),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  ResponsiveTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // Implement toggle logic for password visibility
                      },
                      child: const Icon(Icons.visibility_off),
                    ),
                    isPassword: true,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Forget password?',
                          style:
                              TextStyle(fontSize: constraints.maxWidth * 0.03),
                        ),
                        Container(
                          width: constraints.maxWidth * 0.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 170, 236, 248),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              login();
                              print("The current user is ${api.user.uid}");
                              FocusScope.of(context).unfocus();
                              // Implement login logic
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Don\'t have an account',
                        children: [
                          TextSpan(
                            text: ' Signup',
                            style: TextStyle(
                              color: Color.fromARGB(255, 115, 188, 201),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ResponsiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget suffixIcon;
  final bool isPassword;

  ResponsiveTextField({
    required this.controller,
    required this.hintText,
    required this.suffixIcon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
