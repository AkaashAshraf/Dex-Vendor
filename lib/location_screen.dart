import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'globals.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class ProductLocation extends StatefulWidget {
  final String from;
  final LatLng latLng;
  ProductLocation({this.from, this.latLng}) : super();

  final String title = "Maps Demo";

  @override
  ProductLocationState createState() => ProductLocationState(latLng);
}

class ProductLocationState extends State<ProductLocation> {
  LatLng latLng;
  final Set<Marker> _markers = {};
  var title;
  var location = new Location();
  Completer<GoogleMapController> _controller = Completer();

  ProductLocationState(LatLng latLng);

  Future _getLocation() async {
    LocationData loc;
    var location = new Location();
    try {
      loc = await location.getLocation();
      latitude = loc.latitude;
      longitude = loc.longitude;
      setState(() {
        lastMapPosition = LatLng(latitude, longitude);
      });
      _goToMyLoction();
    } catch (e) {
      print(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      latitude = position.target.latitude;
      longitude = position.target.longitude;
    });
  }

  Future<void> _goToMyLoction() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  @override
  void initState() {
    super.initState();
    if (widget.latLng != null) {
      _kLake = CameraPosition(
          bearing: 0.0,
          target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
          zoom: 13.4746);
    } else {
      _kLake =
          CameraPosition(bearing: 0.0, target: LatLng(0, 0), zoom: 13.4746);
    }
    if (widget.from == "order" || widget.latLng != null) {
      latitude = widget.latLng.latitude;
      longitude = widget.latLng.longitude;
      _markers.add(Marker(
        markerId: MarkerId('Customer'),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
    } else {
      _getLocation();
    }
  }

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 2.4746,
  );

  CameraPosition _kLake = CameraPosition(target: LatLng(0, 0));

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ContainerResponsive(
                child: GoogleMap(
                  scrollGesturesEnabled: true,
                  markers: widget.from == 'order' || widget.latLng != null
                      ? _markers
                      : Set(),
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition:
                      widget.from == "order" || widget.latLng != null
                          ? _kLake
                          : _kGooglePlex,
                  onCameraMove: widget.from == "order" ? null : _onCameraMove,
                  onMapCreated: (GoogleMapController controller) async {
                    var loc = widget.from == "order" || widget.latLng != null
                        ? _kLake
                        : _kGooglePlex;
                    GoogleMapController controller = await _controller.future;
                    controller
                        .animateCamera(CameraUpdate.newCameraPosition(loc));
                  },
                ),
              ),
              widget.from == "order"
                  ? Container()
                  : Align(
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.location_solid,
                        color: Color(0xff34C961),
                        size: 30,
                      )),
              widget.from == "order"
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            lastMapPosition = LatLng(latitude, longitude);
                            locationSelected = true;
                            lat = latitude;
                            lang = longitude;
                          });
                          Navigator.of(context).pop(true);
                        },
                        child: ContainerResponsive(
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: Color(0xff34C961),
                          ),
                          child: Center(
                              child: TextResponsive(
                            'تاكيد الموقع',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
