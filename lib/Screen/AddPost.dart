import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dbj_connect/resources/firestoreMethod.dart';
import 'package:dbj_connect/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController SecondNameEditingController =
      TextEditingController();
  bool isLoading = false;

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Posted!');
        clearImage();
      } else {
        showSnackBar(context, 'failed');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  void postDesc(
      String uid, String username, String secname, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadDesc(
          _descriptionController.text, uid, username, secname, profImage);
      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, 'Posted!');
        clearImage();
      } else {
        showSnackBar(context, 'failed');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: const Text('Create a Post'), children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
          ]);
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  String username = "";
  String id = "";
  String photourl = "";

  String secname = "";

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('student')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      username = (snap.data() as Map<String, dynamic>)['firstName'];
      id = FirebaseAuth.instance.currentUser!.uid;
      photourl = (snap.data() as Map<String, dynamic>)['photoUrl'];
      secname = (snap.data() as Map<String, dynamic>)['secondName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(child: Text('$photoUrl')),
    // );

    // final UserModel user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 17, 4, 92),
              title: const Text("ADD POST"),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1.0,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: "Enter Description here",
                          contentPadding: EdgeInsets.only(left: 20),
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        // padding: const EdgeInsets.only(right: 20, top: 40),
                        icon: const Icon(
                          Icons.upload,
                          size: 50,
                        ),
                        color: Colors.black,
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () => _selectImage(context),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 19, 5, 100),
                    child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: (() =>
                          postDesc(id, username, secname, photourl)),
                      child: Container(
                        child: !isLoading
                            ? const Text(
                                "Post",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const LinearProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 11, 5, 86),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("POST TO"),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 170,
                        width: 170,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.scaleDown,
                              alignment: FractionalOffset.topCenter,
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.49,
                          child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write the Information here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                        ),
                        maxLines: 8,
                      )),
                    ],
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 11, 4, 105),
                    child: MaterialButton(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: (() => postImage(
                            id,
                            username,
                            photourl,
                          )),
                      child: Container(
                        child: !isLoading
                            ? const Text(
                                "Post",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            : const LinearProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ));
  }
}
