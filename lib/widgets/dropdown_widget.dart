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
    if (!_addMode)
      return Row(
        children: [
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
              border: Border.all(color: Color(0xFFB6B6B6),)),
          child: Icon(
            icon,
            size: 26,
            color: Color(0xFF6D6D6D),
          )),
    );
  }
}
