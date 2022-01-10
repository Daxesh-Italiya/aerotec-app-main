import 'package:aerotec_flutter_app/models/category_model.dart';
import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:aerotec_flutter_app/widgets/datetimepicker_widget.dart';
import 'package:aerotec_flutter_app/widgets/dropdown_widget.dart';
import 'package:aerotec_flutter_app/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomFormWidget extends StatefulWidget {
  final Key key;

  final Field field;
  final bool isFirst;
  final bool isModifyMode;
  final bool enable;

  final VoidCallback onMoveUp;
  final VoidCallback onRemove;
  final VoidCallback onOptional;

  CustomFormWidget({
    required this.key,
    required this.field,
    required this.isFirst,
    required this.isModifyMode,
    required this.onMoveUp,
    required this.onRemove,
    required this.enable,
    required this.onOptional,
  });

  @override
  State<CustomFormWidget> createState() => _CustomFormWidgetState();
}

class _CustomFormWidgetState extends State<CustomFormWidget> {
  bool showMenu = true;

  setMenu(value) {
    setState(() => showMenu = value);
  }

  Widget child() {
    // Text Form Field ----------------------------------------------------------/

    if (widget.field.type == "text") {
      return TextFieldWidget(
        textCapitalization: TextCapitalization.sentences,
        obscureText: false,
        autofocus: false,
        enable: widget.enable,
        initialValue: widget.field.value ?? "",
        onChanged: (val) => setState(() => widget.field.value = val),
        validator: (val) {
          if (widget.field.isOptional ?? false) return null;
          if (widget.isModifyMode) {
            return null;
          } else {
            return val.isEmpty ? 'Enter a ${widget.field.label}' : null;
          }
        },
        labelText: (widget.field.isOptional ?? false)
            ? '${widget.field.label}'
            : '${widget.field.label} *',
      );

      // Dropdown Form Field ----------------------------------------------------------/

    } else if (widget.field.type == "dropdown") {
      return ReorderableDropDownWidget(
        showAddButton: widget.isModifyMode,
        labelText: (widget.field.isOptional ?? false)
            ? '${widget.field.label}'
            : '${widget.field.label} *',
        items: widget.field.options.isEmpty ? [] : widget.field.options,
        validator: (val) {
          if (widget.field.isOptional ?? false) return null;
          if (widget.isModifyMode) {
            if (widget.field.options.isEmpty) {
              return '${widget.field.label} doesn\'t have any options';
            } else {
              return null;
            }
          } else {
            return val == null ? 'Add a ${widget.field.label}' : null;
          }
        },
        setMenu: (value) {
          setMenu(value);
        },
        onNew: (val) {
          //widget.field.options = val;
          widget.field.options.add(val);
        },
        onChanged: (val) {
          if (widget.isModifyMode) setState(() => widget.field.options = val);
          if (!widget.isModifyMode) setState(() => widget.field.value = val);
          FocusScope.of(context).requestFocus(FocusNode());
        },
        selected: widget.field.value,
      );

      // Date Form Field ----------------------------------------------------------/

    } else if (widget.field.type == "date") {
      return DateTimePickerWidget(
        format: DateFormat('MM-dd-yyyy'),
        labelText: (widget.field.isOptional ?? false)
            ? '${widget.field.label}'
            : '${widget.field.label} *',
        enable: widget.enable,
        onChanged: (value) =>
            setState(() => widget.field.date = value), //Timestamp.fromDate(value)),
        validator: (val) {
          if (widget.field.isOptional ?? false) return null;
          if (widget.isModifyMode) {
            return null;
          } else {
            return val == null ? 'Enter a date' : null;
          }
        },
        initialValue: widget.field.date != null
            ? (widget.field.date) // as Timestamp).toDate()
            : null,
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //key: widget.key,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: child(),
          ),
        ),
        if (showMenu &&
            widget.isModifyMode &&
            widget.field.mainType != 'maintenance' &&
            (widget.field.name!.toLowerCase() != 'name' &&
                widget.field.name!.toLowerCase() != 'part_number' &&
                widget.field.name!.toLowerCase() != 'serial_numer'))
          PopupMenuButton(
            onSelected: (value) {
              if (value == 1) {
                widget.onMoveUp();
              } else if (value == 2) {
                widget.onRemove();
              } else if (value == 3) {
                widget.onOptional();
              }
            },
            itemBuilder: (context) => [
              if (!widget.isFirst)
                PopupMenuItem(
                  child: Text("Move Up"),
                  value: 1,
                ),
              PopupMenuItem(
                child: Text("Remove"),
                value: 2,
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      widget.field.isOptional ?? false
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: widget.field.isOptional ?? false ? Colors.green : null,
                    ),
                    SizedBox(width: 5.0),
                    Text("Optional"),
                  ],
                ),
                value: 3,
              )
            ],
          )
      ],
    );
  }
}
