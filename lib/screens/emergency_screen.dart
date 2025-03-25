import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../helpers/emergency_helper.dart';  // Import the helper file

class EmergencyScreen extends StatelessWidget {
  final String adminPhoneNumber = "+917208722810"; // Replace with actual number

  final List<EmergencySymptom> symptoms = [
    EmergencySymptom(name: "Chest Pain", icon: Icons.favorite, color: Colors.red),
    EmergencySymptom(name: "Stomach Pain", icon: Icons.medical_services, color: Colors.orange),
    EmergencySymptom(name: "Brain Headache", icon: Icons.psychology, color: Colors.blue),
    EmergencySymptom(name: "Breathing Difficulty", icon: Icons.air, color: Colors.green),
    EmergencySymptom(name: "High Fever", icon: Icons.thermostat, color: Colors.deepPurple),
    EmergencySymptom(name: "Severe Injury", icon: Icons.healing, color: Colors.brown),
  ];

  Future<void> _callAdmin(BuildContext context) async {
    var status = await Permission.phone.status;

    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      await EmergencyHelper.callAdmin(adminPhoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Call permission is required!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Assistance"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Your Emergency Symptom",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _callAdmin(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Calling Admin for ${symptoms[index].name}!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: Card(
                      color: symptoms[index].color.withOpacity(0.2),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(symptoms[index].icon, size: 40, color: symptoms[index].color),
                            SizedBox(height: 10),
                            Text(symptoms[index].name, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencySymptom {
  final String name;
  final IconData icon;
  final Color color;
  EmergencySymptom({required this.name, required this.icon, required this.color});
}
