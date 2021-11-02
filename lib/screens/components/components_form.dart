import 'dart:io';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aerotec_flutter_app/widgets/widgets.dart';
import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/models/components_model.dart';
import 'package:aerotec_flutter_app/providers/components_provider.dart';
class ComponentsForm extends StatefulWidget {
  final ComponentsModel? component;
  final String formType;

  const ComponentsForm({ required this.component, required this.formType });
  _ComponentsFormState createState() => _ComponentsFormState();
}

class _ComponentsFormState extends State<ComponentsForm> {
  late String formType;
  /***Form Properties */
  String id = '';
  String name = '';
  String category = '';
  String imagePath = ''; 
  String partNumber = '';
  String description = '';
  String serialNumber = '';
  String safeWorkingLoad = safeWorkingLoadItems[0]; // Dropdown
  String timeBetweenOverhauls = timeBetweenOverhaulsItems[0];  // Dropdown
  Timestamp datePurchased = Timestamp.fromDate(new DateTime.now());
  Timestamp inspectionDate = Timestamp.fromDate(new DateTime.now());
  Timestamp datePutIntoService = Timestamp.fromDate(new DateTime.now());
  Timestamp nextInspectionDate = Timestamp.fromDate(new DateTime.now());
  /***Form Properties */
  
  File? _image;
  bool photoUploaded = false;
  late ComponentsProvider componentsProvider;
  final ImagePicker _picker = ImagePicker();
  
  void initState() {
    super.initState();
    formType = widget.formType;
    if(formType == 'edit') populateForm();
    componentsProvider = Provider.of<ComponentsProvider>(context, listen: false);
  }

  void populateForm() {
      id = widget.component!.id;
      name = widget.component!.name;
      category = widget.component!.category;
      description = widget.component!.description;
      partNumber = widget.component!.partNumber;
      safeWorkingLoad = widget.component!.safeWorkingLoad;
      serialNumber = widget.component!.serialNumber;
      timeBetweenOverhauls = widget.component!.timeBetweenOverhauls;
      imagePath = widget.component!.imagePath;
      datePurchased = widget.component!.datePurchased;
      datePutIntoService = widget.component!.datePutIntoService;
      inspectionDate = widget.component!.inspectionDate;
      nextInspectionDate = widget.component!.nextInspectionDate;
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    print(inspect(pickedFile?.path));
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
        photoUploaded = true;
      } else {
        print('No Image Selected');
      }
    });
  }

  void openCamera() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraCamera( 
      onFile: (File file) {  
        Navigator.pop(context);
        setState(() {
          if(file.path.isNotEmpty) {
            _image = file;
            photoUploaded = true;
          } else {
            print('No Picture Taken!');
          }
        });
      },)));
  }
  
  submitForm() {
    if(photoUploaded || imagePath.isNotEmpty) {
      ComponentsModel longline = ComponentsModel(
          id: id,
          name: name,
          category: category,
          description: description,
          partNumber: partNumber,
          safeWorkingLoad: safeWorkingLoad,
          serialNumber: serialNumber,
          timeBetweenOverhauls: timeBetweenOverhauls,
          imagePath: imagePath,
          datePurchased: datePurchased,
          datePutIntoService: datePutIntoService,
          inspectionDate: inspectionDate,
          nextInspectionDate: nextInspectionDate
      );
      if (formType == 'edit') componentsProvider.updateComponent(longline, _image);
      if (formType == 'new') componentsProvider.createNewComponent(longline, _image!);
      Navigator.pop(context);
    } else {
      print('No Image Selected!');
    }
  }

  Widget build(BuildContext context) {
    ComponentsProvider componentsProvider = Provider.of<ComponentsProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(
          formType == 'edit' ? 'Edit Component' : 'Create New Component',
          style: GoogleFonts.benchNine(),
        ) 
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                  width: double.infinity,
                  height: size.height * .3,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Center(
                        child: _image == null ? 
                        imagePath == '' ? Icon(Icons.add_a_photo, size: 100,)  : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.fill
                                ),
                              ),
                            )
                        : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.fill
                                ),
                              ),
                            ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width:60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red[500],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () => openCamera(),
                                icon: Icon(Icons.photo_camera),
                              ),
                            ),
                          ),
                          SizedBox( height: 10),
                          Container(
                            width:60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.orange[500],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () => getImage(),
                                icon: Icon(Icons.photo_library),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, 
                          color: Colors.grey,
                      )
                  ),
                ),
                SizedBox(height: size.height * .03),
                  SizedBox(height: screenHeight * .05),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    initialValue: name,
                    onChanged: (val) => setState(() => name = val),
                    validator: (val) {},
                    labelText: 'Name',
                  ),
                  SizedBox(height: screenHeight * .02),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    initialValue: category,
                    onChanged: (val) => setState(() => category = val),
                    validator: (val) {},
                    labelText: 'Category',
                  ),
                  SizedBox(height: screenHeight * .02),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    initialValue: description,
                    onChanged: (val) => setState(() => description = val),
                    validator: (val) {},
                    labelText: 'Description',
                  ),
                  SizedBox(height: screenHeight * .02),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    initialValue: partNumber,
                    onChanged: (val) => setState(() => partNumber = val),
                    validator: (val) {},
                    labelText: 'Part Number',
                  ),
                  SizedBox(height: screenHeight * .02),
                  TextFieldWidget(
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: false,
                    initialValue: serialNumber,
                    onChanged: (val) => setState(() => serialNumber = val),
                    validator: (val) {},
                    labelText: 'Serial Number',
                  ),
                  SizedBox(height: screenHeight * .02),
                  DropDownFormWidget(
                      labelText: 'Safe Working Load',
                      items: safeWorkingLoadItems,
                      value: safeWorkingLoad,
                      validator: (val) => val == '- select -' ? 'Add a load' : null,
                      onChanged: (val) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() => safeWorkingLoad = val);
                      }
                  ),
                  SizedBox(height: screenHeight * .04),
                  DropDownFormWidget(
                      labelText: 'Time Between Overhauls',
                      items: timeBetweenOverhaulsItems,
                      value: timeBetweenOverhauls,
                      validator: (val) => val == '- select -' ? 'Add a time' : null,
                      onChanged: (val) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() => timeBetweenOverhauls = val);
                      }
                  ),
                  SizedBox(height: screenHeight * .02),
                  DateTimePickerWidget(
                      format: DateFormat('MM-dd-yyyy'),
                      labelText: 'Date Purchased',
                      onChanged: (value) => setState(() => datePurchased),
                      validator: (val) => val == null ? 'Enter a date' : null,
                      initialValue: formType == 'edit' ? DateTime.fromMillisecondsSinceEpoch( datePurchased.seconds * 1000) : null
                  ),
                  SizedBox(height: screenHeight * .02),
                  DateTimePickerWidget(
                      format: DateFormat('MM-dd-yyyy'),
                      labelText: 'Date Put Into Service',
                      onChanged: (value) => setState(() => value = datePutIntoService),
                      validator: (val) => val == null ? 'Enter a date' : null,
                      initialValue: formType == 'edit' ? DateTime.fromMillisecondsSinceEpoch( datePutIntoService.seconds * 1000) : null
                  ),
                  SizedBox(height: screenHeight * .02),
                  DateTimePickerWidget(
                      format: DateFormat('MM-dd-yyyy'),
                      labelText: 'Next Inspection Date',
                      onChanged: (value) => setState(() => value = nextInspectionDate),
                      validator: (val) => val == null ? 'Enter a date' : null,
                      initialValue: formType == 'edit' ? DateTime.fromMillisecondsSinceEpoch( nextInspectionDate.seconds * 1000 ) : null
                  ),
                  SizedBox(height: screenHeight * .03),
                  Builder(builder: (BuildContext context) {
                    if (componentsProvider.isLoading)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () => submitForm(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
