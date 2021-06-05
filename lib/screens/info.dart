import 'package:flutter/material.dart';
class InfoCard extends StatelessWidget{
final String text;
final IconData icon;
Function onPressed;

  InfoCard({@required this.text, @required this.icon , this.onPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
     onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 30.0),
        child: ListTile(
          leading: Icon(
            icon,
            color:Colors.teal,
          ),
          title: Text(
            text,
            style:TextStyle(
                  fontSize: 20.0,
              color: Colors.teal,

            )
          ),
        ),
      ),
    );
  }
}