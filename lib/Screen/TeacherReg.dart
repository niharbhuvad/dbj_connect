import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dbj_connect/Screen/HomeScreen.dart';
import 'package:dbj_connect/model/teacher_model.dart' as model;
import 'package:dbj_connect/resources/StorageMethods.dart';
import 'package:dbj_connect/utils/utils.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  List<dynamic> countries = [];
  List<dynamic> statesMasters = [];
  List<dynamic> states = [];
  String? countryId;
  String? stateId;
  String? branch;
  String? division;

  @override
  void initState() {
    super.initState();

    this.countries.add({"id": 1, "label": "CS"});
    this.countries.add({"id": 2, "label": "IT"});
    this.countries.add({"id": 3, "label": "BSC"});
    this.countries.add({"id": 4, "label": "MBA"});
    this.countries.add({"id": 5, "label": "Commerce"});
    this.countries.add({"id": 6, "label": "Arts"});
    this.countries.add({"id": 7, "label": "Bio Technology"});
    this.countries.add({"id": 8, "label": "NCC"});
    this.countries.add({"id": 9, "label": "Cultural"});

    this.statesMasters = [
      {"ID": 1, "Name": "ALPHA", "ParentId": 4},
      {"ID": 2, "Name": "BETA", "ParentId": 4},
      {"ID": 1, "Name": "ALPHA", "ParentId": 2},
      {"ID": 2, "Name": "BETA", "ParentId": 2},
      {"ID": 3, "Name": "GAMMA", "ParentId": 2},
      {"ID": 1, "Name": "ALPHA", "ParentId": 1},
      {"ID": 2, "Name": "BETA", "ParentId": 1},
      {"ID": 3, "Name": "GAMMA", "ParentId": 1},
    ];
  }

  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final SecondNameEditingController = new TextEditingController();
  final UIDNameEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmNameEditingController = new TextEditingController();
  final phoneController = new TextEditingController();
  final specController = new TextEditingController();
  Uint8List? _image;
  String? photoUrl;

  @override
  void dispose() {
    super.dispose();
    UIDNameEditingController.dispose();
    passwordEditingController.dispose();
    firstNameEditingController.dispose();
    SecondNameEditingController.dispose();
    phoneController.dispose();
  }

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
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe043, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
    final specfield = TextFormField(
      autofocus: false,
      controller: specController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        specController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(IconData(0xe37b, fontFamily: 'MaterialIcons')),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter Specialization",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final passfield = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      keyboardType: TextInputType.name,
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

    final NextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: const Color.fromARGB(255, 33, 6, 110),
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
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : const CircularProgressIndicator(
                  color: Colors.black,
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
                              color: Color.fromARGB(255, 117, 111, 111),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
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
                        specfield,
                        const SizedBox(height: 5),
                        SizedBox(
                            width: 800.0,
                            child: FormHelper.dropDownWidget(
                                context,
                                "Select Branch",
                                this.countryId,
                                this.countries, (onChangedVal) {
                              this.countryId = onChangedVal;
                              branch = onChangedVal;
                              print("Selected Branch : $onChangedVal");

                              this.states = this
                                  .statesMasters
                                  .where(
                                    (stateItem) =>
                                        stateItem["ParentId"].toString() ==
                                        onChangedVal.toString(),
                                  )
                                  .toList();
                              this.stateId = null;
                            }, (onValidateVal) {
                              if (onValidateVal == null) {
                                return 'Please Select Branch';
                              }
                              return null;
                            },
                                borderColor: Theme.of(context).primaryColor,
                                borderFocusColor:
                                    Theme.of(context).primaryColor,
                                borderRadius: 40,
                                optionValue: "id",
                                optionLabel: "label",
                                paddingLeft: 0.0,
                                paddingRight: 0.0)),
                        const SizedBox(height: 5),
                        FormHelper.dropDownWidget(context, "Select Division",
                            this.stateId, this.states, (onChangedVal) {
                          this.stateId = onChangedVal;
                          division = onChangedVal;
                          print("Selected Division : $onChangedVal");
                        }, (onValidate) {
                          return null;
                        },
                            borderColor: Theme.of(context).primaryColor,
                            borderFocusColor: Theme.of(context).primaryColor,
                            borderRadius: 40,
                            optionValue: "ID",
                            optionLabel: "Name",
                            paddingLeft: 0.0,
                            paddingRight: 0.0),
                        const SizedBox(height: 15),
                        NextButton,
                      ],
                    ))),
          )),
        ));
  }

  Future<String> signUser({
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    setState(() {
      isLoading = true;
    });
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.Teacher userModel = model.Teacher(
          uid: cred.user!.uid,
          email: email,
          firstName: firstNameEditingController.text,
          secondName: SecondNameEditingController.text,
          phone: phoneController.text,
          branch: countryId,
          division: stateId,
          photoUrl: photoUrl,
          skill: specController.text,
        );

        await _firestore
            .collection("student")
            .doc(cred.user!.uid)
            .set(userModel.toMap());
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Account created Successfully");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
      setState(() {
        isLoading = false;
      });
    }
    return res;
  }
}
