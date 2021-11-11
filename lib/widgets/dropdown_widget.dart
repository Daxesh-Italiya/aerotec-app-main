import 'dart:math';

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

  CustomDropDownFormWidget(
      {required this.items,
      required this.value,
      required this.onChanged,
      required this.labelText,
      required this.validator,
      this.removeButton = false});

  @override
  State<CustomDropDownFormWidget> createState() =>
      _CustomDropDownFormWidgetState();
}

class _CustomDropDownFormWidgetState extends State<CustomDropDownFormWidget> {
  final List<String> _items = [];

  bool _addMode = false;

  String value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_addMode)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
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
              ),
              _RoundIconButton(
                icon: Icons.add,
                onTap: () {
                  setState(() {
                    _addMode = !_addMode;
                  });
                },
              ),
              GestureDetector(
                onTapDown: (details) {
                  _showPopupMenu(details.globalPosition);
                },
                child: Icon(
                  Icons.more_vert,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        else
          Row(
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
                      _items.add(value);

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
          )
      ],
    );
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: const Text('Remove'),
          value: '1',
          onTap: () {
            if (_items.isNotEmpty)
              setState(() {
                _items.remove(widget.value);
                widget.onChanged(widget.items[0]);
              });
          },
        ),
        PopupMenuItem<String>(child: const Text('Move Up'), value: '2'),
      ],
      elevation: 8.0,
    );
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
          )),
    );
  }
}
