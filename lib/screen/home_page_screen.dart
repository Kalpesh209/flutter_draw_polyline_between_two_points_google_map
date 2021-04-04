import 'package:flutter/material.dart';
import 'package:flutter_draw_polyline_between_coordinates_google_map/common/color_constants.dart';
import 'package:flutter_draw_polyline_between_coordinates_google_map/screen/google_map_screen.dart';
import 'package:flutter_draw_polyline_between_coordinates_google_map/widgets/text_button_widget.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButtonWidget(
            textColor: ColorConstants.kWhiteColor,
            btnOntap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoogleMapScreen(),
                ),
              );
            },
            btnTxt: "Go to Map",
            backColor: ColorConstants.kBlackColor,
          ),
        ),
      ),
    );
  }
}
