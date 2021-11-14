import 'dart:developer' as dev;
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
  final List<String> items;
  final onChanged;
  final validator;
  final String labelText;
  final bool removeButton;
  final bool? isDraggable;
  final Key key;

  ReorderableDropDownWidget(
      {required this.items,
      required this.onChanged,
      required this.labelText,
      required this.validator,
      required this.key,
      this.isDraggable = false,
      this.removeButton = false});

  @override
  State<ReorderableDropDownWidget> createState() =>
      _ReorderableDropDownWidgetState();
}

class _ReorderableDropDownWidgetState extends State<ReorderableDropDownWidget> {
  final List<String> _items = [];

  bool _addMode = false;

  final categoryNotifier = ValueNotifier<String?>(null);
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
          ValueListenableBuilder<String?>(
            valueListenable: categoryNotifier,
            builder: (_, catValue, child) {
              return Expanded(
                child: DropdownButtonFormField(
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
                    value: catValue,
                    onChanged: (val) {
                      dev.log(val.toString(), name: 'check');
                      categoryNotifier.value = val as String?;
                      widget.onChanged(val);
                    }),
              );
            },
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
                    // _items.remove(widget.value);
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
                  categoryNotifier == '' ? 'Add ${widget.labelText}' : null,
              labelText: 'Add ${widget.labelText}',
            ),
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (value.isNotEmpty)
                setState(() {
                  _items.add(value);

                  widget.onChanged(value);
                  categoryNotifier.value = value;

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
  final onChanged;
  final validator;
  final String labelText;
  final bool removeButton;
  final bool? isDraggable;
  final Key key;

  ReorderableCatDropDownWidget(
      {required this.items,
      required this.onChanged,
      required this.labelText,
      required this.validator,
      required this.key,
      this.isDraggable = false,
      this.removeButton = false});

  @override
  State<ReorderableCatDropDownWidget> createState() =>
      _ReorderableCatDropDownWidgetState();
}

class _ReorderableCatDropDownWidgetState
    extends State<ReorderableCatDropDownWidget> {
  final List<CategoryModel> _items = [];

  bool _addMode = false;

  final categoryNotifier = ValueNotifier<String?>(null);
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
          ValueListenableBuilder<String?>(
            valueListenable: categoryNotifier,
            builder: (_, catValue, child) {
              return Expanded(
                child: DropdownButtonFormField(
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
                      return (widget.items + _items).map((CategoryModel item) {
                        return Text(item.name);
                      }).toList();
                    },
                    items: (widget.items + _items).map(
                      (CategoryModel item) {
                        return DropdownMenuItem(
                          child: Text(item.name),
                          value: item.name,
                        );
                      },
                    ).toList(),
                    value: catValue,
                    onChanged: (val) {
                      categoryNotifier.value = val as String?;
                      widget.onChanged(val);
                    }),
              );
            },
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
                    // _items.remove(widget.value);
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
                  categoryNotifier == '' ? 'Add ${widget.labelText}' : null,
              labelText: 'Add ${widget.labelText}',
            ),
          ),
          _RoundIconButton(
            icon: Icons.done,
            onTap: () {
              if (value.isNotEmpty)
                setState(() {
                  _items.add(CategoryModel(fields: [], name: value, id: null));

                  widget.onChanged(value);
                  categoryNotifier.value = value;

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
