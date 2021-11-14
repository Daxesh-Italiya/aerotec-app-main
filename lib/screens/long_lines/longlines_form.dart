import 'dart:developer';
import 'dart:io';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/category_model.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
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
  String? length;
  String? category;
  String? lgsize;
  String partNumber = '';
  String? safeWorkingLoad;
  String serialNumber = '';
  String? timeBetweenOverhauls;
  String? type;
  String imagePath = '';
  ValueNotifier<List<Widget>> reorderableDetailsItems = ValueNotifier([]);
  ValueNotifier<List<Widget>> reorderableMaintenanceItems = ValueNotifier([]);
  final otherDataVisible = ValueNotifier<bool>(false);
  Timestamp inspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp nextInspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp datePurchased = Timestamp.fromDate(new DateTime.now());
  Timestamp datePutIntoService = Timestamp.fromDate(new DateTime.now());
  List<String> longLineTypes = [];
  List<String> longLineCategory = [];
  List<String> longLineSize = [];
  List<String> longLineLengths = [];
  List<String> safeWorkingLoadItems = [];
  List<String> timeBetweenOverhaulsItems = [];
  List<CategoryModel> categoryModels = [];
  final ValueNotifier<CategoryModel?> currentCategory = ValueNotifier(null);

  /***Form Properties */
  File? _image;
  bool photoUploaded = false;
  final ImagePicker _picker = ImagePicker();
  late LongLinesProvider longLinesProvider;
  late CategoriesProvider categoriesProvider;
  late String imageUrl;

  void initState() {
    super.initState();
    longLinesProvider = Provider.of<LongLinesProvider>(context, listen: false);
    categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
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
    var sizeIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('size')));
    sizeIndex.toString().logString('size');

    var lengthIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('length')));
    lengthIndex.toString().logString('length');

    var typeIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('type')));
    typeIndex.toString().logString('type');

    var swlIndex = reorderableDetailsItems.value.indexOf(reorderableDetailsItems
        .value
        .firstWhere((element) => element.key == ValueKey('swl')));
    swlIndex.toString().logString('swl');

    var slNoIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('slNo')));
    slNoIndex.toString().logString('serial no.');

    var nameIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('name')));
    nameIndex.toString().logString('name');

    var partNoIndex = reorderableDetailsItems.value.indexOf(
        reorderableDetailsItems.value
            .firstWhere((element) => element.key == ValueKey('partNo')));
    partNoIndex.toString().logString('part no.');

    var datePutIntoServiceIndex = reorderableMaintenanceItems.value.indexOf(
        reorderableMaintenanceItems.value.firstWhere(
            (element) => element.key == ValueKey('datePutIntoService')));
    datePutIntoServiceIndex.toString().logString('date put into service');

    var datePurchasedIndex = reorderableMaintenanceItems.value.indexOf(
        reorderableMaintenanceItems.value
            .firstWhere((element) => element.key == ValueKey('datePurchased')));
    datePurchasedIndex.toString().logString('date purchased');

    var tboIndex = reorderableMaintenanceItems.value.indexOf(
        reorderableMaintenanceItems.value
            .firstWhere((element) => element.key == ValueKey('tbo')));
    tboIndex.toString().logString('tbo');

    final longLine = {
      'name': category,
      'fields': [
        {
          'name': 'Name',
          'type': 'text',
          'options': name,
          'position': nameIndex + 1,
        },
        {
          'name': 'Serial Number',
          'type': 'text',
          'options': serialNumber,
          'position': slNoIndex + 1,
        },
        {
          'name': 'Size',
          'type': 'dropdown',
          'options': longLineSize,
          'position': sizeIndex + 1,
        },
        {
          'name': 'Safe Working Load',
          'type': 'dropdown',
          'options': safeWorkingLoadItems,
          'position': swlIndex + 1,
        },
        {
          'name': 'Time Between Overhauls',
          'type': 'dropdown',
          'options': timeBetweenOverhaulsItems,
          'position': tboIndex + 8,
        },
        {
          'name': 'Type',
          'type': 'dropdown',
          'options': longLineTypes,
          'position': typeIndex + 1,
        },
        {
          'name': 'Length',
          'type': 'dropdown',
          'options': longLineLengths,
          'position': lengthIndex + 1,
        },
        {
          'name': 'Part Number',
          'type': 'text',
          'options': partNumber,
          'position': partNoIndex + 1,
        },
        {
          'name': 'Date Put Into Service',
          'type': 'date',
          'options': datePutIntoService,
          'position': datePutIntoServiceIndex + 8,
        },
        {
          'name': 'Date Purchased',
          'type': 'date',
          'options': datePurchased,
          'position': datePurchasedIndex + 8,
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
          .collection('categories')
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

  addReorderableItems([CategoryModel? categoryModel]) {
    Field? nameField;
    Field? slNoField;
    Field? sizeField;
    Field? swlField;
    Field? tboField;
    Field? typeField;
    Field? lengthField;
    Field? partNoField;
    Field? dpisField;
    Field? dpField;
    if (categoryModel != null) {
      nameField =
          categoryModel.fields.firstWhere((element) => element.name == 'Name');
      slNoField = categoryModel.fields
          .firstWhere((element) => element.name == 'Serial Number');
      sizeField =
          categoryModel.fields.firstWhere((element) => element.name == 'Size');
      swlField = categoryModel.fields
          .firstWhere((element) => element.name == 'Safe Working Load');
      tboField = categoryModel.fields
          .firstWhere((element) => element.name == 'Time Between Overhauls');
      typeField =
          categoryModel.fields.firstWhere((element) => element.name == 'Type');
      lengthField = categoryModel.fields
          .firstWhere((element) => element.name == 'Length');
      partNoField = categoryModel.fields
          .firstWhere((element) => element.name == 'Part Number');
      dpisField = categoryModel.fields
          .firstWhere((element) => element.name == 'Date Put Into Service');
      dpField = categoryModel.fields
          .firstWhere((element) => element.name == 'Date Purchased');
    }
    reorderableDetailsItems.value = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        key: ValueKey('name'),
        child: ReorderableTextFieldWidget(
          child: TextFieldWidget(
            textCapitalization: TextCapitalization.sentences,
            obscureText: false,
            initialValue: nameField == null ? name : nameField.options,
            onChanged: (val) => setState(() => name = val),
            validator: (val) => val.isEmpty ? 'Enter a name' : null,
            labelText: 'Name *',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        key: ValueKey('slNo'),
        child: ReorderableTextFieldWidget(
          child: TextFieldWidget(
            textCapitalization: TextCapitalization.sentences,
            obscureText: false,
            initialValue: slNoField == null ? serialNumber : slNoField.options,
            labelText: 'Serial Number *',
            onChanged: (val) => setState(() => serialNumber = val),
            validator: (val) => val.isEmpty ? 'Add a serial number' : null,
          ),
        ),
      ),
      Padding(
        key: ValueKey('size'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDropDownWidget(
            key: ValueKey('size'),
            removeButton: true,
            isDraggable: true,
            labelText: 'Size *',
            items: sizeField == null ? [] : sizeField.options,
            validator: (val) => lgsize == null ? 'Add a Size' : null,
            onChanged: (val) {
              setState(() {
                lgsize = val;
                longLineSize.add(val);
              });
              FocusScope.of(context).requestFocus(FocusNode());
            }),
      ),
      Padding(
        key: ValueKey('length'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDropDownWidget(
            key: ValueKey('length'),
            removeButton: true,
            isDraggable: true,
            labelText: 'Length *',
            items: lengthField == null ? [] : lengthField.options,
            validator: (val) => length == null ? 'Add a length' : null,
            onChanged: (val) {
              setState(() {
                length = val;
                longLineLengths.add(val);
              });
              FocusScope.of(context).requestFocus(FocusNode());
            }),
      ),
      Padding(
        key: ValueKey('type'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDropDownWidget(
          key: ValueKey('type'),
          removeButton: true,
          isDraggable: true,
          labelText: 'Type *',
          items: typeField == null ? [] : typeField.options,
          validator: (val) => type == null ? 'Add/Select Type' : null,
          onChanged: (val) {
            setState(() {
              type = val;
              longLineTypes.add(val);
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        key: ValueKey('swl'),
        child: ReorderableDropDownWidget(
          key: ValueKey('swl'),
          isDraggable: true,
          labelText: 'Safe Working Load *',
          items: swlField == null ? [] : swlField.options,
          removeButton: true,
          validator: (val) =>
              safeWorkingLoad == null ? 'Add a safe working load' : null,
          onChanged: (val) {
            setState(() {
              safeWorkingLoad = val;
              safeWorkingLoadItems.add(val);
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        key: ValueKey('partNo'),
        child: ReorderableTextFieldWidget(
          child: TextFieldWidget(
            textCapitalization: TextCapitalization.sentences,
            obscureText: false,
            initialValue:
                partNoField == null ? partNumber : partNoField.options,
            labelText: 'Part Number *',
            onChanged: (val) => setState(() => partNumber = val),
            validator: (val) => val.isEmpty ? 'Add a part number' : null,
          ),
        ),
      ),
    ];
    reorderableMaintenanceItems.value = [
      Padding(
        key: ValueKey('datePutIntoService'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDateTimePickerWidget(
          child: DateTimePickerWidget(
              format: DateFormat('MM-dd-yyyy'),
              labelText: 'Date Put Into Service *',
              onChanged: (value) => setState(
                  () => datePutIntoService = Timestamp.fromDate(value)),
              validator: (val) => val == null ? 'Enter a date' : null,
              initialValue: formType == 'edit'
                  ? DateTime.fromMillisecondsSinceEpoch(
                      datePutIntoService.seconds * 1000)
                  : dpisField != null
                      ? (dpisField.options as Timestamp).toDate()
                      : null),
        ),
      ),
      Padding(
        key: ValueKey('datePurchased'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDateTimePickerWidget(
          child: DateTimePickerWidget(
              format: DateFormat('MM-dd-yyyy'),
              labelText: 'Date Purchased *',
              onChanged: (value) =>
                  setState(() => datePurchased = Timestamp.fromDate(value)),
              validator: (val) => val == null ? 'Enter a date' : null,
              initialValue: formType == 'edit'
                  ? DateTime.fromMillisecondsSinceEpoch(
                      datePurchased.seconds * 1000)
                  : dpField != null
                      ? (dpField.options as Timestamp).toDate()
                      : null),
        ),
      ),
      Padding(
        key: ValueKey('tbo'),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ReorderableDropDownWidget(
          key: ValueKey('tbo'),
          isDraggable: true,
          labelText: 'Time Between Overhauls *',
          items: tboField == null ? [] : tboField.options,
          validator: (val) =>
              timeBetweenOverhauls == null ? 'Add a time' : null,
          onChanged: (val) {
            setState(() {
              timeBetweenOverhaulsItems.add(val);
              timeBetweenOverhauls = val;
            });
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      )
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
                      log('value changed');
                      return Visibility(
                        visible: otherDataVisibleValue,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
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
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: FileImage(_image!),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 50,
                                    child: PopupMenuButton(
                                      offset: Offset(-15, 50),
                                      child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.grey,
                                              )),
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
                                            value: 0,
                                            child: Text('Take Photo')),
                                        PopupMenuItem(
                                            value: 1,
                                            child: Text('Choose Image')),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    right: 10,
                                    child: Center(
                                        child: Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                      size: 35,
                                    )),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  )),
                            ),
                            SizedBox(height: size.height * .03),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // hideOptions = true;
                                    });
                                  },
                                  child: Text('Finalize Form'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      textStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * .02),
                          ],
                        ),
                      );
                    },
                  ),
                  Consumer<CategoriesProvider>(
                    builder: (context, provider, child) {
                      final categories = provider.categoriesProvider;
                      categories.forEach((element) {
                        log(element.toJson().toString());
                      });
                      return ReorderableCatDropDownWidget(
                          key: ValueKey('cat'),
                          labelText: 'Category *',
                          items: categories != null && categories.isNotEmpty
                              ? categories
                              : [],
                          validator: (val) =>
                              category == null ? 'Add a Category' : null,
                          onChanged: (val) {
                            setState(() {
                              category = val;
                              final List<CategoryModel> filteredCats =
                                  categories
                                      .where((element) => element.name == val)
                                      .toList();
                              if (filteredCats != null &&
                                  filteredCats.isNotEmpty) {
                                currentCategory.value = filteredCats.first;
                              }
                              ;
                            });
                            otherDataVisible.value = true;
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                    },
                  ),
                  SizedBox(height: size.height * .03),
                  ValueListenableBuilder<CategoryModel?>(
                    valueListenable: currentCategory,
                    builder: (_, currentCategoryValue, child) {
                      reorderableDetailsItems.value = [];
                      addReorderableItems(currentCategoryValue);
                      return ValueListenableBuilder<bool>(
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
                                SizedBox(height: size.height * .02),
                                ValueListenableBuilder<List<Widget>>(
                                  valueListenable: reorderableDetailsItems,
                                  builder:
                                      (_, reorderableDetailsItemsValue, child) {
                                    return ReorderableListView.builder(
                                      itemBuilder: (context, index) {
                                        return reorderableDetailsItemsValue[
                                            index];
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          reorderableDetailsItemsValue.length,
                                      onReorder: (oldIndex, newIndex) {
                                        final newUpdatedIndex =
                                            newIndex > oldIndex
                                                ? newIndex - 1
                                                : newIndex;
                                        final currentItem =
                                            reorderableDetailsItems
                                                .value[oldIndex];
                                        reorderableDetailsItems.value
                                            .removeAt(oldIndex);
                                        reorderableDetailsItems.value.insert(
                                            newUpdatedIndex, currentItem);
                                      },
                                    );
                                  },
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
                                ReorderableListView.builder(
                                  itemCount:
                                      reorderableMaintenanceItems.value.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  onReorder: (oldIndex, newIndex) {
                                    final newUpdatedIndex = newIndex > oldIndex
                                        ? newIndex - 1
                                        : newIndex;
                                    log('oldindex:  and newIndex: ',
                                        name: 'index');
                                    final currentItem =
                                        reorderableMaintenanceItems
                                            .value[oldIndex];
                                    reorderableMaintenanceItems.value
                                        .removeAt(oldIndex);
                                    reorderableMaintenanceItems.value
                                        .insert(newUpdatedIndex, currentItem);
                                  },
                                  itemBuilder: (context, index) {
                                    return reorderableMaintenanceItems
                                        .value[index];
                                  },
                                ),
                              ],
                            ),
                          );
                        },
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
                                var check = reorderableDetailsItems.value
                                    .firstWhere((element) =>
                                        element.key == ValueKey('size'));
                                var index = reorderableDetailsItems.value
                                    .indexOf(check);
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
