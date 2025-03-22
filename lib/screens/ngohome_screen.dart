import 'package:flutter/material.dart';

class NgoHomeScreen extends StatefulWidget {
  @override
  _NgoHomeScreenState createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Smile Foundation'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            _buildTabSection(),
            selectedTab == 0 ? _buildMyPosts() : _buildDonorsPosts(),
            _buildFoodDonors(),
            _buildFAQsSection(),  // FAQs added at the bottom
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You are a Receiver',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoBox('500', 'Orders Received'),
            _buildInfoBox('1000', 'Points Earned'),
          ],
        ),
        SizedBox(height: 10),
        Divider(thickness: 1),
      ],
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTabSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          _buildTabItem(0, 'My Posts'),
          _buildTabItem(1, 'Donors’ Posts'),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selectedTab == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (selectedTab == index)
              Container(
                width: 40,
                height: 3,
                color: Colors.deepPurple,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPosts() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text('No posts available.', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('+ Create Food Request'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
          Divider(thickness: 1, height: 40),
        ],
      ),
    );
  }

  Widget _buildDonorsPosts() {
    return Column(
      children: [
        _buildPostItem('Donor #1 has accepted your food request'),
        _buildPostItem('Individual has accepted your food request'),
        Divider(thickness: 1, height: 40),
      ],
    );
  }

  Widget _buildPostItem(String message) {
    return ListTile(
      leading: Icon(Icons.food_bank, color: Colors.deepPurple),
      title: Text(message),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () {}, child: Text('Reject', style: TextStyle(color: Colors.red))),
          TextButton(onPressed: () {}, child: Text('Approve', style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }

  Widget _buildFoodDonors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text('Food Donors Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _buildDonorItem('Restaurant Name 1', '2.5km', '340 meals served till now'),
        _buildDonorItem('Restaurant Name 2', '3.2km', '215 meals served till now'),
        Divider(thickness: 1, height: 40),
      ],
    );
  }

  Widget _buildDonorItem(String name, String distance, String details) {
    return ListTile(
      leading: Icon(Icons.restaurant, color: Colors.deepPurple),
      title: Text(name),
      subtitle: Text('$distance\n$details'),
      trailing: ElevatedButton(
        onPressed: () {},
        child: Text('Connect'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      ),
    );
  }

  Widget _buildFAQsSection() {
    return ExpansionTile(
      title: Text('FAQs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      children: [
        _buildFAQItem('Who will pick up the food?', 'A volunteer or the NGO representative will arrange the pickup.'),
        _buildFAQItem('Can we make multiple food requests at once?', 'Yes, but approval depends on availability.'),
        _buildFAQItem('Is there a way to track my request?', 'Yes, you can track it from your profile.'),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ListTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(answer),
    );
  }

Widget _buildBottomNavBar() {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Requests'),
      BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQs'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
    selectedItemColor: Colors.deepPurple,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, // Keeps all labels visible
    onTap: (index) {
      if (index == 0) {
        // Navigate to Home
      } else if (index == 1) {
        // Navigate to Requests/Food List
      } else if (index == 2) {
        // Navigate to FAQs Section
      } else if (index == 3) {
        // Navigate to Profile Screen
      }
    },
  );

  }
}
