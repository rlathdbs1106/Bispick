import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CRUD {
  Future<void> uploadData(String? username, String? boxnum, String? category,
      String? description, String? time, String? photoURL) async {
    try {
      CollectionReference lostthingsCollection =
          FirebaseFirestore.instance.collection("Lostthings");
      DocumentReference newLostthingRef = lostthingsCollection.doc();
      Map<String, dynamic> lostthing = {
        'username': username,
        'box_number': boxnum,
        'category': category,
        'description': description,
        'time': time,
        'photourl': photoURL
      };
      await newLostthingRef.set(lostthing);
    } on Exception catch (e) {
      // TODO
      print("ERROR in uploading data to firebase firestore!");
    }
  }

  String extractFilePathFromURL(String photoURL) {
    Uri uri = Uri.parse(photoURL);
    List<String> pathParts = uri.pathSegments;
    int filePathIndex = pathParts.indexOf('o') + 1;
    return pathParts.sublist(filePathIndex).join('/');
  }

  deleteData(docid, photourl) async {
    FirebaseFirestore.instance
        .collection('Lostthings')
        .doc(docid)
        .delete()
        .catchError((e) {
      print(e);
    });
    String filepath = extractFilePathFromURL(photourl);
    FirebaseStorage.instance.ref().child(filepath).delete();
  }

  Future<dynamic> getallLostthings() async {
    return await FirebaseFirestore.instance
        .collection('Lostthings')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> uploadRequest(
      String? title, String? username, String? content, String? time) async {
    try {
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('Requests');
      DocumentReference newRequestRef = requestsCollection.doc();

      Map<String, dynamic> request = {
        'title': title,
        'username': username,
        'content': content,
        'time': time,
      };

      await newRequestRef.set(request);
    } on Exception catch (e) {
      print('Error adding lostthing');
    }
  }

  Future<dynamic> getRequests() async {
    return await FirebaseFirestore.instance
        .collection('Requests')
        .orderBy('time', descending: true)
        .snapshots();
  }

  deleterequest(docid) async {
    FirebaseFirestore.instance
        .collection('Lostthings')
        .doc(docid)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future<dynamic> getEdevices() async {
    return await FirebaseFirestore.instance
        .collection('Lostthings')
        .where('category', isEqualTo: 'E-Device')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<dynamic> getClothings() async {
    return await FirebaseFirestore.instance
        .collection('Lostthings')
        .where('category', isEqualTo: 'Clothing')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<dynamic> getStationerys() async {
    return await FirebaseFirestore.instance
        .collection('Lostthings')
        .where('category', isEqualTo: 'Stationery')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<dynamic> getOthers() async {
    return await FirebaseFirestore.instance
        .collection('Lostthings')
        .where('category', isEqualTo: 'Others')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
