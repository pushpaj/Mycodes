
class ElementDetail{
  int element_id;
  int element_index;
  String element_name;
  
 

  ElementDetail(this.element_id,this.element_index,this.element_name);

  Map<String,dynamic> toMap(){
    var map =<String,dynamic>{
      'element_id':element_id,
      'element_index':element_index,
      'element_name':element_name,
    };
    return map;
  }

  ElementDetail.fromMap(Map<String,dynamic> map){
    element_id = map['element_id'];
    element_index= map['element_index'];
    element_name= map['element_name'];
  }
}
