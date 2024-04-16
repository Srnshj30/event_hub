import 'package:flutter/material.dart';

class StackBoxes extends StatelessWidget{
  const StackBoxes({super.key});

  @override
  Widget build(BuildContext context) {
    
    return const Center(
      child: SingleChildScrollView(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            StackedBox(image: 'assets/placeholder_image.jpg', stackText:'Box1' ),
            SizedBox(height: 20,),
            StackedBox(image: 'assets/placeholder_image.jpg', stackText: 'Box2 '),
            SizedBox(height: 20,),
            StackedBox(image:'assets/placeholder_image.jpg' , stackText:'Box3' ),
            SizedBox(height: 13,),
            
          ],
        ),
      ),
    );
  }
}

class StackedBox extends StatelessWidget{
  const StackedBox({super.key, required this.image, required this.stackText});

  final String image;
  final String stackText;

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: (){
        //print('box is tapped');
      },
      child: Stack(
        children: [
          Container(
            width: 250,
            height: 170,
            decoration:  BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
             image:const DecorationImage(image:  AssetImage('assets/placeholder_image.jpg'), fit: BoxFit.cover,),
              
            ),
      
          ),
      
          Positioned.fill(
            child: Center(
              child: Text(stackText),
            ),
          )
        ],
      ),
    );
    
  }
}
