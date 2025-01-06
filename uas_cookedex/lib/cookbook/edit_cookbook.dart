import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CookbookEditPage extends StatefulWidget {
  final String photo;
  final String title;
  final String description;

  const CookbookEditPage({
    super.key,
    required this.photo,
    required this.title,
    required this.description,
  });

  @override
  State<CookbookEditPage> createState() => _CookbookEditPageState();
}

class _CookbookEditPageState extends State<CookbookEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedImage; // Image file path
  final ImagePicker _picker = ImagePicker(); // Image picker instance

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedImage = widget.photo; // Initialize with the provided photo
  }

  Future<void> _changePhoto() async {
    // Show options to choose image source
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery, // or ImageSource.camera
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage.path; // Update selected image path
      });
    }
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'photo': _selectedImage, // Pass the updated photo
      'title': _titleController.text,
      'description': _descriptionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Cookbook",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Change Photo Section
              GestureDetector(
                onTap: _changePhoto, // Trigger the image picker
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                   ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _selectedImage != null && _selectedImage!.isNotEmpty
                      ? Image.file(
                          File(_selectedImage!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/default_recipe.jpg',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/default_recipe.jpg',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                            );
                          },
                        ),
                  ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Title Text Field
              const Text(
                "Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Cookbook Title",
                ),
              ),
              const SizedBox(height: 24),
              // Description Text Field
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Description",
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
