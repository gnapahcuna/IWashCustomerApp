import 'package:flutter/material.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
class ProfileCart extends StatefulWidget {
  @override
  _ProfileCartState createState() => new _ProfileCartState ();
}
class _ProfileCartState extends State<ProfileCart> {
  Color cl_back = HexColor("#e9eef4");
  Color cl_card = HexColor("#ffffff");
  Color cl_text_pro_th = HexColor("#667787");
  Color cl_text_pro_en = HexColor("#989fa7");
  Color cl_cart = HexColor("#18b4ed");
  Color cl_bar = HexColor("#18b4ed");
  Color cl_line_ver = HexColor("#677787");

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      backgroundColor: cl_back,
      body: Text('Profile'),
    );
  }
}