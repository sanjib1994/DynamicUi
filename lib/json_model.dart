class ParseModel{

  dynamic label;
  dynamic type;
  dynamic value;
  dynamic placeholder;
  List<Options>? list;


  ParseModel({this.type,this.list,this.label,this.placeholder,this.value});

  ParseModel.fromJson(Map<String, dynamic> json) {

    type = json["type"];
    label = json["label"];

    if(json.containsKey("placeholder")){
      placeholder = json["placeholder"];
    }
    if(json["value"] is String){
      value = json["value"];
    }else{
      value = (json['value'] as List)
          .map((json) => json.toString())
          .toList();
    }

    if(json.containsKey("options")){
      list = (json['options'] as List)
          .map((json) => Options.fromJson(json))
          .toList();
    }

  }


}

class Options{

  dynamic key;
  dynamic checked;
  dynamic value;

  Options({this.key,this.checked,this.value});

  Options.fromJson(Map<String, dynamic> json) {

    key = json["key"].toString();
    if(json.containsKey("checked")){
      checked = json["checked"];
    }
    value = json["value"];
  }

}

