import 'dart:io';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/provider/selected_dinners.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDinnerScreen extends StatefulWidget {
  static const routeName = 'EditDinnerScreen';
  const EditDinnerScreen({Key? key}) : super(key: key);

  @override
  State<EditDinnerScreen> createState() => _EditDinnerScreenState();
}

class _EditDinnerScreenState extends State<EditDinnerScreen> {
  final formKey = GlobalKey<FormState>();
  DataRepository repository = DataRepository();
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  Dinner dinner = Dinner();

  Future<void> getPhoto() async {
    photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<void> selectFromGallery() async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> uploadPhotoToFirebase(Dinner dinner) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(photo!.name);
    UploadTask uploadTask = storageReference.putFile(File(photo!.path));
    await uploadTask.whenComplete(() {});
    dinner.photoUrl = await storageReference.getDownloadURL();
  }

  Widget _takePhotoButton(XFile? photo, Function getPhoto) {
    return ElevatedButton.icon(
      onPressed: () async {
        await getPhoto();
      },
      icon: const Icon(Icons.camera),
      label: const Text('New Photo'),
    );
  }

  Widget _selectFromGalleryButton(XFile? photo, Function selectFromGallery) {
    return ElevatedButton.icon(
      onPressed: () async {
        await selectFromGallery();
      },
      icon: const Icon(Icons.view_comfy),
      label: const Text('New Image From Gallery'),
    );
  }

  Widget _formSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (photo != null) await uploadPhotoToFirebase(dinner);
          repository.updateDinner(dinner);
          context.read<SelectedDinners>().update(dinner);
          Navigator.of(context).pop();
        }
      },
      child: const Text('Submit'),
    );
  }

  Widget _displayImage(XFile? photo) {
    if (photo != null) {
      return Flexible(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(photo.path)),
        ),
      );
    } else {
      return Flexible(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(dinner.photoUrl!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dinner = ModalRoute.of(context)!.settings.arguments as Dinner;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Dinner'),
        toolbarHeight: 40,
        //backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  initialValue: dinner.name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) {
                    dinner.name = value.toString();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  initialValue: dinner.description,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    if (value!.isNotEmpty) {
                      dinner.description = value.toString();
                    }
                  },
                ),
              ),
              _displayImage(photo),
              _takePhotoButton(photo, getPhoto),
              _selectFromGalleryButton(photo, selectFromGallery),
              _formSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
