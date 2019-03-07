import 'package:flutter/material.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cleanmate_customer_app/order_infor/order_card.dart';

class Infor extends StatefulWidget {
  @override
  _InforState createState() => new _InforState ();
}
class _InforState extends State<Infor> {
  Color cl_back = HexColor("#e9eef4");
  Color cl_card = HexColor("#ffffff");
  Color cl_text_pro_th = HexColor("#667787");
  Color cl_text_pro_en = HexColor("#989fa7");
  Color cl_cart = HexColor("#18b4ed");
  Color cl_bar = HexColor("#18b4ed");
  Color cl_line_ver = HexColor("#677787");

  SharedPreferences prefs;
  int totalAmount = 0;
  int counts=0;
  List<String>itemsID = [],
      itemsName = [],
      itemsPrice = [],
      itemsImage = [],
      itemsCount = [],
      itemsColor = [];

  @override
  void initState() {
    _getShafe();
    super.initState();
  }

  _getShafe() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      itemsID = (prefs.getStringList('productID') ?? new List());
      itemsName = (prefs.getStringList('productName') ?? new List());
      itemsPrice = (prefs.getStringList('productPrice') ?? new List());
      itemsImage = (prefs.getStringList('productImage') ?? new List());
      itemsCount = (prefs.getStringList('productCount') ?? new List());
      itemsColor = (prefs.getStringList('productColor') ?? new List());

      int counter = (prefs.getInt('count') ?? 0);
      int total = (prefs.getInt('total') ?? 0);
      totalAmount = total;
      counts = counter;
    });
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*_buildAvatar(),
          _buildInfo(),*/
          _buildVideoScroller(),
        ],
      ),
    );
  }
  Widget _buildVideoScroller() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox.fromSize(
        size: Size.fromHeight(220.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemCount: itemsID.length,
          itemBuilder: (BuildContext context, int index) {
            var name = itemsName[index];
            var price = itemsPrice[index];
            var count = itemsCount[index];
            var image = itemsImage[index];
            var color = itemsColor[index];
            return OrderCard(name,price,count,image,color);
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      backgroundColor: cl_back,
        body: Container(
          child: _buildContent(),
        ),
    );
  }
}