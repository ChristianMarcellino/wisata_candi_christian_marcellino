import 'package:flutter/material.dart';

class detailScreen extends StatelessWidget {
  const detailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     body: Column(
      children: [
        Stack(
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                candi.ImageAsset,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),)
          ],
        )
      ],
     ), 
    );
  }
}