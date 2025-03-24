import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllDonationHistoryScreen extends StatelessWidget {
  const AllDonationHistoryScreen({super.key});

  Future<void> fetchRequestsWithPickup() async {
    CollectionReference requests = FirebaseFirestore.instance.collection('request');
print("-------------------------------00");
    try {
      QuerySnapshot querySnapshot = await requests.where('pickup', isEqualTo: true).get();
      print(querySnapshot);
      for (var doc in querySnapshot.docs) {
        print("Document ID: \${doc.id}, Data: \${doc.data()} ");
      }
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference requestCollection =
        FirebaseFirestore.instance.collection('request');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Histosssry'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestCollection.where('pickup', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No donation history found'));
          }

          List<QueryDocumentSnapshot> donations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> donationData =
                  donations[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
  Text(
    donationData['title'] ?? 'No Title',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  SizedBox(height: 4),
  Text('Description: ${donationData["desc"] ?? "No Description"}'),
  Text('Quantity: ${donationData["qty"] ?? "No Quantity"}'),
  Text('Expiry: ${donationData["expiry"] ?? "No Expiry"}'),
  Text('Address: ${donationData["address"] ?? "No Address"}'),
  Text('Pincode: ${donationData["pincode"] ?? "No Pincode"}'),
  Text('Status: ${donationData["status"] ?? "No Status"}'),
  Text(
    'Pickup Status: ${donationData["pickup"] == true ? "Picked Up" : "Not Picked Up"}',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: donationData["pickup"] == true ? Colors.green : Colors.red,
    ),
  ),
],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}
