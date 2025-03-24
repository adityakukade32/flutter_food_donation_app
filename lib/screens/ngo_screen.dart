import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapk/screens/Ngo_food.dart';
import 'package:flutterapk/screens/ngo_homescreen.dart';

void main() {
  runApp(NGOApp());
}

class NGOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NGO App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NgoScreen(),
    );
  }
}

class NgoScreen extends StatefulWidget {
  @override
  _NgoScreenState createState() => _NgoScreenState();
}

class _NgoScreenState extends State<NgoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ngoNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String _areaOfOperation = 'Select Area';

   List<String> _areasOfOperation = [
    'Rural',
    'Urban',
    'Sub-Urban',
  ];

// This function will add/update the user and also add request data
  Future<void> createNgo() async {
    try {
//add user
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('ngo').doc();
      await docRef.set({
        'name': _ngoNameController.text,
        'reg_no': _registrationNumberController.text,
        'poc_name': _contactPersonController.text,
        'poc_no': _phoneNumberController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NGO created successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  "NGO Registration",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
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
        builder: (context) => NGOFoodDisplayScreen(),
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
  child: const Text("Skip to Profile "),
),



                         SizedBox(height: 20),
                TextFormField(
                  controller: _ngoNameController,
                  decoration: InputDecoration(
                    labelText: 'NGO Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter NGO name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _registrationNumberController,
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter registration number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _contactPersonController,
                  decoration: InputDecoration(
                    labelText: 'Contact Person',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact person name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // DropdownButtonFormField<String>(
                //   value: _areaOfOperation,
                //   items: _areasOfOperation.map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _areaOfOperation = newValue!;
                //     });
                //   },
                //   decoration: InputDecoration(
                //     labelText: 'Area of Operation',
                //     filled: true,
                //     fillColor: Colors.white,
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == 'Select Area') {
                //       return 'Please select an area of operation';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      await createNgo();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NGOFoodDisplayScreen()),
                      );
                    }
                  },
                  child: Text('Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... (NGOFoodDisplayScreen and NGOHomeScreen remain the same)
