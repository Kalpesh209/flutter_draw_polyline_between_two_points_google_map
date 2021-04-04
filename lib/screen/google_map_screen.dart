import 'package:flutter/material.dart';
import 'package:flutter_draw_polyline_between_coordinates_google_map/common/color_constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
Title:GoogleMapScreen
Purpose:GoogleMapScreen
Created By:Kalpesh Khandla
*/

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({Key key}) : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  double height, width;
  int amountTxt = 390;
  String orderNo = "4578178";
  String restaurantName = "FoodiePie Restaurants";
  String addressTxt = "B-2024, Silver Corner, Ahmedabad";
  GoogleMapController mapController;

  double _originLatitude = 23.0284, _originLongitude = 72.5068;

  double _destLatitude = 23.1013, _destLongitude = 72.5407;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [
    LatLng(23.0284, 72.5068),
    LatLng(23.0504, 72.4991),
    LatLng(23.1013, 72.5407),
  ];
  PolylinePoints polylinePoints = PolylinePoints();
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  String googleAPiKey = "YOUR_GOOGLE_API_KEY";

    void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      visible: true,
      color: ColorConstants.kGreyTextColor.withOpacity(0.5),
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    markers[markerId] = marker;
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [
          PolylineWayPoint(
            location: "Sabo, Yaba Lagos Nigeria",
          ),
        ]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    _addMarker(
      LatLng(_destLatitude, _destLongitude),
      "destination",
      BitmapDescriptor.defaultMarker,
    );
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_originLatitude, _originLongitude),
                zoom: 12,
              ),
              myLocationEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: _onMapCreated,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 15,
                ),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorConstants.kWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: ColorConstants.kBlackColor,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                  color: ColorConstants.kWhiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order ID: #" + orderNo,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 14,
                                  fontFamily: "Poppins Regular",
                                  color: ColorConstants.kTextColor,
                                ),
                          ),
                          Text(
                            "Total Payment: " +
                                "\u{20B9}" +
                                amountTxt.toString(),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 14,
                                  fontFamily: "Poppins Regular",
                                  color: ColorConstants.kTextColor,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                        color: ColorConstants.kGreyTextColor.withOpacity(0.2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kGreenTextColor,
                                  borderRadius: BorderRadius.circular(8 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kDividerColor,
                                  borderRadius: BorderRadius.circular(3 / 2),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: ColorConstants.kGreenTextColor,
                                  borderRadius: BorderRadius.circular(8 / 2),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pickup Location",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontFamily: "Poppins Regular",
                                      fontSize: 14,
                                      color: ColorConstants.kHintTextColor,
                                    ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                restaurantName,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: "Poppins Medium",
                                      color: ColorConstants.kTextColor,
                                    ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Drop off Location",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontSize: 14,
                                      fontFamily: "Poppins Regular",
                                      color: ColorConstants.kHintTextColor,
                                    ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                addressTxt,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: "Poppins Medium",
                                      color: ColorConstants.kTextColor,
                                    ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
