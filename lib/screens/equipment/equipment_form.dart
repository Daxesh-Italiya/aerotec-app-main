import 'dart:developer';
import 'dart:io';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/category_model.dart';
import 'package:aerotec_flutter_app/models/equipment_model.dart';
import 'package:aerotec_flutter_app/models/field_model.dart';
import 'package:aerotec_flutter_app/providers/categories_provider.dart';
import 'package:aerotec_flutter_app/providers/equipment_provider.dart';
import 'package:aerotec_flutter_app/screens/home/home.dart';
import 'package:aerotec_flutter_app/widgets/additional_field_dialog.dart';
import 'package:aerotec_flutter_app/widgets/custom_form_widget.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EquipmentForm extends StatefulWidget {
  final EquipmentModel? equipment;
  final String formType;

  const EquipmentForm({required this.equipment, @required required this.formType});
  _EquipmentFormState createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
  final _formKey = GlobalKey<FormState>();

  List<Field> detailsFieldItems = [];
  List<Field> maintenanceFieldItems = [];
  List<Field> othersFieldItems = [];

  List<Field> allDefaultFields = [
    Field(
      type: "text",
      options: [],
      label: 'Name',
      name: 'name',
      mainType: "details",
      position: 1,
    ),
    Field(
        type: "text",
        options: [],
        label: 'Part Number',
        name: 'part_number',
        mainType: "details",
        position: 2),
    Field(
        type: "text",
        options: [],
        label: 'Serial Number',
        name: 'serial_numer',
        mainType: "details",
        position: 3),
    Field(
        type: "dropdown",
        label: 'Size',
        options: [],
        name: 'size',
        mainType: "details",
        position: 4),
    Field(
        type: "dropdown",
        label: 'Length',
        options: [],
        name: 'length',
        mainType: "details",
        position: 5),
    Field(
        type: "dropdown",
        label: 'Type',
        options: [],
        name: 'type',
        mainType: "details",
        position: 6),
    Field(
        type: "dropdown",
        label: 'Safe Working Load',
        options: [],
        name: 'safe_working_load',
        mainType: "details",
        position: 7),
    // Maintenance
    Field(
        options: [],
        type: "date",
        label: 'Date Purchased',
        name: 'date_purchased',
        mainType: "maintenance",
        position: 8),
    Field(
        options: [],
        type: "date",
        label: 'Date Put Into Service',
        name: 'date_put_into_service',
        mainType: "maintenance",
        position: 9),
    Field(
        options: ['12 months'],
        type: "dropdown",
        label: 'Time Between Overhauls',
        name: 'time_between_overhauls',
        mainType: "maintenance",
        position: 10),
  ];

  List<CategoryModel> categoryList = [];
  CategoryModel? currentCategory;

  bool _isModifyMode = false;
  bool showDetails = false;

  File? _image;
  String? imageUrl;
  bool photoUploaded = false;
  final ImagePicker _picker = ImagePicker();
  late EquipmentProvider equipmentProvider;
  late CategoriesProvider categoriesProvider;
  late String formType;

  void initState() {
    super.initState();
    equipmentProvider = Provider.of<EquipmentProvider>(context, listen: false);
    categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    formType = widget.formType;
    initCategoryList();
    if (formType == 'edit') populateForm();
  }

  initCategoryList() {
    // DEEP COPY the Categories list
    categoriesProvider = Provider.of<CategoriesProvider>(context, listen: false);
    categoriesProvider.categories.forEach((category) {
      List<Field> fieldList = [];
      category.fields.forEach((field) {
        Field a = new Field(
          label: field.label,
          name: field.name,
          type: field.type,
          options: field.options,
          position: field.position,
          mainType: field.mainType,
          removed: field.removed,
          date: field.date,
          value: field.value,
          isOptional: field.isOptional,
        );
        fieldList.add(a);
      });
      CategoryModel newCategory =
          new CategoryModel(id: category.id, name: category.name, fields: fieldList);
      categoryList.add(newCategory);
    });
  }

  void populateForm() {
    if (widget.equipment != null) {
      CategoryModel category =
          categoryList.firstWhere((e) => e.id == widget.equipment!.fields['category_id']);
      initItems(category);
    }

    List<Field> allFields = [...detailsFieldItems, ...maintenanceFieldItems, ...othersFieldItems];

    allFields.forEach((Field field) {
      if (field.type == 'date') {
        field.date = DateTime.fromMillisecondsSinceEpoch(
            widget.equipment!.fields[field.name].seconds * 1000);
      } else {
        field.value = widget.equipment!.fields[field.name];
      }
    });
    setState(() => showDetails = true);
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

  addNewCategory(String name) async {
    DocumentReference doc = await categoriesProvider.createCategory(name, allDefaultFields);
    CategoryModel categoryModel = CategoryModel(fields: allDefaultFields, name: name, id: doc.id);

    setState(() {
      showDetails = true;
      _isModifyMode = true;
      //currentCategory = categoryModel;
      FocusScope.of(context).requestFocus(FocusNode());
      initItems(categoryModel);
    });
  }

  addOtherField() {
    showDialog(
        context: context,
        builder: (context) {
          return AdditionalFieldDialog(callback: addNewField);
        });
  }

  addNewField(fieldTitle, fieldType) async {
    detailsFieldItems.add(
      Field(
          label: fieldTitle,
          name: fieldTitle
              .trim()
              .replaceAll(' ', '_')
              .replaceAll(RegExp('[^A-Za-z0-9_]'), '')
              .toLowerCase(),
          options: [],
          type: fieldType.toLowerCase(),
          position: 0,
          mainType: "details"),
    );

    List<Field> allFields = [...detailsFieldItems, ...maintenanceFieldItems, ...othersFieldItems];
    await categoriesProvider.updateCategory(currentCategory!.id!, currentCategory!.name, allFields);
  }

  finalizeForm() async {
    if (!_formKey.currentState!.validate()) return;

    List<Field> fields1 = detailsFieldItems.where((e) => e.mainType == "details").toList();
    List<Field> fields2 = maintenanceFieldItems.where((e) => e.mainType == "maintenance").toList();
    List<Field> fields3 = othersFieldItems.where((e) => e.mainType == "others").toList();
    List<Field> allFields = [...fields1, ...fields2, ...fields3];

    await categoriesProvider.updateCategory(currentCategory!.id!, currentCategory!.name, allFields);

    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _isModifyMode = false);
  }

  initItems(CategoryModel categoryModel) {
    setState(() => currentCategory = categoryModel);

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
    }
  }

  submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    List<Field> allFields = [...detailsFieldItems, ...maintenanceFieldItems, ...othersFieldItems];
    EquipmentModel equipment = EquipmentModel.fromAllfields(allFields);

    if (formType == 'new') {
      await equipmentProvider.createNewListing(
          equipment, currentCategory!.id!, currentCategory!.name, _image);
    } else if (formType == 'edit') {
      equipment.id = widget.equipment!.id;
      await equipmentProvider.updateListing(equipment, currentCategory!.id!, _image);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    EquipmentProvider equipmentProvider = Provider.of<EquipmentProvider>(context);

    Size size = MediaQuery.of(context).size;
    if (this.widget.equipment != null) {
      List<dynamic> filename = this.widget.equipment!.fields['filename']?.split('.') ?? [null];
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
                    visible: showDetails,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Component Image ----------------------------------------------------------/

                        Container(
                          width: double.infinity,
                          height: size.height * .3,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Center(
                                child: _image == null
                                    ? imageUrl == null
                                        ? Icon(
                                            Icons.add_a_photo,
                                            size: 100,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl:
                                                'https://firebasestorage.googleapis.com/v0/b/aerotec-app.appspot.com/o/aerotec%2Fequipment%2F${imageUrl.toString()}_800x800.jpeg?alt=media',
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Center(
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: CircularProgressIndicator(),
                                              ),
                                            ),
                                          )
                                    : Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: FileImage(_image!), fit: BoxFit.cover),
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 50,
                                child: PopupMenuButton(
                                  enabled: !_isModifyMode,
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
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.photo_camera),
                                    ),
                                  ),
                                  onSelected: (val) {
                                    if (val == 0) {
                                      openCamera();
                                    } else {
                                      getImage();
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    PopupMenuItem(value: 0, child: Text('Take Photo')),
                                    PopupMenuItem(value: 1, child: Text('Choose Image')),
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
                                        _isModifyMode = true;
                                      });
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 0, child: Text('Modify Form')),
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

                        // Finalize Form Button ----------------------------------------------------------/

                        SizedBox(height: size.height * .03),
                        if (_isModifyMode)
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

                  // Category Field ----------------------------------------------------------/

                  CategoryDropDownWidget(
                    labelText: 'Category *',
                    selected: currentCategory != null ? currentCategory!.id : null,
                    items: categoryList,
                    validator: (category) => currentCategory == null ? 'Add a Category' : null,
                    isModifyMode: _isModifyMode,
                    onNew: (category) {
                      addNewCategory(category);
                    },
                    onChanged: (category) {
                      setState(() => initItems(category));
                      showDetails = true;

                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  SizedBox(height: size.height * .04),
                  Visibility(
                    visible: showDetails,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // DETAILS SECTION

                        Text('Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: size.height * .02),
                        ListView.builder(
                          itemBuilder: (context, index) {
                            Field field = detailsFieldItems[index];

                            return CustomFormWidget(
                              key: ValueKey("list1_${index}"),
                              isFirst: index == 3,
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
                              onOptional: () => setState(() => detailsFieldItems[index].isOptional =
                                  (detailsFieldItems[index].isOptional != null)
                                      ? !detailsFieldItems[index].isOptional!
                                      : true),
                              field: field,
                              enable: !_isModifyMode,
                              isModifyMode: _isModifyMode,
                            );
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: detailsFieldItems.length,
                        ),

                        // Additional Fields Link ----------------------------------------------------------/

                        SizedBox(height: size.height * .03),
                        if (_isModifyMode)
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
                            ],
                          ),

                        // Maintenance Fields ----------------------------------------------------------/

                        if (_isModifyMode) SizedBox(height: size.height * .03),
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

                            return CustomFormWidget(
                              key: ValueKey("list2_${index}"),
                              isFirst: index == 0,
                              onMoveUp: () {
                                int newIndex = index - 1;
                                int oldIndex = index;

                                final currentItem = maintenanceFieldItems[oldIndex];

                                maintenanceFieldItems.removeAt(oldIndex);
                                maintenanceFieldItems.insert(newIndex, currentItem);

                                setState(() {});
                              },
                              onRemove: () {
                                maintenanceFieldItems.removeAt(index);
                                setState(() {});
                              },
                              onOptional: () => setState(() => detailsFieldItems[index].isOptional =
                                  (detailsFieldItems[index].isOptional != null)
                                      ? !detailsFieldItems[index].isOptional!
                                      : true),
                              field: field,
                              enable: !_isModifyMode,
                              isModifyMode: _isModifyMode,
                            );
                          },
                        ),

                        // OTHER SECTION (I THINK THIS IS NOT NEEDED)

                        SizedBox(height: size.height * .03),
                        ListView.builder(
                          itemCount: othersFieldItems.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Field field = othersFieldItems[index];

                            //return Text("${field.type}");

                            return CustomFormWidget(
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
                              onOptional: () {},
                              field: field,
                              enable: !_isModifyMode,
                              isModifyMode: _isModifyMode,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showDetails,
                    child: Builder(
                      builder: (BuildContext context) {
                        if (equipmentProvider.isLoading)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return ElevatedButton(
                            child: Text('Submit'),
                            onPressed: _isModifyMode == true
                                ? null
                                : () {
                                    submitForm();
                                  });
                      },
                    ),
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
