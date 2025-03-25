import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'nearby_hospitals_location.dart';
import 'emergency_screen.dart';
import 'general_physician_screen.dart'; // ✅ Imported the General Physician screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCity = "Mumbai"; // Default city changed to Mumbai
  final List<String> cities = ["Bangalore", "Pune", "Nashik", "Mumbai"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.white),
            SizedBox(width: 5),
            DropdownButton<String>(
              value: selectedCity,
              dropdownColor: Colors.indigo,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              underline: SizedBox(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue!;
                });
              },
              items: cities.map<DropdownMenuItem<String>>((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for clinics",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppointmentCard(
                      title: "Emergency",
                      imagePath: "assets/images/emergency.jpg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmergencyScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppointmentCard(
                      title: "See Nearby Hospitals",
                      imagePath: "assets/images/hospital.jpg",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NearbyHospitalsScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Find a Doctor for your Health Problem",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: doctorCategories.length,
                itemBuilder: (context, index) {
                  return DoctorCategoryButton(doctorCategories[index]);
                },
              ),
              SizedBox(height: 20),
              Text(
                "Featured services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Affordable Procedures by Expert Doctors",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const AppointmentCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCategoryButton extends StatelessWidget {
  final DoctorCategory category;
  const DoctorCategoryButton(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.title == "General Physician") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GeneralPhysicianScreen()), // ✅ Added Routing
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selected: ${category.title}")),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(category.icon, color: Colors.indigo, size: 30),
          ),
          SizedBox(height: 5),
          Flexible(
            child: Text(
              category.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCategory {
  final String title;
  final IconData icon;
  DoctorCategory({required this.title, required this.icon});
}

List<DoctorCategory> doctorCategories = [
  DoctorCategory(title: "General Physician", icon: Icons.local_hospital),
  DoctorCategory(title: "Skin & Hair", icon: Icons.face),
  DoctorCategory(title: "Women's Health", icon: Icons.pregnant_woman),
  DoctorCategory(title: "Dental Care", icon: Icons.medical_services),
  DoctorCategory(title: "Child Specialist", icon: Icons.child_care),
  DoctorCategory(title: "Ear, Nose, Throat", icon: Icons.hearing),
  DoctorCategory(title: "Mental Wellness", icon: Icons.psychology),
  DoctorCategory(title: "More", icon: Icons.more_horiz),
];
