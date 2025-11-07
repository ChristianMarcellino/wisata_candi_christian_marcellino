import 'package:flutter/material.dart';

class Screen extends StatelessWidget{
  const Screen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(
        title : Text("Wawan")
      ),
      body : Row(
        children: [
          Text("Wawan"),
          SizedBox(width: 200,),
          Text("Legam")
        ],
        )
    );
  }
}