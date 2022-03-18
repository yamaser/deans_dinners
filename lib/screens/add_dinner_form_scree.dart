import 'dart:io';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddDinnerFormScreen extends StatefulWidget {
  static const routeName = 'AddDinnerFormScreen';

  const AddDinnerFormScreen({Key? key}) : super(key: key);

  @override
  State<AddDinnerFormScreen> createState() => _AddDinnerFormScreenState();
}

class _AddDinnerFormScreenState extends State<AddDinnerFormScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _descriptionFieldController = TextEditingController();
  DataRepository repository = DataRepository();
  Dinner dinner = Dinner();
  final ImagePicker _picker = ImagePicker();
  XFile? photo;

  @override
  void dispose() {
    _nameFieldController.dispose();
    _descriptionFieldController.dispose();
    super.dispose();
  }

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
        FirebaseStorage.instance.ref().child(basename(photo!.name));
    UploadTask uploadTask = storageReference.putFile(File(photo!.path));
    await uploadTask.whenComplete(() {});
    dinner.photoUrl = await storageReference.getDownloadURL();
  }

  Widget _formSubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          await uploadPhotoToFirebase(dinner);
          repository.addDinner(dinner);
          Navigator.of(context).pop();
        }
      },
      child: const Text('Submit'),
    );
  }

  Widget _formClearButton() {
    return ElevatedButton(
        onPressed: () {
          _nameFieldController.clear();
          _descriptionFieldController.clear();
          photo = null;
          setState(() {});
        },
        child: const Text('Cancel'),
        style: ElevatedButton.styleFrom(primary: Colors.red));
  }

  Widget _displayFormButtons(BuildContext context) {
    if (photo != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _formSubmitButton(context),
          const SizedBox(width: 6),
          _formClearButton(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _displayGetImageButtons() {
    if (photo == null) {
      return Column(
        children: [
          _takePhotoButton(photo, getPhoto),
          const Text('or'),
          _selectFromGalleryButton(photo, selectFromGallery)
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Dinner Item'),
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
                  controller: _nameFieldController,
                  autofocus: true,
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
                  controller: _descriptionFieldController,
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
              _displayGetImageButtons(),
              _displayFormButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _takePhotoButton(XFile? photo, Function getPhoto) {
  if (photo == null) {
    return ElevatedButton.icon(
      onPressed: () async {
        await getPhoto();
      },
      icon: const Icon(Icons.camera),
      label: const Text('Take a Photo'),
    );
  } else {
    return Container();
  }
}

Widget _selectFromGalleryButton(XFile? photo, Function selectFromGallery) {
  if (photo == null) {
    return ElevatedButton.icon(
      onPressed: () async {
        await selectFromGallery();
      },
      icon: const Icon(Icons.view_comfy),
      label: const Text('Select Image From Gallery'),
    );
  } else {
    return Container();
  }
}

Widget _displayImage(XFile? photo) {
  if (photo != null) {
    return Flexible(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(photo.path))),
    );
  } else {
    return Container();
  }
}
