import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference securityCollection =
      Firestore.instance.collection('security');
  final CollectionReference staffCollection =
      Firestore.instance.collection('staff');
 

  // update userdata
  Future updateUserData(String fullName, String email, String password,
      String MobileNumber) async {
    return await securityCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'MobileNumber': MobileNumber,
      'JoinDate': getCurrentDate(),
    });
  }

  Future updateData(String fullName, String email, String password,
      String MobileNumber,String Token) async {
    return await staffCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'MobileNumber': MobileNumber,
      'JoinDate': getCurrentDate(),
      'FCM':Token,
    });
  }
  Future<QuerySnapshot> getUserData(String email,String Role) async {
    QuerySnapshot snapshot = await Firestore.instance.collection(Role).where('email', isEqualTo: email).getDocuments();
    //print(snapshot.documents[0].data);
    return snapshot;
  }
}

String getCurrentDate() {
  var date = new DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

  return formattedDate.toString();
}
