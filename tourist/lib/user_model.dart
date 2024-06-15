import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String address;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromsnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uid: document.id,
      email: data['email'],
      name: data['name'],
      phone: data['phone'],
      address: data['address'],
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, phone: $phone, address: $address)';
  }
}
