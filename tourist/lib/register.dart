import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:tourist/components.dart';
import "package:tourist/homepage.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:tourist/login.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist/user_model.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final addresscontroller = TextEditingController();

  toJson() {
    return {
      "name": namecontroller.text,
      "email": emailcontroller.text,
      "phone": phonecontroller.text,
      "address": addresscontroller.text,
    };
  }

  Future<User?> SignupWithEmailAndPassword(BuildContext context) async {
    //   showDialog(context: context, builder: (context)){
    //   return const Center(child: CircularProgressIndicator());
    // }
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Component()),
      );
      await db
          .collection('User_info')
          .doc(
            _auth.currentUser!.uid,
          )
          .set(toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel> userdetail(String email) async {
    final snapshot =
        await db.collection('users').where('email', isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromsnapshot(e)).single;
    return userdata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFFfd5c63)),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, 0.3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
                                    )
                                  ]),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextField(
                                        controller: namecontroller,
                                        decoration: InputDecoration(
                                            hintText: "Full name",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextField(
                                        controller: emailcontroller,
                                        decoration: InputDecoration(
                                            hintText: "Email Address",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextField(
                                        controller: passwordcontroller,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextField(
                                        controller: phonecontroller,
                                        decoration: InputDecoration(
                                            hintText: "Phone number",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!))),
                                      child: TextField(
                                        controller: addresscontroller,
                                        decoration: InputDecoration(
                                            hintText: "Home address",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.orange[900]!),
                                  ),
                                  onPressed: () {
                                    SignupWithEmailAndPassword(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
