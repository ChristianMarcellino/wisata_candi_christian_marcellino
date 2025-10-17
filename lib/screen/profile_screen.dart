import 'package:flutter/material.dart';
import 'package:wisata_candi/screen/detail_screen.dart';
import 'package:wisata_candi/data/candi_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.deepPurple, 
            ),
            Column(
              children: [
                Center(
                  child: Icon(Icons.person, size: 90,),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => DetailScreen(placeholder: candiList[0]),
                ),
              );
              }, child: Icon(Icons.house),
               )
            )
          ],
            ),
    );
  }
}