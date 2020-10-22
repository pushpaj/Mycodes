import 'package:autowares/database/local/helper.dart';
import 'package:autowares/database/local/widgetDetail.dart';
import 'package:flutter/material.dart';

class Add_Products extends StatefulWidget {
  final String title;
  final ProductDetail products;

  Add_Products({this.title, this.products});
  @override
  _Add_ProductsState createState() => _Add_ProductsState();
}

class _Add_ProductsState extends State<Add_Products> {
  ProductDBHelper roomHelper = ProductDBHelper();
  TextEditingController _name = TextEditingController();
  TextEditingController _deviceId = TextEditingController();
  TextEditingController _ip = TextEditingController();
  TextEditingController _port = TextEditingController();

  List<String> _dropdownItems = [
    'Roomboard',
    'Camera',
    'Water Tanker Indicator'
  ];
  String _selectedProduct;
  bool editing;

  @override
  void initState() {
    if (widget.products.product != '') {
      setState(() {
        _selectedProduct = widget.products.product;
      });
    }
    setState(() {
      if (widget.title == 'Add product') {
        editing = false;
      } else if (widget.title == 'Edit detail') {
        editing = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _name.text = widget.products.name;
    // _selectedProduct = widget.widgets.product;
    if (widget.products.product != '') {
      setState(() {
        _selectedProduct = widget.products.product;
      });
    }
    _ip.text = widget.products.ip;
    _port.text = widget.products.port;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          !editing
              ? DropdownButton(
                  hint: Text('Choose a product'),
                  isExpanded: true,
                  value: _selectedProduct,
                  onChanged: (val) {
                    setState(() {
                      _selectedProduct = val;
                    });
                  },
                  items: _dropdownItems.map((val) {
                    return DropdownMenuItem<String>(
                      child: new Text(val),
                      value: val,
                    );
                  }).toList(),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: TextFormField(
              controller: _name,
              onChanged: (value) {
                widget.products.name = value;
              },
              decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          !editing
              ? Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: _deviceId,
                    onChanged: (value) {
                      widget.products.deviceId = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Device Id',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                )
              : Container(),
          _selectedProduct == 'Camera' //_dropdownItems[2]
              ? Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: _ip,
                    onChanged: (value) {
                      widget.products.ip = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Ip',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                )
              : Container(),
          _selectedProduct == 'Camera' //_dropdownItems[2]
              ? Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    controller: _port,
                    onChanged: (value) {
                      widget.products.port = value;
                    },
                    decoration: InputDecoration(
                        labelText: 'Port',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                )
              : Container(),
          RaisedButton(
            color: Theme.of(context).primaryColorDark,
            textColor: Theme.of(context).primaryColorLight,
            child: Text(
              (widget.title == 'Edit detail') ? 'Update' : 'Save',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              setState(() {
                _save();
              });
            },
          ),
        ],
      ),
    );
  }

  /*void find() async {
    ProductDetail data = await roomHelper.getParticularWidgets(2);
    print(data.name);
  }*/

  void _save() async {
    int result;
    setState(() {
      widget.products.product = _selectedProduct;
    });
    if (widget.products.id != null) {
      roomHelper.update(widget.products);
    } else {
      roomHelper.save(widget.products);
    }

    /*if(result!=0){
      _showAlertDialog('Status', 'Room created successfully');
    }else{
       _showAlertDialog('Status', 'Problem creating room');
    }
    setState(() {
      _name.clear();
    });*/
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
