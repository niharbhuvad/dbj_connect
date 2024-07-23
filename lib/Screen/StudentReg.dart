import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dbj_connect/Screen/Skills.dart';
import 'package:dbj_connect/model/user_model.dart' as model;
import 'package:dbj_connect/resources/StorageMethods.dart';
import 'package:dbj_connect/utils/utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = TextEditingController();
  final SecondNameEditingController = TextEditingController();
  final UIDNameEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmNameEditingController = TextEditingController();
  final phoneController = TextEditingController();
  final SkillController = TextEditingController();
  Uint8List? _image;
  String? photoUrl;
  bool isLoading = false;

  // @override
  // void dispose() {
  //   super.dispose();
  //   UIDNameEditingController.dispose();
  //   passwordEditingController.dispose();
  //   firstNameEditingController.dispose();
  //   SecondNameEditingController.dispose();
  //   phoneController.dispose();
  // }
  // void signUpUser() async {
  //   String res = await AuthMethods().signUser(
  //       email: UIDNameEditingController.text,
  //       password: passwordEditingController.text,
  //       FirstName: firstNameEditingController.text,
  //       LastName: SecondNameEditingController.text,
  //       Phone: phoneController.text,
  //       file: _image!);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
//first

    final firstfield = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

//first

    final secfield = TextFormField(
      autofocus: false,
      controller: SecondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Last Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        SecondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

//first

    final UIDfield = TextFormField(
      autofocus: false,
      controller: UIDNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid Rajagiri Mail");
        }
        return null;
      },
      onSaved: (value) {
        UIDNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

//first

    final phonefield = TextFormField(
      autofocus: false,
      validator: (value) {
        if (value != null) {
          if (value.length != 10) {
            return "Mobile Number must be 10 digits";
          }
        }
        return null;
      },
      controller: phoneController,
      keyboardType: TextInputType.number,
      onSaved: (value) {
        phoneController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe4a2, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number (10 Digits)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );
//first
    final skillfield = TextFormField(
      autofocus: false,
      controller: SkillController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        SkillController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe37b, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter your skills (Use Hashtags)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

//first
    final passfield = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

//first

    // final confirmfield = TextFormField(
    //   autofocus: false,
    //   controller: confirmNameEditingController,
    //   obscureText: true,
    //   keyboardType: TextInputType.name,
    //   validator: (value) {},
    //   onSaved: (value) {
    //     confirmNameEditingController.text = value!;
    //   },
    //   textInputAction: TextInputAction.next,
    //   decoration: InputDecoration(
    //       prefixIcon: Icon(Icons.vpn_key),
    //       contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       hintText: "Confirm Password",
    //       border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(40),
    //       )),
    // );

    final NextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: const Color.fromARGB(255, 27, 4, 110),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_image != null) {
            signUser(
              email: UIDNameEditingController.text,
              password: passwordEditingController.text,
              file: _image!,
            );
          } else {
            Fluttertoast.showToast(msg: "Select Profile Image!");
          }
        },
        child: Container(
          child: !isLoading
              ? const Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : const CircularProgressIndicator(
                  color: Color.fromARGB(255, 18, 3, 103),
                ),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Colors.black,
                                    backgroundImage: MemoryImage(_image!))
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(
                                        'https://imgs.search.brave.com/xovtPOgVsdFwQaH7qdeS9luEKNspqBmFWrdqR7Fsioc/rs:fit:512:512:1/g:ce/aHR0cHM6Ly9wbmcu/cG5ndHJlZS5jb20v/c3ZnLzIwMTYxMjI5/L191c2VybmFtZV9s/b2dpbl8xMTcyNTc5/LnBuZw'),
                                  ),
                            Positioned(
                              bottom: -15,
                              left: 92,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "REGISTRATION FORM",
                          style: TextStyle(
                              color: Color.fromARGB(255, 86, 81, 81),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 25),
                        firstfield,
                        const SizedBox(height: 5),
                        secfield,
                        const SizedBox(height: 5),
                        UIDfield,
                        const SizedBox(height: 5),
                        phonefield,
                        const SizedBox(height: 5),
                        passfield,
                        const SizedBox(height: 5),
                        skillfield,
                        const SizedBox(height: 40),
                        NextButton,
                      ],
                    ))),
          )),
        ));
  }

  Future<String> signUser({
    required String email,
    required String password,
    // required String FirstName,
    // required String LastName,
    // required String Phone,
    required Uint8List file,
  }) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String role = "user";
      String res = "Some error occured";

      try {
        if (email.isNotEmpty || password.isNotEmpty) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          print(cred.user!.uid);
          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);

          model.UserModel userModel = model.UserModel(
              uid: cred.user!.uid,
              email: email,
              firstName: firstNameEditingController.text.toLowerCase(),
              secondName: SecondNameEditingController.text.toLowerCase(),
              phone: phoneController.text,
              // sem: ,
              // Class: [],
              // Division: [],
              // skill: [],
              PhotoUrl: photoUrl,
              role: role,
              skill: SkillController.text);

          await _firestore
              .collection("student")
              .doc(cred.user!.uid)
              .set(userModel.toJson());
          setState(() {
            isLoading = false;
          });

          // Fluttertoast.showToast(msg: "Account created Successfully");
        } else {
          res = "Please enter all the fields";
        }
      } catch (err) {
        res = err.toString();
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pushAndRemoveUntil((context),
          MaterialPageRoute(builder: (context) => Skill()), (route) => false);
      return res;
    } else {
      return "Validation error";
    }
  }
}
