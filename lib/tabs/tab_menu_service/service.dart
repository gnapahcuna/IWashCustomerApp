import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/data/Service.dart' as _service;
import 'package:cleanmate_customer_app/screens/product.dart';
import 'package:cleanmate_customer_app/screens/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';

import 'package:cleanmate_customer_app/screens/product_service.dart';
import 'package:cleanmate_customer_app/screens/product_category.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => new _ServiceState();
}

class _ServiceState extends State<Service> {
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#18b4ed");
  Color cl_bar = HexColor("#18b4ed");
  Color cl_line_ver=HexColor("#677787");


  @override
  Widget build(BuildContext context) {

    final makeTapBar = FutureBuilder<List<_service.Service>>(
        future: fetchService(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load.
            return new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: new Scaffold(
                  body: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                )
            );
          List<_service.Service> service = snapshot.data;
          return new Container(
            child: ListView.builder(
              itemCount: service.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Tab(icon: SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: Image.network(
                      'http://119.59.115.80/cleanmate_god_test/' +
                          service[index].ImageFile.substring(
                              3, service[index].ImageFile.length),
                      fit: BoxFit.cover),
                ), text: service[index].ServiceNameTH,
                );
              },
            ),
          );
        }
    );

    final makeMenu = Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  //return new SearchList();
                  return new TabbedAppBarService();
                },
              ),
            );
          },
          child: Container(
            height: 120.0,
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            child: new Stack(
              children: <Widget>[
                Container(
                  height: 124.0,
                  margin: new EdgeInsets.only(left: 46.0),
                  decoration: new BoxDecoration(
                    color: HexColor("#ffffff"),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
                    constraints: new BoxConstraints.expand(),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(height: 4.0),
                        new Text('บริการ',
                          style: TextStyle(
                              fontFamily: 'Poppins'
                          ).copyWith(
                              color: cl_text_pro_th,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        new Container(height: 10.0),
                        new Text("test",
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
                Container(
                    margin: new EdgeInsets.symmetric(
                        vertical: 14.0
                    ),
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: cl_cart,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.directions_car)
                    )
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
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
            height: 120.0,
            margin: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
            child: new Stack(
              children: <Widget>[
                Container(
                  height: 124.0,
                  margin: new EdgeInsets.only(left: 46.0),
                  decoration: new BoxDecoration(
                    color: HexColor("#ffffff"),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: new Container(
                    margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
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
                Container(
                    margin: new EdgeInsets.symmetric(
                        vertical: 14.0
                    ),
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: cl_cart,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.departure_board)
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return new Scaffold(
      backgroundColor: cl_back,
      body: makeMenu,
    );
  }
}

