import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dbj_connect/Screen/SkillProfile.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowusers = false;
  Future<QuerySnapshot<Map<String, dynamic>>>? usersFun;
  String searchText = "";
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usersFun = getSkillsUsers();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 4, 98),
        title: Form(
          child: TextFormField(
            controller: searchController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Enter the UID here',
              labelStyle: TextStyle(color: Colors.white),
            ),
            onFieldSubmitted: (String value) {
              setState(() {
                // isShowusers = true;
                if (value.isEmpty) {
                  usersFun = getSkillsUsers();
                } else {
                  // usersFun = getSearchUsers();
                  searchText = searchController.text;
                }
              });
            },
          ),
        ),
      ),
      body: FutureBuilder(
        future: (searchController.text.isEmpty)
            ? FirebaseFirestore.instance.collection('student').get()
            : FirebaseFirestore.instance
                .collection('student')
                .where(Filter.or(Filter("firstName", isEqualTo: searchText),
                    Filter("secondName", isEqualTo: searchText)))
                .get(),
        // future: usersFun,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen3(
                      uid: (snapshot.data! as dynamic).docs[index]['uid'],
                    ),
                  ),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(
                        'https://www.dbjcollege.org.in/images/dbjlogo.png'
                        // (snapshot.data! as dynamic).docs[index]
                        //     ['photoUrl']
                        ),
                  ),
                  title: Text((snapshot.data! as dynamic).docs[index]['email']),
                  subtitle: Row(
                    children: [
                      Text(
                        (snapshot.data! as dynamic).docs[index]['firstName'],
                      ),
                      Text(
                        (snapshot.data! as dynamic).docs[index]['secondName'],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSkillsUsers() async {
    return await FirebaseFirestore.instance
        .collection('student')
        .where('skill', isEqualTo: searchController.text)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getSearchUsers() async {
    Fluttertoast.showToast(msg: "Search Users Clicked");
    return await FirebaseFirestore.instance
        .collection('student')
        // .where('skill', isGreaterThanOrEqualTo: searchController.text)
        // .where("firstName", isEqualTo: searchController.text.toLowerCase())
        // .where(
        //   Filter.or(
        //     Filter("firstName", isEqualTo: searchController.text),
        //     Filter("secondName", isEqualTo: searchController.text),
        //   ),
        // )
        .get();
  }
}
