import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import 'HexColor.dart';
import 'color_codes.dart';
import 'json_model.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  List<ParseModel> myData = [];
  int _groupValue = -1;
  var _items;
  var selectedOptions = [] ;
  late Future myFuture;

  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 5));
    return DefaultAssetBundle.of(context).loadString("assets/demo.json");
  }

  @override
  void initState() {
    myFuture = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if(snapshot.data!=null){
                Iterable i = json.decode(snapshot.data.toString());
                myData =
                i.map((model) => ParseModel.fromJson(model)).toList();
              }
              return new ListView.builder(
                itemCount: myData == null ? 0 : myData.length,
                itemBuilder: (BuildContext context, int index) {
                  return drawWidget(myData[index]);
                },
              );
            },
            future: myFuture,
          ),
        ),
      ),
    );
  }

  Widget drawWidget(ParseModel data){

    if(data.type!.toLowerCase() == "textfield" || data.type.toString().toLowerCase() == "number_textfield"){
      return addInputTextWidget(data);
    }else if(data.type!.toLowerCase() == "date"){
      return addDateWidget(data);
    }else if(data.type!.toLowerCase() == "radio"){
      if(_groupValue== -1 && data.value!=null){
        _groupValue = int.parse(data.value);
      }

      return addRadioWidget(data);
    }else if(data.type!.toLowerCase() == "multiselect"){

      if(selectedOptions.isEmpty){
        for(String i in data.value){
          for(var j in data.list!){
            if(i == j.key){
              selectedOptions.add(j);
            }
          }
        }
      }

      _items = data.list!
          .map((animal) => MultiSelectItem<Options>(animal, animal.value.toString()))
          .toList();

      return addMultiSelect(data);
    }


    return Container();
  }

  Widget addInputTextWidget(ParseModel data) {

    TextEditingController controller = TextEditingController(text:data.value.toString());

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label.toString(),
            style: TextStyle(fontSize: 14, color: HexColor("#525252")),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: HexColor("#b9b9b9")),
                  borderRadius:
                  const BorderRadius.all(const Radius.circular(10.0)),
                  color: Colors.white),
              height: 40,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: data.type.toString() == "number_textfield"?TextInputType.numberWithOptions(
                        signed: true,
                      ):TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: data.placeholder.toString(),
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      )

    );
  }

  Widget addDateWidget(ParseModel data) {

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label.toString(),
            style: TextStyle(fontSize: 14, color: HexColor("#525252")),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: HexColor("#b9b9b9")),
                borderRadius:
                const BorderRadius.all(const Radius.circular(10.0)),
                color: Colors.white),
            height: 40,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(data.value),
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget addRadioWidget(ParseModel data) {

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.label.toString(),
              style: TextStyle(fontSize: 14, color: HexColor("#525252")),
            ),
            SizedBox(
              height: 10,
            ),
           Column(
             children: List.generate(data.list!.length, (index) {
               return Row(
                 children: [
                   Expanded(
                     child: RadioListTile<int>(
                       value: int.parse(data.list![index].key),
                       groupValue: _groupValue,
                       title: Text(data.list![index].value),
                       onChanged: (int? val){
                         setState(() {
                           _groupValue = val!;
                         });
                       },
                     ),
                   )
                 ],
               );
             }),
           )
          ],
        )
    );
  }

  Widget addMultiSelect(ParseModel data) {

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.label.toString(),
              style: TextStyle(fontSize: 14, color: HexColor("#525252")),
            ),
            SizedBox(
              height: 10,
            ),
            MultiSelectDialogField(
              items: _items,
              title: Text(data.label.toString()),
              selectedColor: Colors.blue,
              initialValue: selectedOptions,
              onConfirm: (results) {
                selectedOptions = results;
              },
            ),
          ],
        )
    );
  }
}
