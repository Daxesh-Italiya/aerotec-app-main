import 'dart:math';

import 'package:aerotec_flutter_app/models/category_model.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DropDownFormWidget extends StatelessWidget {
  final List<String> items;
  final String value;
  final onChanged;
  final validator;
  final String labelText;

  DropDownFormWidget(
      {required this.items,
      required this.value,
      required this.onChanged,
      required this.labelText,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
              width: 2.0,
            ),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
        isExpanded: true,
        selectedItemBuilder: (context) {
          return items.map((String item) {
            return Text(item);
          }).toList();
        },
        items: items.map(
          (String item) {
            return DropdownMenuItem(
              child: Text(item),
              value: item,
            );
          },
        ).toList(),
        value: value,
        onChanged: onChanged);
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    Key? key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFFB6B6B6),
            )),
        child: Icon(
          icon,
          size: 26,
          color: Color(0xFF6D6D6D),
        )
      ),
    );
  }
}

//For Category Specific

class ReorderableDropDownWidget extends StatefulWidget {
  final List<dynamic> items;
  final String? selected;
  final onChanged;
  final onNew;
  final validator;
  final String labelText;
  final bool showAddButton;
  final Function setMenu;

  ReorderableDropDownWidget({
    required this.items,
    required this.onChanged,
    required this.onNew,
    required this.labelText,
    required this.selected,
    required this.validator,
    required this.showAddButton,
    required this.setMenu,
  });

  @override
  State<ReorderableDropDownWidget> createState() => _ReorderableDropDownWidgetState();
}

class _ReorderableDropDownWidgetState extends State<ReorderableDropDownWidget> {
  List<dynamic> get lists => widget.items;
  bool _addMode = false;

  //final categoryNotifier = ValueNotifier<String?>(null);
  String value = '';
  int selected = -1;

  FocusNode focusNode = FocusNode();

  Widget textField = SizedBox();

  @override
  void initState() {
    if (widget.selected != null) {
      selected = lists.indexWhere((element) => element == widget.selected!);
    }

    textField = TextFieldWidget(
      textCapitalization: TextCapitalization.sentences,
      obscureText: false,
      initialValue: '',
      focusNode: focusNode,
      onChanged: (val) => setState(() => value = val),
      validator: (val) => value == "" ? 'Add ${widget.labelText}' : null,
      labelText: 'Add ${widget.labelText}',
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _onButtonClose() {
    debugPrint('Close text field!!');
    setState(() {
      _addMode = false;
      widget.setMenu(true);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_addMode == true && widget.showAddButton == false) {
      _addMode = false;
    }

    // Checkbox and Cancel circular buttons -------------------------------------------------------/

    if (widget.showAddButton && _addMode) {
      return Row(
        children: [
          Expanded(
            child: textField,
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (value.isNotEmpty) setState(() {
                if (widget.onNew != null) {
                  widget.onNew(value);
                }
                _addMode = false;
                widget.setMenu(true);
              });
            },
          ),
          Transform.rotate(
            angle: pi / 4,
            child: _RoundIconButton(
              icon: Icons.add,
              onTap: _onButtonClose,
            ),
          ),
        ],
      );

    } else if (widget.showAddButton) {

      return Row(
        children: [
          Expanded(
            child: Container(
              //height: 55,
              child: DropdownButtonFormField<int>(
                hint: Text('Add dropdown options'),
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                isExpanded: true,
                selectedItemBuilder: (context) {
                  return lists.map((dynamic item) {
                    return Text("${item}");
                  }).toList();
                },
                items: List.generate(lists.length, (index) => DropdownMenuItem(
                  child: Text(lists[index]),
                  value: index,
                )),
                value: selected == -1 ? null : selected,
                onChanged: (val) {
                  setState(() {
                    selected = val!; //as String?;
                    widget.onChanged(lists[val]);
                  });
                }
              ),
            ),
          ),
          _RoundIconButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                _addMode = true;
                widget.setMenu(false);
              });

              Future.delayed(Duration(milliseconds: 100)).then((value) {
                if (_addMode) {
                  FocusScope.of(context).requestFocus(focusNode);
                } else {
                  focusNode.unfocus();
                }
              });
            },
          ),
        ],
      );

    } else if (widget.showAddButton == false) {

      return Row(
        children: [
          Expanded(
            child: Container(
              //height: 55,
              child: DropdownButtonFormField<int>(
                hint: Text('- Select -'),
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                isExpanded: true,
                selectedItemBuilder: (context) {
                  return lists.map((dynamic item) {
                    return Text("${item}");
                  }).toList();
                },
                items: List.generate(lists.length,(index) => DropdownMenuItem(
                  child: Text(lists[index]),
                  value: index,
                )),
                value: selected == -1 ? null : selected,
                onChanged: (val) {
                  setState(() {
                    selected = val!; //as String?;
                    widget.onChanged(lists[val]);
                  });
                }),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: textField,
          ),
        ],
      );
    }
  }
}

class CategoryDropDownWidget extends StatefulWidget {
  final List<CategoryModel> items;
  final Function(CategoryModel) onChanged;
  //CategoryBuilder onChanged;
  //var onNew;
  final Function(String) onNew;
  final validator;
  final bool isModifyMode;
  final String labelText;
  final bool removeButton;
  final bool? isDraggable;
  final String? selected;
  //final Key key;

  CategoryDropDownWidget({
    required this.items,
    required this.onChanged,
    required this.onNew,
    required this.labelText,
    required this.validator,
    required this.isModifyMode,
    //required this.key,
    this.isDraggable = false,
    this.removeButton = false,
    this.selected,
  });

  @override
  State<CategoryDropDownWidget> createState() => _CategoryDropDownWidgetState();
}

class _CategoryDropDownWidgetState extends State<CategoryDropDownWidget> {
  bool _addMode = false;
  int selectedCat = -1;

  List<CategoryModel> get lists => widget.items;

  String cat = "";

  @override
  void initState() {
    if (widget.selected != null) {
      selectedCat = lists.indexWhere((element) => element.id == widget.selected!);
    } else {
      print("selected index not found");
    }
    super.initState();
  }

  @override
  void didUpdateWidget(CategoryDropDownWidget oldWidget) {
    if (widget.selected != null) {
      setState(() {
        this.selectedCat = lists.indexWhere((element) => element.id == widget.selected!);
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_addMode)

      return Row(
        children: [
          Expanded(
            child: Container(
              //height: 55,
              child: DropdownButtonFormField<int>(
                hint: Text('- Select -'),
                validator: widget.validator,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                      width: 2.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                isExpanded: true,
                selectedItemBuilder: (context) {
                  return lists.map((CategoryModel item) {
                    return Text(item.name);
                  }).toList();
                },
                items: List.generate(
                  lists.length,
                  (index) => DropdownMenuItem(
                    child: Text(lists[index].name),
                    value: index,
                  )
                ),
                value: selectedCat == -1 ? null : selectedCat,
                onChanged: (val) {
                  setState(() {
                    selectedCat = val!; //as String?;
                    widget.onChanged(lists[val]);
                  });
                }
              ),
            ),
          ),
          if (widget.isModifyMode)
          _RoundIconButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                _addMode = !_addMode;
              });
            },
          ),
        ],
      );

    else
    
      return Row(
        children: [
          Expanded(
            child: TextFieldWidget(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              obscureText: false,
              initialValue: '',
              onChanged: (val) => setState(() => cat = val),
              validator: (val) => cat == '' ? 'Add ${widget.labelText}' : null,
              labelText: 'Add ${widget.labelText}',
            ),
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (cat.isNotEmpty)
                setState(() {
                  // _items.add(value);
                  if (widget.onNew != null) {
                    widget.onNew(cat);
                  } else {
                    //widget.onChanged(cat);
                  }
                  _addMode = !_addMode;
                });
            },
          ),
          Transform.rotate(
            angle: pi / 4,
            child: _RoundIconButton(
              icon: Icons.add,
              onTap: () {
                setState(() {
                  _addMode = !_addMode;
                });
              },
            ),
          )
        ],
      );
  }
}
