import 'package:aerotec_flutter_app/widgets/dropdown_widget.dart';
import 'package:aerotec_flutter_app/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdditionalFieldDialog extends StatefulWidget {
  final Function callback;

  const AdditionalFieldDialog({ @required required this.callback });

  @override
  _AdditionalFieldDialogState createState() => _AdditionalFieldDialogState();
}

class _AdditionalFieldDialogState extends State<AdditionalFieldDialog> {

  //additional fields
  String fieldTitle = "";
  String fieldType = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
      child: Container(
        height: 320,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Text("Additional Field",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextFieldWidget(
                textCapitalization: TextCapitalization.sentences,
                obscureText: false,
                //autofocus: true,
                initialValue: "",
                onChanged: (val) => setState(() => fieldTitle = val),
                validator: (val) => val.isEmpty ? 'Enter Field Title' : null,
                labelText: 'Title *',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ReorderableDropDownWidget(
                showAddButton: false,
                labelText: 'Field Type *',
                items: ["Text", "Dropdown", "Date"],
                validator: (val) => null,
                setMenu: (value) {
                  // setMenu(value);
                },
                onNew: (val) {
                  //widget.field.options = val;
                  //widget.field.options.add(val);
                },
                onChanged: (val) {
                  setState(() { fieldType = val; });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                selected: fieldType,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ElevatedButton(
                child: Text('Add Field to Form'),
                onPressed: () {
                  if (fieldTitle.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please add field title",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                    return;

                  } else if (fieldType.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please add field type",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                    return;
                  }

                  widget.callback(fieldTitle, fieldType);
                  Navigator.pop(context);
                }
              )
            )
          ],
        ),
      ),
    );
  }
}