import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';
class detailScreen extends StatelessWidget {

  final Candi placeholder;

  const detailScreen({super.key, required this.placeholder});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SingleChildScrollView(
      Column(
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
                crossAxisAlignment : CrossAxisAlignment.start,
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
                    SizedBox(height : 16),
                    Divider(color : Colors.deepPurple.shade100),
                    SizedBox(height : 16),
                ],
              ),
              ),
              Padding(
                padding : const EdgeInsets.all(15),
                child : Column(
                  crossAxisAlignment : CrossAxisAlignment.start,
                  children : [
                    Divider(color : Colors.deepPurple.shade100),
                    Text("Galeri", style : TextStyle(
                      fontSize : 16, fontWeight : FontWeight.bold,
                    )),
                    SizedBox(height : 10),
                    SizedBox(
                      height : 100, 
                      child : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount : placeholder.imageUrls.length,
                        itemBuilder : (context, index){
                          return Padding(
                            padding : EdgeInsets.only(right : 8),
                            child : GestureDetector(
                              onTap : () {},
                              child : Container(
                                decoration : BoxDecoration(
                                  borderRadius : BorderRadius.circular(12),
                                  border : Border.all(
                                    color : Colors.deepPurple.shade100,
                                    width : 2,
                                  ),
                                ),
                                child : ClipRRect(
                                  borderRadius : BorderRadius.circular(10),
                                  child : CachedNetworkImage(
                                    imageUrl : placeholder.imageUrls[index],
                                    height : 120,
                                    width : 120,
                                    fit : BoxFit.cover,
                                    placeholder : (context, url) => Container(
                                      height : 120,
                                      width : 120,
                                      color : Colors.deepPurple[50],
                                    ),
                                    errorWidget : (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                              )
                            )
                            )
                        })),
                    SizedBox(height : 4),
                    Text("Tap untuk memperbesar", style : TextStyle(
                      fontSize : 12, color : Colors.black54
                    )),
                  ]
                )
              )
      ],
     ), 
     ),
    );
  }
}