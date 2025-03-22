import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllDonationHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference requestCollection =
        FirebaseFirestore.instance.collection('request');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: requestCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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

              return ListTile(
                title: Text(donationData['title'] ?? 'No Title'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Description: ${donationData['desc'] ?? 'No Description'}'),
                    Text('Quantity: ${donationData['qty'] ?? 'No Quantity'}'),
                    Text(
                        'Expiry: ${donationData['expiry'] ?? 'No Expiry'}'),
                    Text(
                        'Address: ${donationData['address'] ?? 'No Address'}'),
                    Text(
                        'Pincode: ${donationData['pincode'] ?? 'No Pincode'}'),
                    Text(
                        'Pickup Status : ${donationData['pickup'] ? "Picked Up" : "Not Picked Up"}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}