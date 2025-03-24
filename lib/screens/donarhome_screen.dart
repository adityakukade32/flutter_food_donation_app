import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'donar_screen.dart';
import 'donation_history.dart';
import 'signin_screen.dart';
 // Import your SignInScreen

class DonarHomeScreen extends StatelessWidget {
  const DonarHomeScreen({super.key});

  void _navigateToDonarScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonarScreen()),
    );
  }

  void _logout(BuildContext context) {
    // Navigate to the SignInScreen and remove all previous routes
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('ngo');
    final CollectionReference requestCollection =
        FirebaseFirestore.instance.collection('request');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Waste Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Donor Profile
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  "Hi Donor",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("You are a Donor, you can create requests"),
              ),
            ),

            const SizedBox(height: 10),

            // Food Donation Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Food Donation",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Cooked Food"),
                        Text("Veg: 5 | Non-Veg: 5"),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("Expiration Date: 15 Feb 2023"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _navigateToDonarScreen(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Create More Donation"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Donation History
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Donation History",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllDonationHistoryScreen(),
                              ),
                            );
                          },
                          child: const Text("View All"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: requestCollection.where('pickup', isEqualTo: true).limit(2).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No recent donation history'));
                        }

                        List<QueryDocumentSnapshot> donations =
                            snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // NGOs Nearby
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NGOs Near You",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: usersCollection.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No NGOs found'));
                        }

                        return Column(
                          children: snapshot.data!.docs.map((ngo) {
                            Map<String, dynamic> ngoData =
                                ngo.data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text(ngoData['name'] ?? 'No Name'),
                              subtitle: Text('Address: ${ngoData['address'] ?? 'No Address'}'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
        onTap: (index) {
          if (index == 2) {
            _logout(context);
          }
        },
      ),
    );
  }
}
