import 'package:autowares/database/local/elementDetail.dart';
import 'package:autowares/database/local/helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Rooms extends StatefulWidget {
  final title;
  final id;
  Rooms({this.title, this.id});
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  var ref = FirebaseDatabase.instance.reference();
  bool isEditable = false;
  /*bool isEditable1 = false;
  bool isEditable2 = false;
  bool isEditable3 = false;
  bool isEditable4 = false;
  bool isEditable5 = false;
  bool isEditable6 = false;
  bool isEditable7 = false;
  bool isEditable8 = false;*/

  String _selectedElement;
  ProductDBHelper roomHelper = ProductDBHelper();
  ElementDetail element=ElementDetail(null,null,'');

  List<String> _dropdownItems = [
    'Air Conditioner',
    'Bulb',
    'Cooler',
    'Fan',
    'Night Bulb',
    'Refrigirator',
    'Socket',
    'Table Lamp',
    'TubeLight',
    'TV',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey[700],
        actions: <Widget>[
          IconButton(
              icon: Icon(
                isEditable ? Icons.done : Icons.edit,
                color: isEditable ? Colors.blue : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              })
        ],
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child:
            /*DropdownButton(
          hint: Text('Choose a product'),
          isExpanded: true,
          value: _selectedElement,
          onChanged: (val) {
            setState(() {
              _selectedElement = val;
            });
          },
          items: _dropdownItems.map((val) {
            return DropdownMenuItem<String>(
              child: new Text(val),
              value: val,
            );
          }).toList(),
        ),*/

            StreamBuilder(
          stream: ref.child(widget.id).onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            } else {
              var data = snapshot.data.snapshot;
              int len = snapshot.data.snapshot.value.length;
              return ListView.builder(
                itemCount: len,
                itemBuilder: (BuildContext context, int index) {
                  return customUtilityButton(
                      //snapshot.data[index]
                      data.value['utility${index + 1}'],
                      index);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget customUtilityButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 10),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isEditable
                      ? DropdownButton(
                          dropdownColor: Colors.green,
                          hint: Text('Choose a product'),
                          //isExpanded: false,
                          isDense: true,
                          value: _selectedElement,
                          onChanged: (val) {
                            setState(() {
                              _selectedElement = val;
                            });
                          },
                          items: _dropdownItems.map((val) {
                            return DropdownMenuItem<String>(
                              child: Center(
                                child: Text(
                                  val,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(),
                                ),
                              ),
                              value: val,
                            );
                          }).toList(),
                        )
                      : Text(
                          'Utility${index + 1}',
                          style: TextStyle(fontSize: 20),
                        ),
                  isEditable
                      ? IconButton(
                          icon: Icon(
                            Icons.done,
                            color: isEditable ? Colors.blue : Colors.white,
                          ),
                          onPressed: () {
                            print(element.element_id);
                            setState(() {
                              element.element_name = _selectedElement;
                              element.element_index = index+1;
                            });
                            print(element.element_id);
                            roomHelper.save_elements(element,widget.title);
                          })
                      : Container()
                ],
              ),
            ),
          ),
          ClipOval(
            child: Material(
              shape: CircleBorder(
                side:
                    BorderSide(color: text == 'on' ? Colors.green : Colors.red),
              ),
              elevation: 20,
              color: Colors.blueGrey[900], // button color
              child: InkWell(
                splashColor:
                    text == 'on' ? Colors.red : Colors.green, // inkwell color
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Center(
                    child: text != null
                        ? Text(
                            text,
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                onTap: () {
                  if (text == 'off')
                    ref.child(widget.id).update({'utility${index + 1}': 'on'});
                  else
                    ref.child(widget.id).update({'utility${index + 1}': 'off'});
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  saveDetail() {
    setState(() {
      //element.name = _selectedElement;
    });
    //roomHelper.save_elements(element);
    print(_selectedElement);
  }
}
