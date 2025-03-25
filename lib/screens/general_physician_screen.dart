import 'package:flutter/material.dart';

class GeneralPhysicianScreen extends StatelessWidget {
  final List<Map<String, String>> doctors = [
    {
      "name": "Dr. Aarti Sharma",
      "phone": "+91 9876543210",
      "cost": "₹500"
    },
    {
      "name": "Dr. Rajesh Mehta",
      "phone": "+91 9876543220",
      "cost": "₹700"
    },
    {
      "name": "Dr. Priya Nair",
      "phone": "+91 9876543230",
      "cost": "₹600"
    },
    {
      "name": "Dr. Sandeep Joshi",
      "phone": "+91 9876543240",
      "cost": "₹550"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nearby General Physicians"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.local_hospital, color: Colors.teal),
                title: Text(
                  doctors[index]["name"]!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text("Phone: ${doctors[index]["phone"]}"),
                    SizedBox(height: 5),
                    Text("Consultation Cost: ${doctors[index]["cost"]}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
