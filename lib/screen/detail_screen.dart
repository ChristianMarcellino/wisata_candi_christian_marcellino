import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';
class detailScreen extends StatelessWidget {

  final Candi placeholder;

  const detailScreen({super.key, required this.placeholder});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Column(
      children: [
        Stack(
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                placeholder.imageAsset,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100]?.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(onPressed: (){}, 
                icon: Icon(Icons.arrow_back)
                ),
              ),
            ),
          ],
        ),
        Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(placeholder.name),
                      IconButton(onPressed: (){}, 
                      icon: Icon(Icons.favorite_border)
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.place, color: Colors.red,),
                      SizedBox(width: 8,),
                      SizedBox(width: 78,
                        child: Text('Lokasi', style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                      Text(": ${placeholder.location}",)
                    ],),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.red,),
                      SizedBox(width: 8,),
                      SizedBox(width: 78,
                        child: Text('Dibangun', style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                      Text(": ${placeholder.built}",)
                    ],
                    ),
                  Row(
                    children: [
                      Icon(Icons.house, color: Colors.red,),
                      SizedBox(width: 8,),
                      SizedBox(width: 78,
                        child: Text('Tipe', style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                      Text(": ${placeholder.type}",)
                    ],
                    ),
                ],
              ),
              )
      ],
     ), 
    );
  }
}