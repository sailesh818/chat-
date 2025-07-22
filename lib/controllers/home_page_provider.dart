import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier{
  
  Stream<QuerySnapshot> get usersStream => FirebaseFirestore.instance.collection('users').snapshots();
}