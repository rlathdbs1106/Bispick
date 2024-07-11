import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:bispick/pages/home.dart';
import 'package:bispick/pages/itemsdetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllLostThings extends StatefulWidget {
  const AllLostThings({super.key});

  @override
  State<AllLostThings> createState() => _AllLostThingsState();
}

class _AllLostThingsState extends State<AllLostThings> {
  CRUD crud = new CRUD();
  Stream? lostthingstream;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    // TODO: implement initState
    crud.getallLostthings().then((value) {
      setState(() {
        isLoading = false;
        lostthingstream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
            ),
          )
        ],
        title: Text(
          'All Lost Items',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: lostthingstream as Stream<QuerySnapshot>,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              print(snapshot.connectionState);
              return Center(
                child: Text("ERROR HAS HAPPENED"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final lostThing = snapshot.data!.docs[index];
                    final photoURL = lostThing.get('photourl');
                    final description = lostThing.get("description");
                    final box_num = lostThing.get("box_number");
                    final lostthingid = lostThing.id;

                    return Card(
                        margin: EdgeInsets.all(10),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LostThingDetailView(
                                            username: snapshot.data!.docs[index]
                                                .get('username'),
                                            box_number: box_num,
                                            photourl: photoURL,
                                            description: description,
                                            time: snapshot.data!.docs[index]
                                                .get('time'),
                                            id: lostthingid,
                                          )));
                            },
                            child: Stack(children: [
                              Opacity(
                                opacity: 8.5,
                                child: Container(
                                  height: (MediaQuery.of(context).size.height -
                                          56) /
                                      3,
                                  padding: const EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    image: DecorationImage(
                                        opacity: 0.5,
                                        image: NetworkImage(photoURL),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Container(
                                  height: (MediaQuery.of(context).size.height -
                                          56) /
                                      3,
                                  padding: const EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(description,
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Text(
                                              box_num,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ])))
                            ])));
                  });
            } else {
              print('hi');
              return Center(
                child: Text("No lost things yet"),
              );
            }
          },
        ),
      ),
    );
  }
}
