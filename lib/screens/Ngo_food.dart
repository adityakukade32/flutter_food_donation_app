import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NGOFoodDisplayScreen extends StatefulWidget {
  @override
  _NGOFoodDisplayScreenState createState() => _NGOFoodDisplayScreenState();
}

class _NGOFoodDisplayScreenState extends State<NGOFoodDisplayScreen> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('request');

  void acceptFoodRequest(String docId) async {
    await usersCollection
        .doc(docId)
        .update({'pickup': true, 'status': 'Approved'});
  }

  void declineFoodRequest(String docId) async {
    await usersCollection
        .doc(docId)
        .update({'pickup': false, 'status': 'Rejected'});
    setState(() {}); // Refresh the UI after rejection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Food Items',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.deepPurple.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: usersCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                  child: Text('No food donations available.',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)));
            }

            List<QueryDocumentSnapshot> foodItems = snapshot.data!.docs;

            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> foodData =
                    foodItems[index].data() as Map<String, dynamic>;
                String docId = foodItems[index].id;
                bool isApproved = foodData['status'] == 'Approved';
                bool isRejected = foodData['status'] == 'Rejected';

                // Hide the item if rejected
                if (isRejected) return SizedBox.shrink();

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              foodData['title'] ?? 'No Title',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            ),
                            if (isApproved)
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 24),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Address: ${foodData['address'] ?? 'No Address'}',
                            style: TextStyle(fontSize: 16)),
                        Text(
                            'Description: ${foodData['desc'] ?? 'No Description'}',
                            style: TextStyle(fontSize: 16)),
                        Text('Expiry: ${foodData['expiry'] ?? 'No Expiry'}',
                            style: TextStyle(fontSize: 16)),
                        Text('Pincode: ${foodData['pincode'] ?? 'No Pincode'}',
                            style: TextStyle(fontSize: 16)),
                        Text('Quantity: ${foodData['qty'] ?? 'No Quantity'}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        if (!isApproved)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => acceptFoodRequest(docId),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                child: Text('Accept',
                                    style: TextStyle(fontSize: 16)),
                              ),
                              ElevatedButton(
                                onPressed: () => declineFoodRequest(docId),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: Text('Decline',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NGOHomeScreen()),
            (route) => false, // Removes all previous routes from the stack
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.home, color: Colors.white),
      ),
    );
  }
}

class NGOHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NGO Home')),
      body: Center(
        child: Text('Welcome to NGO Home!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: 'Food Items'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log Out'),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NGOFoodDisplayScreen()));
          }
        },
      ),
    );
  }
}
