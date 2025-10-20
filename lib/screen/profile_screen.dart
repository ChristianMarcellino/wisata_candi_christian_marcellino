import 'package:flutter/material.dart';
import 'package:wisata_candi/screen/detail_screen.dart';
import 'package:wisata_candi/data/candi_data.dart';
import 'package:wisata_candi/widget/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = "Wawan Setiawan";
  String userName = "Wawan HekerTzy";
  int favCandiCount = 0;

  void signIn() {
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  void signOut() {
    setState(() {
      isSignedIn = !isSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              'images/placeholder_image.png',
                            ),
                            radius: 50,
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple[80],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.deepPurple.shade100),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      ProfileInfoItem(
                        icon: Icons.lock,
                        label: "Pengguna",
                        value: userName,
                        iconColor: Colors.yellow,
                        onEditPressed: (){
                          debugPrint("wawan");
                        },
                        showEditIcon: true,
                      ),
                      SizedBox(height: 18),
                      ProfileInfoItem(
                        icon: Icons.person,
                        label: "Nama",
                        value: fullName,
                        iconColor: Colors.blueAccent,
                        onEditPressed: (){
                          debugPrint("wawan");
                        },
                        showEditIcon: true,
                      ),
                      SizedBox(height: 18),
                      ProfileInfoItem(
                        icon: Icons.favorite,
                        label: "Favorit",
                        value: favCandiCount == 0 ? "Tidak ada candi favorit" : favCandiCount.toString(),
                        iconColor: Colors.redAccent,
                        onEditPressed: (){
                          debugPrint("wawan");
                        },
                        showEditIcon: true,
                      ),
                      isSignedIn
                          ? TextButton(
                              onPressed: signOut,
                              child: Text("Sign Out"),
                            )
                          : TextButton(
                              onPressed: signIn,
                              child: Text("Sign In"),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          DetailScreen(placeholder: candiList[0]),
                    ),
                  );
                },
                child: Icon(Icons.house),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
