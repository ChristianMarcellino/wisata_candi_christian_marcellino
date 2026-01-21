import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/helpers/database_helper.dart';
import 'package:wisata_candi/screen/sign_in_screen.dart';
import 'package:wisata_candi/widget/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;
  String _imageFile = '';
  final picker = ImagePicker();
  TextEditingController? _fullnameController = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      prefs.setString('profileImage', pickedFile.path);
      setState(() {
        _imageFile = pickedFile.path;
      });
    }
  }

  void changeName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Name'),
          content: TextField(
            controller: _fullnameController,
            decoration: InputDecoration(hintText: "Enter your new full name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('fullName', _fullnameController!.text);
                setState(() {
                  fullName = _fullnameController!.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? '';
      userName = prefs.getString('username') ?? '';
      isSignedIn = prefs.getBool('isSignedIn') ?? false;
      _imageFile = prefs.getString("profileImage") ?? '';
      favoriteCandiCount = 0;
      _fullnameController = TextEditingController(text: fullName);
    });
    final dbHelper = DatabaseHelper();
    final favoriteCandis = await dbHelper.getFavoriteCandi();
    setState(() {
      favoriteCandiCount = favoriteCandis.length;
    });
  }

  void signIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', false);

    setState(() {
      isSignedIn = false;
      fullName = "";
      userName = "";
      favoriteCandiCount = 0;
      _imageFile = "";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil Sign Out'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                "Image Source",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined),
              title: Text("Gallery"),
              onTap: () {
                Navigator.of(context).pop(_getImage(ImageSource.gallery));
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_outlined),
              title: Text("Camera"),
              onTap: () {
                Navigator.of(context).pop(_getImage(ImageSource.camera));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _fullnameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.lightBlue[100],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.lightBlue,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: _imageFile.isNotEmpty
                                ? kIsWeb
                                      ? NetworkImage(_imageFile)
                                      : FileImage(File(_imageFile))
                                : AssetImage('images/placeholder_image.png'),
                            radius: 50,
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: _showPicker,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple[50],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.lock,
                  label: 'Pengguna',
                  value: userName,
                  iconColor: Colors.amber,
                ),
                SizedBox(height: 4),
                Divider(color: Colors.grey),
                SizedBox(height: 4),

                ProfileInfoItem(
                  icon: Icons.person,
                  label: 'Nama',
                  value: fullName,
                  showEditIcon: isSignedIn,
                  onEditPressed: () {
                    changeName();
                  },
                  iconColor: Colors.blue,
                ),
                SizedBox(height: 4),
                Divider(color: Colors.grey),
                SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.favorite,
                  label: 'Favorit',
                  value: favoriteCandiCount > 0
                      ? '$favoriteCandiCount'
                      : 'Belum Ada Candi Favorit',
                  iconColor: Colors.red,
                ),
                SizedBox(height: 4),
                Divider(color: Colors.grey),
                SizedBox(height: 20),
                isSignedIn
                    ? TextButton(onPressed: signOut, child: Text('Sign Out'))
                    : TextButton(onPressed: signIn, child: Text('Sign in')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
