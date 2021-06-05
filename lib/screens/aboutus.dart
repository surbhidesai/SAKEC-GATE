import 'dart:async';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'info.dart';

const phone = '+919326931126';
const email ='nsd@sakec.ac.in';
class Aboutus extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[200],
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Contact US"),
          shape: CustomShapeBorder(),
        ),


        body:ListView(

          children: <Widget>[

            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top:100,right:50),
                  child:Text("\nSAKEC GATE",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                  ),),
                SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.teal.shade700,
                  ),
                ),
                InfoCard(
                  text: phone,
                  icon: Icons.phone,
                  onPressed: () async{
                    String removeSpaceFromPhoneNumber = phone.replaceAll(new RegExp(r"\s+\b/\b\s"),"");
                    final phoneCall = 'tel:$removeSpaceFromPhoneNumber';
                    if(await launcher.canLaunch(phoneCall)){
                      await launcher.launch(phoneCall);

                    }
                    else{
                      print('Error phone');
                    }
                  },

                ),
                InfoCard(
                  text: email,
                  icon: Icons.email_rounded,
                  onPressed: () async {
                    final emailAddress = 'mailto:$email';
                    if (await launcher.canLaunch(emailAddress)) {
                      await launcher.launch(emailAddress);
                    }
                    else{
                      print('Error');
                    }
                  },

                ),
                Container(
                  padding: EdgeInsets.only(right:100,left: 100),
                  child:Text("\n\CONTACT US\n",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                ),
                Container(

                    decoration: new BoxDecoration(
                        color: Colors.white, boxShadow: [
                      new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,

                      ),
                    ]),
                    child: InkWell(

                      onTap: () {   MapsLauncher.launchQuery("Shah & Anchor Kutchhi Engineering College");},
                      child: Container(


                        child: Image.asset('assets/map.jpg',
                          width: 500.0, height: 200.0,
                        ),
                      ),
                    )

                ),
              ],),],));
  }}

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(19.2193853, 73.0883418);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;




//
//  void _onMapTypeButtonPressed() {
//    setState(() {
//      _currentMapType = _currentMapType == MapType.normal
//          ? MapType.satellite
//          : MapType.normal;
//    });
//  }
//
//  void _onAddMarkerButtonPressed() {
//    setState(() {
//      _markers.add(Marker(
//        // This marker id can be anything that uniquely identifies each marker.
//        markerId: MarkerId(_lastMapPosition.toString()),
//        position: _lastMapPosition,
//        infoWindow: InfoWindow(
//          title: 'Really cool place',
//          snippet: '5 Star Rating',
//        ),
//        icon: BitmapDescriptor.defaultMarker,
//      ));
//    });
//  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
            title: Text('Contact Us'),
            backgroundColor: Colors.green[700],
            leading: IconButton(icon:Icon(Icons.arrow_back),
              //onPressed:() => Navigator.pop(context, false),
              onPressed:() => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Aboutus())),
            )
        ),
        body: Stack(

          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
//            Padding(
//              padding: const EdgeInsets.all(16.0),
//              child: Align(
//                alignment: Alignment.topRight,
//                child: Column(
//                  children: <Widget> [
//                    FloatingActionButton(
//                      onPressed: _onMapTypeButtonPressed,
//                      materialTapTargetSize: MaterialTapTargetSize.padded,
//                      backgroundColor: Colors.green,
//                      child: const Icon(Icons.map, size: 36.0),
//                    ),
//                    SizedBox(height: 16.0),
//                    FloatingActionButton(
//                      onPressed: _onAddMarkerButtonPressed,
//                      materialTapTargetSize: MaterialTapTargetSize.padded,
//                      backgroundColor: Colors.green,
//                      child: const Icon(Icons.add_location, size: 36.0),
//                    ),
//                  ],
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {

    final double innerCircleRadius = 150.0;

    Path path = Path();
    path.lineTo(0, rect.height);
    path.quadraticBezierTo(rect.width / 2 - (innerCircleRadius / 2) - 30, rect.height + 15, rect.width / 2 - 75, rect.height + 50);
    path.cubicTo(
        rect.width / 2 - 40, rect.height + innerCircleRadius - 40,
        rect.width / 2 + 40, rect.height + innerCircleRadius - 40,
        rect.width / 2 + 75, rect.height + 50
    );
    path.quadraticBezierTo(rect.width / 2 + (innerCircleRadius / 2) + 30, rect.height + 15, rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}
