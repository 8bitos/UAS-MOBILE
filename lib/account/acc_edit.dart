import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uas_cookedex/screens/e-mail_login_screen.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic>
      initialData; // Accept initial data from AccountPage

  const EditProfilePage({Key? key, required this.initialData})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  File? _bannerImage;

  late TextEditingController _nameController;
  late TextEditingController _bioController;

  int nameCharCount = 0;
  int bioCharCount = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _bioController = TextEditingController(text: widget.initialData['bio']);

    nameCharCount = _nameController.text.length;
    bioCharCount = _bioController.text.length;

    _nameController.addListener(() {
      setState(() {
        nameCharCount = _nameController.text.length;
      });
    });

    _bioController.addListener(() {
      setState(() {
        bioCharCount = _bioController.text.length;
      });
    });
  }

  Future<void> _pickImage({required bool isProfile}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(pickedImage.path);
        } else {
          _bannerImage = File(pickedImage.path);
        }
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'profileImage':
            _profileImage?.path ?? widget.initialData['profileImage'],
        'coverImage': _bannerImage?.path ?? widget.initialData['coverImage'],
      };

      Navigator.pop(
          context, updatedData); // Pass updated data back to AccountPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text("Edit Profile", style: TextStyle(color: Colors.black)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Cover Photo
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: _bannerImage != null
                                  ? FileImage(_bannerImage!)
                                  : FileImage(
                                      File(widget.initialData['coverImage'])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: TextButton.icon(
                            onPressed: () => _pickImage(isProfile: false),
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white),
                            label: const Text("Edit Banner",
                                style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile Photo
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : FileImage(
                                      File(widget.initialData['profileImage'])),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () => _pickImage(isProfile: true),
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.orangeAccent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Edit Photo",
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Profile Name",
                    ),
                    maxLength: 24,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      if (value.length > 24) {
                        return "Name must not exceed 24 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bio Field
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: "Bio",
                    ),
                    maxLength: 100,
                    maxLines: 3,
                    validator: (value) {
                      if (value != null && value.length > 100) {
                        return "Bio must not exceed 100 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full width button
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
