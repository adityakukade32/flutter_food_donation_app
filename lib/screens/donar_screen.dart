
import 'package:flutter/material.dart';
import 'package:flutterapk/screens/donarhome_screen.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'home_screen.dart'; // Import your HomeScreen file

class DonarScreen extends StatefulWidget {
  @override
  _DonarScreenState createState() => _DonarScreenState();
}

class _DonarScreenState extends State<DonarScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  File? _foodImage;

// This function will add/update the user and also add request data
  Future<void> submitDonation() async {
    try {
//add user
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc();

      await docRef.set({
        'name': _nameController.text,
        'mob': _mobileController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile created successfully!')),
      );

      DocumentReference docRef2 =
          FirebaseFirestore.instance.collection('request').doc();

      await docRef2.set({
        'title': _nameController.text,
        'desc': _mobileController.text,
        'qty': _quantityController.text,
        'expiry': _expiryDateController.text,
        'address': _addressController.text,
        'pincode': _pinCodeController.text,
        'pickup': false
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request Created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating profile: $e')),
      );
    }
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        _expiryDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _foodImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_foodImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload a food image")),
        );
        return;
      }

      final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(_expiryDateController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Please select a valid expiry date in YYYY-MM-DD format.")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm Submission"),
          content: Text(
              "Are you sure you want to submit the food donation details?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await submitDonation();
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Donation Submitted Successfully!")),
                );

                // Redirect to HomeScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DonarHomeScreen()), // Redirecting to HomeScreen
                );
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.green.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Food Donation Form",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                    ElevatedButton(
  onPressed: () async {
    Navigator.pop(context);
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Skipped to Homepage!")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DonarHomeScreen(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.blueAccent, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero, // Makes  it square
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold, // Bold text
      fontSize: 16,
    ),
  ),
  child: const Text("Skip to Donor Screen"),
),



                         SizedBox(height: 20),
                        _buildTextField(
                            _nameController, "Full Name", Icons.person),
                        _buildTextField(
                            _mobileController, "Mobile No", Icons.phone,
                            keyboardType: TextInputType.phone),
                        _buildTextField(
                            _foodNameController, "Food Name", Icons.fastfood),
                        _buildTextField(_quantityController,
                            "Food Quantity (kg)", Icons.scale,
                            keyboardType: TextInputType.number),
                        GestureDetector(
                          onTap: () => _pickExpiryDate(context),
                          child: AbsorbPointer(
                            child: _buildTextField(_expiryDateController,
                                "Food Expiry Date", Icons.date_range),
                          ),
                        ),
                        _buildTextField(_addressController, "Pickup Address",
                            Icons.location_on,
                            maxLines: 2),
                        _buildTextField(
                            _pinCodeController, "Pin Code", Icons.pin,
                            keyboardType: TextInputType.number),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Text(
                              "Upload Food Image",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            _foodImage != null
                                ? Image.file(_foodImage!, height: 150)
                                : Icon(Icons.image,
                                    size: 100, color: Colors.grey),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(Icons.upload),
                              label: Text("Choose Image"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text("Submit Donation",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
