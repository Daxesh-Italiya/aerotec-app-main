import 'dart:developer';
import 'dart:io';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/longlines/category_model.dart';
import 'package:aerotec_flutter_app/models/longlines/longlines_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/longlines_provider.dart';
import 'package:aerotec_flutter_app/screens/home/home.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  String imagePath = '';

  List<Field> detailsFieldItems = [];
  List<Field> maintenanceFieldItems = [];
  List<Field> othersFieldItems = [];

  List<Field> allDefaultFields = [
    Field(
        type: "text",
        options: [],
        name: 'Name',
        mainType: "details",
        position: 1),
    Field(
        options: [],
        type: "text",
        name: 'Serial Number',
        mainType: "details",
        position: 2),
    Field(
        type: "dropdown",
        name: 'Size',
        options: [],
        mainType: "details",
        position: 3),
    Field(
        type: "dropdown",
        name: 'Length',
        options: [],
        mainType: "details",
        position: 4),
    Field(
        type: "dropdown",
        name: 'Type',
        options: [],
        mainType: "details",
        position: 5),
    Field(
        type: "dropdown",
        name: 'Safe Working Load',
        options: [],
        mainType: "details",
        position: 6),
    Field(
        options: [],
        type: "text",
        name: 'Part Number',
        mainType: "details",
        position: 7),
    Field(
        options: [],
        type: "date",
        name: 'Date Put Into Service',
        mainType: "maintenance",
        position: 8),
    Field(
        options: [],
        type: "date",
        name: 'Date Purchased',
        mainType: "maintenance",
        position: 9),
    Field(
        options: [],
        type: "dropdown",
        name: 'Time Between Overhauls',
        mainType: "maintenance",
        position: 10),
  ];

  Timestamp inspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp nextInspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp datePurchased = Timestamp.fromDate(new DateTime.now());
  Timestamp datePutIntoService = Timestamp.fromDate(new DateTime.now());

  List<CategoryModel> categoryList = [];
  CategoryModel? currentCategory;
  bool isModifyMode = false;

  bool showOtherDetails = false;

  /***Form Properties */
  File? _image;
  bool photoUploaded = false;
  final ImagePicker _picker = ImagePicker();
  late LongLinesProvider longLinesProvider;
  late CategoriesProvider categoriesProvider;
  late String imageUrl;

  //additional fields
  String fieldTitle = "";
  String fieldType = "";

  void initState() {
    super.initState();
    longLinesProvider = Provider.of<LongLinesProvider>(context, listen: false);
    categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    formType = widget.formType;
    if (formType == 'edit') populateForm();
    initCategoryData();

    //FirebaseFirestore.instance.collection('categories').doc("").delete();
  }

  void populateForm() {
    imagePath = widget.longline!.imagePath;
    datePurchased = widget.longline!.datePurchased;
    inspectionDate = widget.longline!.inspectionDate;
    nextInspectionDate = widget.longline!.nextInspectionDate;
    datePutIntoService = widget.longline!.datePutIntoService;
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

  initCategoryData() {
    categoryList = categoriesProvider.categoriesProvider;
  }

  addNewCategory(String cat) async {
    print("addNewCategory start ${cat}");

    DocumentReference doc =
        await FirebaseFirestore.instance.collection('categories').add({
      'name': cat,
      'fields': List.generate(allDefaultFields.length, (index) {
        Field e = allDefaultFields[index];

        return {
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType
        };
      })
    });

    print("addNewCategory cat id ${doc.id}");

    CategoryModel categoryModel =
        CategoryModel(fields: allDefaultFields, name: cat, id: doc.id);

    Fluttertoast.showToast(
        msg: "New Category Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);

    initCategoryData();

    setState(() {
      isModifyMode = false;
      showOtherDetails = true;
      isModifyMode = true;
      //currentCategory = categoryModel;
      FocusScope.of(context).requestFocus(FocusNode());
      initItems(categoryModel);
    });
  }

  finalizeForm() {
    List<Field> fields1 =
        detailsFieldItems.where((e) => e.mainType == "details").toList();
    List<Field> fields2 = maintenanceFieldItems
        .where((e) => e.mainType == "maintenance")
        .toList();
    List<Field> fields3 =
        othersFieldItems.where((e) => e.mainType == "others").toList();

    List<Field> allFields = [...fields1, ...fields2, ...fields3];

    final longLine = {
      'name': currentCategory!.name,
      'fields': List.generate(allFields.length, (index) {
        Field e = allFields[index];
        return {
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType,
          "value": e.value
        };
      })
    };

    try {
      FirebaseFirestore.instance
          .collection('categories')
          .doc(currentCategory!.id!)
          .set(
            longLine,
          )
          .then((_) {
        categoriesProvider.notifyListeners();
        initCategoryData();
        setState(() {
          isModifyMode = false;
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  addNewField() {
    othersFieldItems.add(Field(
        name: fieldTitle,
        options: [],
        type: fieldType.toLowerCase(),
        position: 0,
        mainType: "others"));

    List<Field> allFields = [
      ...detailsFieldItems,
      ...maintenanceFieldItems,
      ...othersFieldItems
    ];

    final longLine = {
      'name': currentCategory!.name,
      'fields': List.generate(allFields.length, (index) {
        Field e = allFields[index];
        return {
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType,
          "value": e.value
        };
      })
    };

    try {
      FirebaseFirestore.instance
          .collection('categories')
          .doc(currentCategory!.id!)
          .set(longLine)
          .then((_) {
        categoriesProvider.notifyListeners();
        //initCategoryData();

        Fluttertoast.showToast(
            msg: "New Field Added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);

        setState(() {});
      });
    } catch (e) {
      log(e.toString());
    }
  }

  submitForm() {
    List<Field> allFields = [
      ...detailsFieldItems,
      ...maintenanceFieldItems,
      ...othersFieldItems
    ];

    final longLine = {
      'name': currentCategory!.name,
      'fields': List.generate(allFields.length, (index) {
        Field e = allFields[index];
        return {
          "name": e.name,
          "type": e.type,
          "options": e.options,
          "position": index + 1,
          "main_type": e.mainType,
          "value": e.value
        };
      })
    };

    try {
      Fluttertoast.showToast(
          msg: "Submit form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);

      // FirebaseFirestore.instance
      //     .collection('categories')
      //     .doc(currentCategory!.id!)
      //     .set(longLine)
      //     .then((_) {
      //   categoriesProvider.notifyListeners();
      //   initCategoryData();
      // });
    } catch (e) {
      log(e.toString());
    }
  }

  void addOtherField() {
    setState(() {
      fieldTitle = "";
      fieldType = "Text";
    });

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Additional Field",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 50),
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
                    onNew: (val) {
                      //widget.field.options = val;
                      //widget.field.options.add(val);
                    },
                    onChanged: (val) {
                      setState(() {
                        fieldType = val;
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    selected: fieldType,
                  )),
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

                        addNewField();
                        Navigator.pop(context);
                      }))
            ],
          ),
        );
      },
    );
  }

  initItems(CategoryModel categoryModel) {
    setState(() {
      currentCategory = categoryModel;
    });

    if (currentCategory!.fields.isNotEmpty) {
      detailsFieldItems.clear();
      maintenanceFieldItems.clear();
      othersFieldItems.clear();

      currentCategory!.fields.forEach((field) {
        String type = field.mainType ?? "others";

        if (type == "details") {
          detailsFieldItems.add(field);
        } else if (type == "maintenance") {
          maintenanceFieldItems.add(field);
        } else {
          othersFieldItems.add(field);
        }
      });

      print(
          "vishwa details - ${detailsFieldItems.length}, maintenance - ${maintenanceFieldItems.length}, others - ${othersFieldItems.length}");
    }
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
                  Visibility(
                    visible: showOtherDetails,
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
                                        value: 0, child: Text('Take Photo')),
                                    PopupMenuItem(
                                        value: 1, child: Text('Choose Image')),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 30,
                                right: 10,
                                child: PopupMenuButton(
                                  onSelected: (val) {
                                    if (val == 0) {
                                      setState(() {
                                        isModifyMode = true;
                                      });
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 0, child: Text('Modify Form')),
                                  ],
                                  child: Center(
                                      child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 35,
                                  )),
                                ),
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
                        if (isModifyMode)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  finalizeForm();
                                },
                                child: Text('Finalize Form'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.grey,
                                    textStyle: TextStyle(color: Colors.white)),
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
                  ),
                  Consumer<CategoriesProvider>(
                      builder: (context, provider, child) {
                    categoryList = provider.categoriesProvider;

                    return ReorderableCatDropDownWidget(
                        //key: ValueKey('cat'),
                        labelText: 'Category *',
                        selected: currentCategory != null
                            ? currentCategory!.id
                            : null,
                        items: categoryList,
                        validator: (val) =>
                            currentCategory == null ? 'Add a Category' : null,
                        onNew: (val) {
                          addNewCategory(val);
                        },
                        onChanged: (val) {
                          setState(() {
                            //currentCategory = val;
                            initItems(val);
                          });
                          showOtherDetails = true;

                          FocusScope.of(context).requestFocus(FocusNode());
                        });
                  }),
                  SizedBox(height: size.height * .04),
                  Visibility(
                    visible: showOtherDetails,
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
                        ListView.builder(
                          itemBuilder: (context, index) {
                            Field field = detailsFieldItems[index];

                            return OptionMenuWidget(
                              showMenu: isModifyMode,
                              key: ValueKey("list1_${index}"),
                              isFirst: index == 0,
                              onMoveUp: () {
                                int newIndex = index - 1;
                                int oldIndex = index;

                                final currentItem = detailsFieldItems[oldIndex];

                                detailsFieldItems.removeAt(oldIndex);
                                detailsFieldItems.insert(newIndex, currentItem);

                                setState(() {});
                              },
                              onRemove: () {
                                detailsFieldItems.removeAt(index);

                                setState(() {});
                              },
                              field: field,
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: detailsFieldItems.length,
                        ),
                        SizedBox(height: size.height * .03),
                        Text(
                          'Maintenance',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: size.height * .02),
                        ListView.builder(
                          itemCount: maintenanceFieldItems.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Field field = maintenanceFieldItems[index];

                            return OptionMenuWidget(
                              key: ValueKey("list2_${index}"),
                              isFirst: index == 0,
                              onMoveUp: () {
                                int newIndex = index - 1;
                                int oldIndex = index;

                                final currentItem =
                                    maintenanceFieldItems[oldIndex];

                                maintenanceFieldItems.removeAt(oldIndex);
                                maintenanceFieldItems.insert(
                                    newIndex, currentItem);

                                setState(() {});
                              },
                              onRemove: () {
                                maintenanceFieldItems.removeAt(index);
                                setState(() {});
                              },
                              field: field,
                              showMenu: isModifyMode,
                            );
                          },
                        ),
                        SizedBox(height: size.height * .03),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Additional Fields',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              RoundIconButton(
                                icon: Icons.add,
                                onTap: () {
                                  addOtherField();
                                },
                              ),
                            ]),
                        SizedBox(height: size.height * .02),
                        ListView.builder(
                          itemCount: othersFieldItems.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Field field = othersFieldItems[index];

                            //return Text("${field.type}");

                            return OptionMenuWidget(
                              key: ValueKey("list3_${index}"),
                              isFirst: index == 0,
                              onMoveUp: () {
                                int newIndex = index - 1;
                                int oldIndex = index;

                                final currentItem = othersFieldItems[oldIndex];

                                othersFieldItems.removeAt(oldIndex);
                                othersFieldItems.insert(newIndex, currentItem);

                                setState(() {});
                              },
                              onRemove: () {
                                othersFieldItems.removeAt(index);
                                setState(() {});
                              },
                              field: field,
                              showMenu: isModifyMode,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showOtherDetails,
                    child: Builder(builder: (BuildContext context) {
                      if (longLinesProvider.isLoading)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitForm();
                            }
                          });
                    }),
                  )
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

class OptionMenuWidget extends StatefulWidget {
  final Key key;

  final Field field;
  final bool isFirst;
  final bool showMenu;

  final VoidCallback onMoveUp;
  final VoidCallback onRemove;

  OptionMenuWidget({
    required this.key,
    required this.field,
    required this.isFirst,
    required this.showMenu,
    required this.onMoveUp,
    required this.onRemove,
  });

  @override
  State<OptionMenuWidget> createState() => _OptionMenuWidgetState();
}

class _OptionMenuWidgetState extends State<OptionMenuWidget> {
  Widget child() {
    if (widget.field.type == "text") {
      return TextFieldWidget(
        textCapitalization: TextCapitalization.sentences,
        obscureText: false,
        autofocus: false,
        //enable: !widget.showMenu,
        initialValue: widget.field.value ?? "",
        onChanged: (val) => setState(() => widget.field.value = val),
        validator: (val) => val.isEmpty ? 'Enter a ${widget.field.name}' : null,
        labelText: '${widget.field.name} *',
      );
    } else if (widget.field.type == "dropdown") {
      return ReorderableDropDownWidget(
        showAddButton: widget.showMenu,
        labelText: '${widget.field.name} *',
        //enable: !widget.showMenu,
        items: widget.field.options == null ? [] : widget.field.options,
        validator: (val) =>
            widget.field.options.isEmpty ? 'Add a ${widget.field.name}' : null,
        onNew: (val) {
          //widget.field.options = val;
          widget.field.options.add(val);
        },
        onChanged: (val) {
          setState(() {
            widget.field.options = val;
            widget.field.options = val;
          });
          FocusScope.of(context).requestFocus(FocusNode());
        },
        selected: null,
      );
    } else if (widget.field.type == "date") {
      return DateTimePickerWidget(
        format: DateFormat('MM-dd-yyyy'),
        labelText: '${widget.field.name} *',
        //enable: !widget.showMenu,
        onChanged: (value) =>
            setState(() => widget.field.timestamp = Timestamp.fromDate(value)),
        validator: (val) => val == null ? 'Enter a date' : null,
        initialValue: widget.field.timestamp != null
            ? (widget.field.timestamp as Timestamp).toDate()
            : null,
        /* initialValue: formType == 'edit'
              ? DateTime.fromMillisecondsSinceEpoch(
              datePurchased.seconds * 1000)
              : dpField != null
              ? (dpField.options as Timestamp).toDate()
              : null*/
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      //key: widget.key,
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10), child: child()),
        ),
        if (widget.showMenu)
          PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  widget.onMoveUp();
                } else if (value == 2) {
                  widget.onRemove();
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
                    )
                  ])
      ],
    );
  }
}
