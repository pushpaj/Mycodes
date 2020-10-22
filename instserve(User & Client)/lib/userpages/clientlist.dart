import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instserve/userpages/clientdetailpage.dart';
import 'package:instserve/widget/progress.dart';

class ClientList extends StatefulWidget {
  final selectedprof;
  ClientList({this.selectedprof});
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  final double filterDistance = 5000;
  List clients = [];
  bool clientToggle = false;

  getClientData() async {
    await Firestore.instance
        .collection('client')
        .where('profession', isEqualTo: widget.selectedprof)
        .getDocuments()
        .then((list) async {
      //    Getting Location of User.....
      await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((loc) async {
        if (list.documents.isNotEmpty) {
          for (int i = 0; i < list.documents.length; i++) {
            if ((await Geolocator().distanceBetween(
                    loc.latitude,
                    loc.longitude,
                    list.documents[i].data["location"].latitude,
                    list.documents[i].data["location"].longitude)) <=
                filterDistance) {
              clients.add(list.documents[i].data);
            }
          }
          setState(() {
            clientToggle = true;
          });
        } else {
          setState(() {
            clientToggle = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    getClientData();
    super.initState();
  }

  @override
  void dispose() {
    getClientData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('List of  ' + widget.selectedprof),
          centerTitle: true,
        ),
        body: clientToggle
            ? (clients.isNotEmpty
                ? ListView.builder(
                    itemCount: clients.length,
                    padding: EdgeInsets.all(5.0),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Single_Info(
                            name: clients[i]["name"],
                            gender: clients[i]["gender"],
                            dob: clients[i]["dob"],
                            contact: clients[i]["contact"],
                            img: clients[i]["profilePicUrl"],
                            profession: widget.selectedprof),
                      );
                    })
                : Center(
                    child: Text(
                      'There is no ${widget.selectedprof} in your area!',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4), fontSize: 18),
                    ),
                  ))
            : Center(
                child: circularProgress(),
              ));
  }
}

class Single_Info extends StatelessWidget {
  final profession;
  final name;
  final dob;
  final img;
  final contact;
  final gender;

  Single_Info({
    this.profession,
    this.name,
    this.dob,
    this.img,
    this.contact,
    this.gender,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientDetailPage(
              profile_name: name,
              profile_age: dob,
              profile_image: img,
              profile_contact: contact,
              profile_gender: gender,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        width: double.infinity,
        child: FittedBox(
          child: Material(
            color: Colors.blueGrey.shade300,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: showPic()
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            child: Text(
                              name != null ? name : 'Not Mentioned',
                              style: TextStyle(
                                color: Colors.teal.shade100,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(dob != null ? dob : 'Not Mentioned'),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Status : '),
                              Text(
                                'Available',
                                style: TextStyle(
                                    color: Colors.greenAccent, fontSize: 16),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Container showPic() {
    if(img != null){
     return Container(
       child: Image.network(
                              img,
                              fit: BoxFit.fill,
                            ),
     );
    }
                        
                        
    else if (profession == 'Car Mechanic') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Carmechanic.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Carpenter') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Carpenter.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Chef(Hotel & Restaurant)') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Chefs.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Driver') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Driver.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Electrician') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Electrician.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Bodyguard') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Guardsman.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Cook') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Halwai.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Painter(House)') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/homepainter.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Home Tutor') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/HomeTutor.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Housemaid') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/House Maid.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Washerman') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Laundry.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Maintainer(AC,Cooler,etc)') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Maintenance.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Mason(Raj Mistri)') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Mason.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Milkman') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Milkman.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Plumber') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Plumber.png',
          fit: BoxFit.fill,
        ),
      );
    } else if (profession == 'Tailor(Darjiwala)') {
      return Container(
        child: Image.asset(
          'images/ServiceProvider/animated/Tailor.png',
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container(
        child: Icon(
          Icons.person,
          size: 100,
        ),
      );
    }
  }
}
