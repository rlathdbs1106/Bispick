import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  CRUD crud = new CRUD();
  Stream? requeststream;
  int? num_requests;
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    isloading = true;
    crud.getRequests().then((value) {
      setState(() {
        isloading = false;
        requeststream = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isloading)
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'All Requests',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddRequest()));
                      // showSearch(
                      //   context: context,
                      //   delegate: CustomSearchDelegate(),

                      // );
                    },
                  ),
                ),
              ],
            ),
            body: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: requeststream as Stream<QuerySnapshot>,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.connectionState);
                    return Center(
                      child: Text('ERROR HAS HAPPENED'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final request = snapshot.data!.docs[index];
                        final title = request.get('title');
                        final description = request.get('content');
                        final requestid = request.id;

                        return Card(
                          margin: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(title.toString()),
                                  subtitle: Text(description.toString()),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        crud.deleterequest(requestid);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No Requests yet'));
                  }
                },
              ),
            ),
          );
  }
}

class AddRequest extends StatefulWidget {
  const AddRequest({super.key});

  @override
  State<AddRequest> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  bool isuploading = false;
  String? username;
  String? title;
  String? content;

  CRUD crud = new CRUD();
  final formKey = GlobalKey<FormState>();

  void uploadreq() async {
    crud
        .uploadRequest(title, username, content, DateTime.now().toString())
        .then((value) {
      isuploading = false;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isuploading)
        ? Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: Colors.black,
                  ),
                  Text('Uploading in process...\n This may take a while...')
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(
                'Add Request',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: Form(
              key: formKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Username',
                            hintText: 'What is your name?'),
                        onChanged: (value) {
                          username = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Title',
                            hintText: 'What is your request?'),
                        onChanged: (value) {
                          title = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please write the title of your request.';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Content',
                            hintText: 'Elaborate your request.'),
                        onChanged: (value) {
                          content = value;
                        },
                        validator: (value) {
                          // Validate if the input is empty
                          if (value == null || value.isEmpty) {
                            return 'Please write the details of your request.';
                          }
                          // Return null if the input is valid
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isuploading = true;
                            });
                            uploadreq();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Upload',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
