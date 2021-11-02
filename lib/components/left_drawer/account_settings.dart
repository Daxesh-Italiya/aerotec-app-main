import 'dart:io';

import 'package:aerotec_flutter_app/constants/constants.dart';
import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

enum ProfileImage { GALLERY, CAMERA }

class _AccountSettingsState extends State<AccountSettings> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? profileImageUrl;
  bool photoUploaded = false;
  late UserProvider userProvider;
  bool isLoading = false;


  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    this.profileImageUrl = userProvider.user!.imageUrl;
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CameraCamera(
          onFile: (File file) {
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
        ),
      ),
    );
  }

  Future _saveProfileImage() async{
    setState(() => isLoading = true);
    if(_image != null) {
      await userProvider.uploadProfileImage(_image!);
      setState(() => isLoading = false);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        maxRadius: 80,
                        child: _image == null ? 
                        profileImageUrl == null ? Icon(Icons.add_a_photo, size: 100,)  : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: NetworkImage(profileImageUrl!),
                                  fit: BoxFit.fill
                                ),
                              ),
                            )
                        : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.fill
                                ),
                              ),
                            ),
                        ),
                    ),
                    Positioned(
                      right: 60,
                      bottom: 20,
                      child: PopupMenuButton(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Icon(Icons.add),
                        ),
                        onSelected: (val) {
                          switch (val) {
                            case ProfileImage.CAMERA:
                              {
                                openCamera();
                                break;
                              }
                            case ProfileImage.GALLERY:
                              {
                                getImage();
                                break;
                              }
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: ProfileImage.CAMERA,
                              child: Text('Camera')),
                          PopupMenuItem(
                              value: ProfileImage.GALLERY,
                              child: Text('Choose Photo')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: AppTheme.secondary),
                      onPressed: _saveProfileImage,
                      child: Text('Save'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
