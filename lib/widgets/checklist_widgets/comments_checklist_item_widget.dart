import 'dart:io';

import 'package:aerotec_flutter_app/widgets/textfield_widget.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

class CommentsChecklistItemWidget extends StatefulWidget {
  final checklistItem;
  final int index;
  final int lastIndex;
  CommentsChecklistItemWidget({ required this.checklistItem, required this.index, required this.lastIndex });
  @override
  _CommentsChecklistItemWidgetState createState() => _CommentsChecklistItemWidgetState();
}

class _CommentsChecklistItemWidgetState extends State<CommentsChecklistItemWidget> {
  bool pictureTaken = false;
  File? _image;
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
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
                pictureTaken = true;
              } else {
                print('No Picture Taken!');
              }
            });
          },
        ),
      ),
    );
  }

  void showPicture() {
    Widget toast = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1
        ),
      ),
      height: 350,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                height: 300,
                width: double.infinity,
                child: ClipRect(
                  child: PhotoView(
                    imageProvider: FileImage(_image!),
                    maxScale: PhotoViewComputedScale.covered * 2,
                    minScale: PhotoViewComputedScale.contained * .08,
                    initialScale: PhotoViewComputedScale.covered,
                  ),
                )
              ),
              ElevatedButton(
                onPressed: () {
                  print('Close Toast!');
                  fToast!.removeCustomToast();
                }, 
                child: Text('Close')
              )
            ],
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              color: Colors.white,
              child: IconButton(
                icon: Icon(Icons.clear),
                iconSize: 20,
                onPressed: () {
                  fToast!.removeCustomToast();
                  setState(() {
                    pictureTaken = false;
                  });
                },
              )
            )
          )
        ],
      )
    );
    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(days: 1)
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size  = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        margin: this.widget.index == this.widget.lastIndex - 1 ? EdgeInsets.only(top: 15, bottom: 50) : EdgeInsets.symmetric(vertical: 15),
        elevation: 0,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Text(
                    this.widget.checklistItem.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
                if(this.widget.checklistItem.no) Container(
                  padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 20),
                  margin: EdgeInsets.only(bottom: 10),
                  child: TextFieldWidget(
                    initialValue: '', 
                    onChanged: (val) {}, 
                    validator: (val) {}, 
                    labelText: 'Comments', 
                    obscureText: false, 
                    textCapitalization: TextCapitalization.words
                  ),
                )
              ],
            ),
            Positioned.fill(
              top: 0,
              bottom: 0,
              child: Container(
                transform: Matrix4.translationValues(size.width *.55, size.height *.03, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    this.widget.checklistItem.yes == false ? AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      width: !this.widget.checklistItem.no ? 50 : 0,
                      height: !this.widget.checklistItem.no ? 50 : 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() => this.widget.checklistItem.no = true);
                            setState(() => this.widget.checklistItem.yes = false);
                          },
                          icon: Image.asset('images/xmark-gray.png')
                        )
                      )
                    ) : Container(
                      width: 50,
                      height: 50,
                    ),
                    AnimatedContainer(
                      transform: this.widget.checklistItem.no ? Matrix4.translationValues(-10, 10, 0) : Matrix4.translationValues(0, 0, 0),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      width: this.widget.checklistItem.no ? 60 : 0,
                      height: this.widget.checklistItem.no ? 60 : 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() => this.widget.checklistItem.no = false);
                            setState(() => this.widget.checklistItem.yes = false);
                          },
                          icon: Image.asset('images/xmark.png'),
                          iconSize: 60,
                        )
                      )
                    ),
                    this.widget.checklistItem.no == false ? AnimatedContainer(
                      transform: !this.widget.checklistItem.yes ? Matrix4.translationValues(-10, 0, 0) : Matrix4.translationValues(0, 0, 0),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      width: !this.widget.checklistItem.yes ? 50 : 0,
                      height: !this.widget.checklistItem.yes ? 50 : 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() => this.widget.checklistItem.yes = true);
                            setState(() => this.widget.checklistItem.no = false);
                          },
                          icon: Image.asset('images/checkmark-gray.png')
                        )
                      )
                    ) : SizedBox.shrink(),
                    this.widget.checklistItem.no == true ? Container(
                      transform: Matrix4.translationValues(-20, 10, 0),
                      width: 60,
                      height: 60,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            if(!pictureTaken) {
                              openCamera();
                            } else {
                              showPicture();
                            }
                          },
                          icon: Image.asset('images/camera.png'),
                          iconSize: 60 
                        )
                      )
                    ) : SizedBox.shrink(),
                    AnimatedContainer(
                      transform: this.widget.checklistItem.yes ? Matrix4.translationValues(-10, 10, 0) : Matrix4.translationValues(0, 0, 0),
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      width: this.widget.checklistItem.yes ? 60 : 0,
                      height: this.widget.checklistItem.yes ? 60 : 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() => this.widget.checklistItem.yes = false);
                            setState(() => this.widget.checklistItem.no = false);
                          },
                          icon: Image.asset('images/checkmark.png'),
                          iconSize: 60,
                        )
                      )
                    ),
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
