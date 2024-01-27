import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white)),
        title: Text("Profile", style: Theme.of(context).textTheme.headline4),
      ),
    );
  }
}
