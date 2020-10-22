import 'package:autowares/addRoom.dart';
import 'package:autowares/database/local/helper.dart';
import 'package:autowares/database/local/widgetDetail.dart';
import 'package:autowares/rooms.dart';
import 'package:autowares/settings.dart';
import 'package:autowares/signuppage.dart';
import 'package:autowares/waterLevel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';
import 'cameras.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<ProductDetail>> products;
  List<ProductDetail> producties;
  var productDbHelper;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    productDbHelper = ProductDBHelper();
    refreshList();
  }

  refreshList() {
    setState(() {
      products = productDbHelper.getWidgets();
    });
    productDbHelper.getWidgets().then((res) {
      producties = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('HomeAutoware'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit,color: isEditable?Colors.blue:Colors.white,),
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              })
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      body:rooms(),
      floatingActionButton: isEditable
          ? FloatingActionButton(
              heroTag:'unun',// null,
              onPressed: () async {
                bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Add_Products(
                      products: ProductDetail(null, '', '', '', '', ''),
                      title: 'Add product',
                    ),
                  ),
                );

                if (result) {
                  refreshList();
                }
              },
              tooltip: 'Add product',
              child: Icon(Icons.add),
            )
          : Container(),
      drawer: new Drawer(
        child: Container(
          color: Colors.blueGrey[900],
          child: ListView(
            children: <Widget>[
//          Drawer header
              new UserAccountsDrawerHeader(
                accountName: Text('Pushpaj'),
                accountEmail: Text('PushpajGupta@gmail.com'),
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: ClipOval(
                      child: SizedBox(
                        height: 90,
                        width: 90,
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Colors.blueGrey[700],
                ),
              ),
//          Drawer Body
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'My Home',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {},
                ),
              ),

              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Automation',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.wb_auto,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Features',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.featured_play_list,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.blueGrey,
                  ),
                ),
              ),

              Divider(
                color: Colors.blueGrey[700],
              ),

              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                child: ListTile(
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  leading: Icon(
                    Icons.transit_enterexit,
                    color: Colors.red,
                  ),
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  rooms() {
    return FutureBuilder(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int position) {
              return customProductButton(snapshot.data[position]);
            },
          );
        }
        if (snapshot.data == null || snapshot.data.length == 0) {
          return Text('no data');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget customProductButton(ProductDetail detail) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 30),
      height: 300,
      width: 300,
      child: FittedBox(
        fit: BoxFit.contain,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(100.0),),
          elevation: 15,
          color: Colors.transparent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Rooms(
                          title: detail.name,
                          id: detail.deviceId,
                        )));
          },
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Card(
                color: Colors.blueGrey[900],
                child: productImage(detail.product),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0),
                ),
              ),
              Text(
                detail.name,
                style: TextStyle(fontSize: 100),
                textAlign: TextAlign.center,
              ),
              isEditable
                  ? Positioned(
                      //width: 5,
                      right: 0,
                      top: 0,
                      child: Container(
                        height: 150,
                        width: 150,
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: 120,
                          ),
                          onPressed: () {
                            productDbHelper.delete(detail.id);
                            refreshList();
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    )
                  : Container(),
              isEditable
                  ? Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        height: 150,
                        width: 150,
                        child: FloatingActionButton(
                          heroTag: null,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.edit,
                            size: 120,
                          ),
                          onPressed: () async {
                            bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Add_Products(
                                  products: detail,
                                  title: 'Edit detail',
                                ),
                              ),
                            );
                            if (result) {
                              refreshList();
                            }
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget productImage(String product) {
    if (product == 'Roomboard') {
      return Image.asset(
        'images/room.png',
        fit: BoxFit.fill,
      );
    } else if (product == 'Camera') {
      return Image.asset(
        'images/camera.png',
        fit: BoxFit.fill,
      );
    } else if (product == 'Water Tanker Indicator') {
      return Image.asset(
        'images/logo.png',
        fit: BoxFit.fill,
      );
    }
  }
}



/*ListView(
      children: <Widget>[
        customButton(
          'Utilities',
          Rooms(),
        ),
        customButton(
          'Cameras',
          CCTVCameras(
            channel: IOWebSocketChannel.connect('ws://34.94.119.249:65080'),
          ),
        ),
        customButton(
          'Water Level',
          WaterLevel(),
        ),
      ],
    );*/
