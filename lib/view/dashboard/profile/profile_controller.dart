import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_media/res/color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tech_media/res/component/input_text_field.dart';
import 'package:tech_media/utils/utils.dart';
import 'package:tech_media/view/services/session_manager.dart';

class ProfileController with ChangeNotifier {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('User');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      uploadImage(context);
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.camera,
                      color: AppColors.primaryIconColor,
                    ),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickGalleryImage(context);
                    },
                    leading: const Icon(
                      Icons.image,
                      color: AppColors.primaryIconColor,
                    ),
                    title: const Text('Gallery'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadImage(BuildContext context) async {
    setLoading(true);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref('/profileImage' + SessionController().userId.toString());
    firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(image!.path).absolute);
    await Future.value(uploadTask);
    final newUrl = await storageRef.getDownloadURL();
    ref
        .child(SessionController().userId.toString())
        .update({'profile': newUrl}).then((value) {
      setLoading(false);
      Utils.toastMessage('Profile updated');
      _image = null;
    }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
      setLoading(false);
    });
  }

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameController.text = name;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('Update username'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InputTextField(
                  myController: nameController,
                  focusNode: nameFocusNode,
                  onFiledSubmittedValue: (value) {},
                  keyBoardType: TextInputType.text,
                  obscureText: false,
                  hint: 'Enter name',
                  onValidator: (value) {},
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: AppColors.alertColor),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.child(SessionController().userId.toString()).update({
                  'userName': nameController.text.toString(),
                }).then((value) {
                  nameController.clear();
                }).onError((error, stackTrace) {});
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.subtitle2!,
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> showPhoneDialogAlert(BuildContext context, String phoneNumber) {
    phoneController.text = phoneNumber;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text('Update Phone Number'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InputTextField(
                  myController: phoneController,
                  focusNode: phoneFocusNode,
                  onFiledSubmittedValue: (value) {},
                  keyBoardType: TextInputType.phone,
                  obscureText: false,
                  hint: 'Enter phone number',
                  onValidator: (value) {},
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: AppColors.alertColor),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.child(SessionController().userId.toString()).update({
                  'phone': phoneController.text.toString(),
                }).then((value) {
                  phoneController.clear();
                }).onError((error, stackTrace) {});
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.subtitle2!,
              ),
            )
          ],
        );
      },
    );
  }
}
