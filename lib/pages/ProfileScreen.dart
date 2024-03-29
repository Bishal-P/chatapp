import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/components/apis.dart';
import 'package:chatapp/pages/imageViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final DocumentSnapshot? doc;
  ProfileScreen({super.key, this.doc});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var name;
  var about;
  var email;

  void updateData() async {
    await api.firestore.collection("users").doc(widget.doc!.id).update({
      "name": name,
      "about": about,
      "email": email,
    }).then((value) {
      // print("Updated successfully");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login Successfull"),
        backgroundColor: Color.fromARGB(255, 105, 231, 137),
        elevation: 10, //shadow
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_left, color: Colors.black)),
          title: Text("Profile", style: Theme.of(context).textTheme.headline4),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: List.generate(
                              10,
                              (index) => BoxShadow(
                                color: Color.fromARGB(255, 13, 255, 13)
                                    .withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            )
                            // color: Colors.grey[300],
                            ),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => image_viewer(
                                imageList: [widget.doc!["image"]], index: 1));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                                imageUrl: widget.doc!['image'],
                                placeholder: (context, url) => const Icon(
                                  Icons.person,
                                  size: 30,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            final ImagePicker picker = ImagePicker();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 200,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading:const Icon(Icons.camera_alt),
                                          title: const Text("Camera"),
                                          onTap: () async {
                                            final XFile? image =
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            // Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading:const Icon(Icons.photo),
                                          title:const Text("Gallery"),
                                          onTap: () async {
                                            final XFile? image =
                                                await picker.pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 80);
                                            if (image != null) {
                                              api
                                                  .updateProfilePicture(
                                                      File(image.path))
                                                  .then((value) {
                                                print("The value is $value");
                                                setState(() {});
                                              });
                                              Navigator.pop(context);
                                              
                                            }
                                            // Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey[200],
                            ),
                            child: const Icon(Icons.camera_alt, size: 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          onSaved: (newValue) => name = newValue,
                          validator: (value) =>
                              value!.isEmpty ? "Please enter your name" : null,
                          // controller: nameController,
                          initialValue: widget.doc!['name'].toString(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              label: Text("Name"),
                              prefixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onSaved: (newValue) => email = newValue,
                          validator: (value) =>
                              value!.isEmpty ? "Please enter your email" : null,
                          initialValue: widget.doc!['email'].toString(),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              label: Text("Email"),
                              prefixIcon: Icon(Icons.email)),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                            onSaved: (newValue) => about = newValue,
                            validator: (value) =>
                                value!.isEmpty ? "Please enter about" : null,
                            initialValue: widget.doc!['about'].toString(),
                            // keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                label: Text(
                                  "About",
                                ),
                                prefixIcon: Icon(Icons.abc))),
                        const SizedBox(height: 20),
                        
                        const SizedBox(height: 50),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              updateData();
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 89, 223, 247),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text("Update",
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w400)),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
