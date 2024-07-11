import 'package:bispick/lostitemCRUD/CRUD.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LostThingDetailView extends StatefulWidget {
  final String username;
  final String box_number;
  final String photourl;
  final String description;
  final String time;
  final String id;

  const LostThingDetailView(
      {Key? key,
      required this.username,
      required this.box_number,
      required this.photourl,
      required this.description,
      required this.time,
      required this.id})
      : super(key: key);

  @override
  State<LostThingDetailView> createState() => _LostThingDetailViewState();
}

class _LostThingDetailViewState extends State<LostThingDetailView> {
  CRUD crud = CRUD();

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(widget.time.toString());

    String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "IS THIS YOURS?",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 56,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("FOUNDER: ",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(widget.username.toString(),
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(
                          "FOUND TIME: ",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(formattedDateTime,
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(
                          "LOCATION: ",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(widget.box_number),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 56,
                        child: Text(
                          "DESCRIPTON: ",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 56,
                            child: Text(widget.description,
                                style: TextStyle(color: Colors.black))))
                  ],
                ),
              ),
              Expanded(
                child: Image.network(
                  widget.photourl,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 48),
                  child: ElevatedButton(
                      onPressed: () {
//show alert dialog
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                content: Text(
                                  'Does this belong to you?',
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        crud.deleteData(
                                            widget.id, widget.photourl);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'YES',
                          style: TextStyle(color: Colors.white),
                        )
                      ])))
            ])));
  }
}
