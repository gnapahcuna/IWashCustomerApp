import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/screens/category.dart';
import 'package:cleanmate_customer_app/screens/product_category.dart';
import 'package:cleanmate_customer_app/screens/product_service.dart';
import 'package:flutter/material.dart';
import 'package:cleanmate_customer_app/HomeScreen.dart' as _home_page;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  BuildContext mContext;
  Home({
    Key key,
    @required this.mContext,
  }) : super(key: key);
  @override
  _HomeState createState() => new _HomeState();
}
class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = (size.height * 35) / 100;
    //final double itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  //return new SearchList();
                  return new TabbedAppBarService();
                },
              ),
            );
            /*Navigator.of(widget.mContext)
                .push(
                new MaterialPageRoute(builder: (context) => TabbedAppBarService()))
                .whenComplete(_getRequests);*/
            //_clearShafe();

          },
          child: Container(
            //height: 120.0,
            child: new Stack(
              children: <Widget>[
                Container(
                  height: itemHeight,
                  margin: new EdgeInsets.only(left: 12.0,right: 12.0,top: 4.0),
                  decoration: new BoxDecoration(
                    color: HexColor("#ffffff"),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(0.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    constraints: new BoxConstraints.expand(),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(height: 4.0),
                        new Text("บริการ",
                          style: TextStyle(
                              fontFamily: 'Poppins'
                          ).copyWith(
                              color: cl_text_pro_th,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        new Container(height: 10.0),
                        new Text("test1",
                          style: TextStyle(
                              fontFamily: 'Poppins'
                          ).copyWith(
                              color: cl_text_pro_en,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w400
                          ).copyWith(
                              fontSize: 12.0
                          ),
                        ),
                        new Container(
                            margin: new EdgeInsets.symmetric(vertical: 8.0),
                            height: 2.0,
                            width: 50.0,
                            color: new Color(0xff00c6ff)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  //return new SearchList();
                  return new TabbedAppBarCategory();
                },
              ),
            );
          },
          child: Container(
            child: new Stack(
              children: <Widget>[
                Container(
                  height: itemHeight,
                  margin: new EdgeInsets.only(left: 12.0,right: 12.0,top: 4.0),
                  decoration: new BoxDecoration(
                    color: HexColor("#ffffff"),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(0.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    constraints: new BoxConstraints.expand(),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(height: 4.0),
                        new Text("หมวดหมู่",
                          style: TextStyle(
                              fontFamily: 'Poppins'
                          ).copyWith(
                              color: cl_text_pro_th,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        new Container(height: 10.0),
                        new Text("test1",
                          style: TextStyle(
                              fontFamily: 'Poppins'
                          ).copyWith(
                              color: cl_text_pro_en,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w400
                          ).copyWith(
                              fontSize: 12.0
                          ),
                        ),
                        new Container(
                            margin: new EdgeInsets.symmetric(vertical: 8.0),
                            height: 2.0,
                            width: 50.0,
                            color: new Color(0xff00c6ff)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}