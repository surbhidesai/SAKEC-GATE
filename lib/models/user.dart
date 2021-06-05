import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebase{
  String joindate ;
  String MobileNumber ;
  String email ; 
  String fullName ; 

   UserFirebase({
     this.MobileNumber,
     this.email,
     this.fullName,
     this.joindate
   });

   factory UserFirebase.fromDocument(DocumentSnapshot doc){
    return UserFirebase(
      joindate : doc['JoinDate'],
      MobileNumber : doc['MobileNumber'],
      email : doc['email'],
      fullName : doc['fullName'] , 
    );
  }
}