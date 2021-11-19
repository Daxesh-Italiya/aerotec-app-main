import 'dart:math';

import 'package:aerotec_flutter_app/models/longlines/category_model.dart';
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

class CustomDropDownFormWidget extends StatefulWidget {
  final List<String> items;
  final String value;
  final onChanged;
  final validator;
  final String labelText;
  final bool removeButton;
  final bool? isDraggable;
  final Key key;

  CustomDropDownFormWidget(
      {required this.items,
      required this.value,
      required this.onChanged,
      required this.labelText,
      required this.validator,
      required this.key,
      this.isDraggable = false,
      this.removeButton = false});

  @override
  State<CustomDropDownFormWidget> createState() =>
      _CustomDropDownFormWidgetState();
}

class _CustomDropDownFormWidgetState extends State<CustomDropDownFormWidget>
    with AutomaticKeepAliveClientMixin {
  final List<String> _items = [];

  bool _addMode = false;

  String value = '';

  @override
  Widget build(BuildContext context) {
    if (!_addMode)
      return Row(
        children: [
          if (widget.isDraggable!)
            Icon(
              Icons.drag_indicator,
              size: 27,
              color: Colors.grey,
            ),
          Expanded(
            child: DropdownButtonFormField(
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
                  return (widget.items + _items).map((String item) {
                    return Text(item);
                  }).toList();
                },
                items: (widget.items + _items).map(
                  (String item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  },
                ).toList(),
                value: widget.value,
                onChanged: widget.onChanged),
          ),
          _RoundIconButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                _addMode = !_addMode;
              });
            },
          ),
          if (widget.removeButton)
            _RoundIconButton(
              icon: Icons.remove,
              onTap: () {
                if (_items.isNotEmpty)
                  setState(() {
                    _items.remove(widget.value);
                    widget.onChanged(widget.items[0]);
                  });
              },
            )
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
              onChanged: (val) => setState(() => value = val),
              validator: (val) =>
                  value == '' ? 'Add ${widget.labelText}' : null,
              labelText: 'Add ${widget.labelText}',
            ),
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (value.isNotEmpty)
                setState(() {
                  // _items.add(value);
                  widget.onChanged(value);
                  value = '';

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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
          )),
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

  ReorderableDropDownWidget(
      {required this.items,
      required this.onChanged,
      required this.onNew,
      required this.labelText,
      required this.selected,
      required this.validator,
      required this.showAddButton});

  @override
  State<ReorderableDropDownWidget> createState() =>
      _ReorderableDropDownWidgetState();
}

class _ReorderableDropDownWidgetState extends State<ReorderableDropDownWidget> {
  List<dynamic> get lists => widget.items;
  bool _addMode = false;

  //final categoryNotifier = ValueNotifier<String?>(null);
  String value = '';
  int selected = -1;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.selected != null) {
      selected = lists.indexWhere((element) => element == widget.selected!);
    }
    super.initState();
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
                  hint: Text('- select or add new -'),
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
                  items: List.generate(
                      lists.length,
                      (index) => DropdownMenuItem(
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
          if (widget.showAddButton)
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
              onChanged: (val) => setState(() => value = val),
              validator: (val) =>
                  value == "" ? 'Add ${widget.labelText}' : null,
              labelText: 'Add ${widget.labelText}',
            ),
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (value.isNotEmpty)
                setState(() {
                  if (widget.onNew != null) {
                    widget.onNew(value);
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

class ReorderableCatDropDownWidget extends StatefulWidget {
  final List<CategoryModel> items;
  Function(CategoryModel) onChanged;
  //CategoryBuilder onChanged;
  //var onNew;
  Function(String) onNew;
  final validator;
  final String labelText;
  final bool removeButton;
  final bool? isDraggable;
  final String? selected;
  //final Key key;

  ReorderableCatDropDownWidget(
      {required this.items,
      required this.onChanged,
      required this.onNew,
      required this.labelText,
      required this.validator,
      //required this.key,
      this.isDraggable = false,
      this.removeButton = false,
      this.selected});

  @override
  State<ReorderableCatDropDownWidget> createState() =>
      _ReorderableCatDropDownWidgetState();
}

class _ReorderableCatDropDownWidgetState
    extends State<ReorderableCatDropDownWidget> {
  bool _addMode = false;
  int selectedCat = -1;

  List<CategoryModel> get lists => widget.items;

  String cat = "";

  @override
  void initState() {
    // TODO: implement initState

    if (widget.selected != null) {
      selectedCat =
          lists.indexWhere((element) => element.id == widget.selected!);
      //widget.onChanged(widget.selected);

      print("vishwa selected index - ${selectedCat}");
    } else {
      print("vishwa selected index not found");
    }
    super.initState();
  }

  @override
  void didUpdateWidget(ReorderableCatDropDownWidget oldWidget) {
    if (widget.selected != null) {
      setState(() {
        this.selectedCat =
            lists.indexWhere((element) => element.id == widget.selected!);
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
                  hint: Text('- select or add new -'),
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
                          )),
                  value: selectedCat == -1 ? null : selectedCat,
                  onChanged: (val) {
                    setState(() {
                      selectedCat = val!; //as String?;
                      widget.onChanged(lists[val]);
                    });
                  }),
            ),
          ),
          _RoundIconButton(
            icon: Icons.add,
            onTap: () {
              setState(() {
                _addMode = !_addMode;
              });
            },
          ),
          /*if (widget.removeButton)
            _RoundIconButton(
              icon: Icons.remove,
              onTap: () {
                if (_items.isNotEmpty)
                  setState(() {
                    // _items.remove(widget.value);
                    widget.onChanged(widget.items[0]);
                  });
              },
            )*/
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
