import 'dart:developer';
import 'dart:io';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LongLinesForm extends StatefulWidget {
  final LongLinesModel? longline;
  final String formType;

  const LongLinesForm(
      {required this.longline, @required required this.formType});

  _LongLinesFormState createState() => _LongLinesFormState();
}

class _LongLinesFormState extends State<LongLinesForm> {
  final _formKey = GlobalKey<FormState>();
  late String formType;

  /***Form Properties */
  String id = '';
  String name = '';
  String length = longLineLengths[0];
  String? category;
  String lgsize = longLineSize[0];
  String partNumber = '';
  String safeWorkingLoad = safeWorkingLoadItems[0];
  String serialNumber = '';
  String timeBetweenOverhauls = timeBetweenOverhaulsItems[0];
  String type = longLineTypes[0];
  String imagePath = '';
  List<Widget> reorderableItems = [];
  final otherDataVisible = ValueNotifier<bool>(false);
  Timestamp inspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp nextInspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp datePurchased = Timestamp.fromDate(new DateTime.now());
  Timestamp datePutIntoService = Timestamp.fromDate(new DateTime.now());

  /***Form Properties */
  File? _image;
  bool photoUploaded = false;
  final ImagePicker _picker = ImagePicker();
  late LongLinesProvider longLinesProvider;
  late String imageUrl;

  void initState() {
    super.initState();
    longLinesProvider = Provider.of<LongLinesProvider>(context, listen: false);
    formType = widget.formType;
    if (formType == 'edit') populateForm();
    addReorderableItems();
  }

  void populateForm() {
    id = widget.longline!.id;
    name = widget.longline!.name;
    type = widget.longline!.type;
    length = widget.longline!.length;
    imagePath = widget.longline!.imagePath;
    partNumber = widget.longline!.partNumber;
    serialNumber = widget.longline!.serialNumber;
    datePurchased = widget.longline!.datePurchased;
    inspectionDate = widget.longline!.inspectionDate;
    safeWorkingLoad = widget.longline!.safeWorkingLoad;
    nextInspectionDate = widget.longline!.nextInspectionDate;
    datePutIntoService = widget.longline!.datePutIntoService;
    timeBetweenOverhauls = widget.longline!.timeBetweenOverhauls;
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    print(inspect(pickedFile?.path));
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        photoUploaded = true;
      } else {
        print('No Image Selected');
      }
    });
  }

  void openCamera() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CameraCamera(
              onFile: (File file) {
                print(inspect(file));
                Navigator.pop(context);
                setState(() {
                  if (file.path.isNotEmpty) {
                    _image = file;
                    photoUploaded = true;
                  } else {
                    print('No Picture Taken!');
                  }
                });
              },
            )));
  }

  submitForm() {
    var sizeIndex = reorderableItems.indexOf(reorderableItems
        .firstWhere((element) => element.key == ValueKey('size')));
    var lengthIndex = reorderableItems.indexOf(reorderableItems
        .firstWhere((element) => element.key == ValueKey('length')));
    var typeIndex = reorderableItems.indexOf(reorderableItems
        .firstWhere((element) => element.key == ValueKey('type')));
    var swlIndex = reorderableItems.indexOf(reorderableItems
        .firstWhere((element) => element.key == ValueKey('swl')));
    final longLine = {
      'name': category,
      'fields': [
        {
          'name': 'Name',
          'type': 'text',
          'options': name,
          'position': 1,
        },
        {
          'name': 'Serial Number',
          'type': 'text',
          'options': serialNumber,
          'position': 2,
        },
        {
          'name': 'Date Put Into Service',
          'type': 'date',
          'options': datePutIntoService,
          'position': 8,
        },
        {
          'name': 'Date Purchased',
          'type': 'date',
          'options': datePurchased,
          'position': 9,
        },
        {
          'name': 'Part Number',
          'type': 'text',
          'options': partNumber,
          'position': 7,
        },
        {
          'name': 'Size',
          'type': 'dropdown',
          'options': longLineSize.sublist(1),
          'position': sizeIndex + 3,
        },
        {
          'name': 'Safe Working Load',
          'type': 'dropdown',
          'options': safeWorkingLoadItems.sublist(1),
          'position': swlIndex + 3,
        },
        {
          'name': 'Time Between Overhauls',
          'type': 'dropdown',
          'options': timeBetweenOverhaulsItems,
          'position': 10,
        },
        {
          'name': 'Type',
          'type': 'dropdown',
          'options': longLineTypes.sublist(1),
          'position': typeIndex + 3,
        },
        {
          'name': 'Length',
          'type': 'dropdown',
          'options': longLineLengths.sublist(1),
          'position': lengthIndex + 3,
        },
        // {
        //   'name': 'Inspection Date',
        //   'type': 'date',
        //   'options': inspectionDate,
        //   'position': 1,
        // },
        // {
        //   'nextInspectionDate': nextInspectionDate,
        //   'name': 'name',
        //   'type': 'text',
        //   'options': name,
        //   'position': 1,
        // },

        // {
        //   'imagePath': imagePath,
        //   'name': 'name',
        //   'type': 'text',
        //   'options': name,
        //   'position': 1,
        // },
      ]
    };

    try {
      FirebaseFirestore.instance
          .collection('Categories')
          .add(longLine)
          .then((_) {
        Navigator.of(context).pop();
      });
    } catch (e) {
      log(e.toString());
    }

    // LongLinesModel longline = LongLinesModel(
    //   id: id,
    //   name: name,
    //   length: length,
    //   inspectionDate: inspectionDate,
    //   nextInspectionDate: nextInspectionDate,
    //   partNumber: partNumber,
    //   safeWorkingLoad: safeWorkingLoad,
    //   serialNumber: serialNumber,
    //   timeBetweenOverhauls: timeBetweenOverhauls,
    //   type: type,
    //   imagePath: imagePath,
    //   datePurchased: datePurchased,
    //   datePutIntoService: datePutIntoService,
    // );
    // if (formType == 'edit') longLinesProvider.updateListing(longline, _image);
    // if (formType == 'new') longLinesProvider.createNewListing(longline, _image);
    // Navigator.pop(context);
  }

  addReorderableItems() {
    reorderableItems = [
      Padding(
        key: ValueKey('size'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomDropDownFormWidget(
            key: ValueKey('size'),
            removeButton: true,
            isDraggable: true,
            labelText: 'Size *',
            items: longLineSize,
            value: lgsize,
            validator: (val) => val == '- select -' ? 'Add a Size' : null,
            onChanged: (val) {
              setState(() {
                longLineSize.add(val);
                lgsize = val;
              });
              FocusScope.of(context).requestFocus(FocusNode());
            }),
      ),
      Padding(
        key: ValueKey('length'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomDropDownFormWidget(
            key: ValueKey('length'),
            removeButton: true,
            isDraggable: true,
            labelText: 'Length *',
            items: longLineLengths,
            value: length,
            validator: (val) => val == '- select -' ? 'Add a length' : null,
            onChanged: (val) {
              setState(() {
                longLineLengths.add(val);
                length = val;
              });
              FocusScope.of(context).requestFocus(FocusNode());
            }),
      ),
      Padding(
        key: ValueKey('type'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomDropDownFormWidget(
          key: ValueKey('type'),
          removeButton: true,
          isDraggable: true,
          labelText: 'Type *',
          items: longLineTypes,
          value: type,
          validator: (val) => val == '- select -' ? 'Add a type' : null,
          onChanged: (val) {
            setState(() {
              longLineTypes.add(val);
              type = val;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        key: ValueKey('swl'),
        child: CustomDropDownFormWidget(
          key: ValueKey('swl'),
          isDraggable: true,
          labelText: 'Safe Working Load *',
          items: safeWorkingLoadItems,
          value: safeWorkingLoad,
          validator: (val) =>
              val == '- select -' ? 'Add a safe working load' : null,
          onChanged: (val) {
            setState(() {
              safeWorkingLoadItems.add(val);
              safeWorkingLoad = val;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    LongLinesProvider longLinesProvider =
        Provider.of<LongLinesProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    if (imagePath.isNotEmpty) {
      List<String> filename = this.widget.longline!.imagePath.split('.');
      imageUrl = filename[0];
    }

    return Scaffold(
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: AppTheme.primary,
            title: Text(
              formType == 'edit' ? 'EDIT LONGLINE' : 'CREATE NEW LONGLINE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            )),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: otherDataVisible,
                    builder: (_, otherDataVisibleValue, child) {
                      return Visibility(
                        visible: otherDataVisibleValue,
                        child: Container(
                          width: double.infinity,
                          height: size.height * .3,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Center(
                                child: _image == null
                                    ? imagePath == ''
                                        ? Icon(
                                            Icons.add_a_photo,
                                            size: 100,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/longlines%2F${imageUrl.toString()}_800x800.jpeg?alt=media'),
                                                  fit: BoxFit.cover),
                                            ),
                                          )
                                    : Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(_image!),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: PopupMenuButton(
                                  offset: Offset(-15, 50),
                                  child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Icon(Icons.photo_camera))),
                                  onSelected: (val) {
                                    if (val == 0) {
                                      openCamera();
                                    } else {
                                      getImage();
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                        value: 0, child: Text('Take Photo')),
                                    PopupMenuItem(
                                        value: 1, child: Text('Choose Image')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: size.height * .03),
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: size.height * .02),
                  CustomDropDownCatFormWidget(
                      key: ValueKey('cat'),
                      labelText: 'Category *',
                      items: longLineCategory,
                      validator: (val) =>
                          val == '- select -' ? 'Add a Category' : null,
                      onChanged: (val) {
                        setState(() {
                          category = val;
                          log(val.toString());
                        });

                        otherDataVisible.value = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),
                  SizedBox(height: size.height * .04),
                  ValueListenableBuilder<bool>(
                    valueListenable: otherDataVisible,
                    builder: (_, value, child) {
                      return Visibility(
                        visible: value,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: size.height * .03),
                            TextFieldWidget(
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              initialValue: name,
                              onChanged: (val) => setState(() => name = val),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter a name' : null,
                              labelText: 'Name *',
                            ),
                            SizedBox(height: screenHeight * .02),
                            TextFieldWidget(
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              initialValue: serialNumber,
                              labelText: 'Serial Number *',
                              onChanged: (val) =>
                                  setState(() => serialNumber = val),
                              validator: (val) =>
                                  val.isEmpty ? 'Add a serial number' : null,
                            ),
                            SizedBox(height: size.height * .02),
                            ReorderableListView.builder(
                              itemBuilder: (context, index) {
                                return reorderableItems[index];
                              },
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reorderableItems.length,
                              onReorder: (oldIndex, newIndex) {
                                final newUpdatedIndex = newIndex > oldIndex
                                    ? newIndex - 1
                                    : newIndex;
                                log('oldindex:  and newIndex: ', name: 'index');
                                final currentItem = reorderableItems[oldIndex];
                                reorderableItems.removeAt(oldIndex);
                                reorderableItems.insert(
                                    newUpdatedIndex, currentItem);
                              },
                            ),
                            SizedBox(height: size.height * .02),
                            TextFieldWidget(
                              textCapitalization: TextCapitalization.sentences,
                              obscureText: false,
                              initialValue: partNumber,
                              labelText: 'Part Number *',
                              onChanged: (val) =>
                                  setState(() => partNumber = val),
                              validator: (val) =>
                                  val.isEmpty ? 'Add a part number' : null,
                            ),
                            SizedBox(height: size.height * .04),
                            Text(
                              'Maintenance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: size.height * .03),
                            DateTimePickerWidget(
                                format: DateFormat('MM-dd-yyyy'),
                                labelText: 'Date Put Into Service *',
                                onChanged: (value) => setState(() =>
                                    datePutIntoService =
                                        Timestamp.fromDate(value)),
                                validator: (val) =>
                                    val == null ? 'Enter a date' : null,
                                initialValue: formType == 'edit'
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        datePutIntoService.seconds * 1000)
                                    : null),
                            SizedBox(height: size.height * .03),
                            DateTimePickerWidget(
                                format: DateFormat('MM-dd-yyyy'),
                                labelText: 'Date Purchased *',
                                onChanged: (value) => setState(() =>
                                    datePurchased = Timestamp.fromDate(value)),
                                validator: (val) =>
                                    val == null ? 'Enter a date' : null,
                                initialValue: formType == 'edit'
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                        datePurchased.seconds * 1000)
                                    : null),
                            SizedBox(height: size.height * .03),
                            CustomDropDownFormWidget(
                              key: ValueKey('tbo'),
                              labelText: 'Time Between Overhauls *',
                              items: timeBetweenOverhaulsItems,
                              value: timeBetweenOverhauls,
                              validator: (val) =>
                                  val == '- select -' ? 'Add a time' : null,
                              onChanged: (val) {
                                setState(() {
                                  timeBetweenOverhaulsItems.add(val);
                                  timeBetweenOverhauls = val;
                                });
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                            ),
                            SizedBox(height: size.height * .02),
                          ],
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: otherDataVisible,
                    builder: (_, otherDataVisibleValue, child) {
                      return Visibility(
                        visible: otherDataVisibleValue,
                        child: Builder(builder: (BuildContext context) {
                          if (longLinesProvider.isLoading)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          return ElevatedButton(
                              child: Text('Submit'),
                              onPressed: () {
                                var check = reorderableItems.firstWhere(
                                    (element) =>
                                        element.key == ValueKey('size'));
                                var index = reorderableItems.indexOf(check);
                                log(index.toString());
                                if (_formKey.currentState!.validate()) {
                                  submitForm();
                                }
                              });
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
