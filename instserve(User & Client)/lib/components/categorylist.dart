import 'package:flutter/material.dart';
import 'package:instserve/userpages/clientlist.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var category_list = [
    {
      "name": "Carpenter",
      "picture": "images/ServiceProvider/real/Carpenter.jpg",
    },
    {
      "name": "Chef(Hotel & Restaurant)",
      "picture": "images/ServiceProvider/real/Chefs.jpg",
    },
    {
      "name": "Electrician",
      "picture": "images/ServiceProvider/real/Electrician.jpg",
    },
    {
      "name": "Bodyguard",
      "picture": "images/ServiceProvider/real/Guardsman.jpg",
    },
    {
      "name": "Cook",
      "picture": "images/ServiceProvider/real/Cook.jpg",
    },
    {
      "name": "Home Tutor",
      "picture": "images/ServiceProvider/real/Home Tutor.jpg",
    },
    {
      "name": "Maintainer(AC,Cooler,etc)",
      "picture": "images/ServiceProvider/real/Maintenance.jpg",
    },
    {
      "name": "Mason(Raj Mistri)",
      "picture": "images/ServiceProvider/real/Mason.jpg",
    },
    {
      "name": "Driver",
      "picture": "images/ServiceProvider/real/Driver.jpg",
    },
    {
      "name": "Painter(House)",
      "picture": "images/ServiceProvider/real/homepainter.jpg",
    },
    {
      "name": "Housemaid",
      "picture": "images/ServiceProvider/real/House Maid.jpg",
    },
    {
      "name": "Washerman",
      "picture": "images/ServiceProvider/real/Laundry.jpg",
    },
    {
      "name": "Car Mechanic",
      "picture": "images/ServiceProvider/real/Carmechanic.jpg",
    },
    {
      "name": "Milkman",
      "picture": "images/ServiceProvider/real/Milkman.jpg",
    },
    {
      "name": "Plumber",
      "picture": "images/ServiceProvider/real/Plumber.jpg",
    },
    {
      "name": "Tailor(Darjiwala)",
      "picture": "images/ServiceProvider/real/Tailor.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: GridView.builder(
        itemCount: category_list.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Single_Category(
              category_name: category_list[index]['name'],
              category_image: category_list[index]['picture'],
            ),
          );
        },
      ),
    );
  }
}

class Single_Category extends StatelessWidget {
  final category_name;
  final category_image;

  Single_Category({this.category_name, this.category_image});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 14,
      child: Hero(
        tag: Text('abcd'),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) => ClientList(
                  selectedprof: category_name,
                ),
              ),
            );
          },
          child: GridTile(
            footer: Container(
              color: Colors.white,
              child: Center(
                child: Text(category_name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              ),
            ),
            child: Image.asset(
              category_image,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
