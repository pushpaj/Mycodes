//import 'package:autowares/addRoom.dart';
class ProductDetail{
  int id;
  String deviceId;
  String name;
  String product;
  String ip;
  String port;
  //String serailNo;

  ProductDetail(this.id,this.deviceId,this.name,this.product,this.ip,this.port);

  Map<String,dynamic> toMap(){
    var map =<String,dynamic>{
      'id': id,
      'deviceId': deviceId,
      'name':name,
      'product':product,
      'ip': ip,
      'port':port
    };
    return map;
  }

  ProductDetail.fromMap(Map<String,dynamic> map){
    id = map['id'];
    deviceId=map['deviceId'];
    name= map['name'];
    product=map['product'];
    ip=map['ip'];
    port=map['port'];
  }
}
