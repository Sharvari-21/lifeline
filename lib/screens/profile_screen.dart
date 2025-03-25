import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sharvari/providers/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(languageProvider.translate('my_profile'))),
        body: Center(child: Text(languageProvider.translate('error_loading_data'))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.translate('my_profile')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(languageProvider.translate('error_loading_data')),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text(languageProvider.translate('retry')),
                  ),
                ],
              ),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String userName = userData['name'] ?? "User";
          String userEmail = user.email ?? "";

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 20, color: Colors.blue),
                          onPressed: () => _showEditNameDialog(user.uid, userName),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  Text(userEmail, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 32),
                  _buildProfileOption(icon: Icons.person_outline, title: languageProvider.translate('personal_info'), onTap: () {}),
                  _buildProfileOption(icon: Icons.settings, title: languageProvider.translate('settings'), onTap: () {}),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(languageProvider.translate('logout')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditNameDialog(String userId, String currentName) {
    TextEditingController nameController = TextEditingController(text: currentName);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.translate('edit_name')),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: languageProvider.translate('enter_new_name')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                FirebaseFirestore.instance.collection('users').doc(userId).update({'name': newName});
              }
              Navigator.pop(context);
            },
            child: Text(languageProvider.translate('save')),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
