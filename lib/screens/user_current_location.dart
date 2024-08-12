import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserCurrentLocation extends StatefulWidget {
  final double latitude;
  final double longitude;

  UserCurrentLocation({required this.latitude, required this.longitude});

  @override
  _UserCurrentLocationState createState() => _UserCurrentLocationState();
}

class _UserCurrentLocationState extends State<UserCurrentLocation> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Location'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('location_marker'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: 'Selected Location',
            ),
          ),
        },
      ),
    );
  }
}
