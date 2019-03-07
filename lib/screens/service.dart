import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/data/Service.dart' as _service;
import 'product.dart';
import 'category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => new _ServiceState();
}
//fetch service
Future<List<_service.Service>> fetchService() async {
  try {
    http.Response response =
    await http.get(Server().IPAddress + '/data/get/Service.php');
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new _service.Service.fromJson(m)).toList();
  }catch (exception) {
    print(exception.toString());
  }
}
class _ServiceState extends State<Service> {
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#18b4ed");
  Color cl_bar = HexColor("#18b4ed");
  Color cl_line_ver=HexColor("#677787");

  SharedPreferences prefs;
  int counts=0;
  _getShafe() async{
    prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('count') ?? 0);
    setState(() {
      counts = counter;
    });
  }
  initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _getShafe();
  }


  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  //bags
  bool submitting = false;
  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }



  void categoty() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            backgroundColor: cl_back,
            appBar: new AppBar(
              backgroundColor: cl_bar,
              title: const Text('Category'),
            ),
            body: makeBodyCate,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final makeBodyCate = FutureBuilder<List<_service.Service>>(
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
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context) {
                          //return new SearchList();
                          return new Product(
                            typeID: service[index].ServiceType,
                            typeName: service[index].ServiceNameEN,
                            type: "service",
                          );
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
                                new Text(service[index].ServiceNameTH,
                                  style: TextStyle(
                                      fontFamily: 'Poppins'
                                  ).copyWith(
                                      color: cl_text_pro_th,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                new Container(height: 10.0),
                                new Text(service[index].ServiceNameEN,
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
                                    width: service[index].ServiceNameEN.length
                                        .toDouble() * 7,
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
                              child: Image.network(
                                  'http://119.59.115.80/cleanmate_god_test/' +
                                      service[index].ImageFile.substring(
                                          3, service[index].ImageFile.length),
                                  width: 80.0,
                                  height: 80.0,
                                  //fit: BoxFit.fill,
                                ),
                              )
                        ),
                      ],
                    ),
                  ),
                ); /**/
              },
            ),
          );
        }
    );

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
    final topAppBar = AppBar(
      bottom: TabBar(
        tabs: [
          Tab(icon: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.network(
                'http://119.59.115.80/cleanmate_god_test/Upload/Service/Service2.png',
                fit: BoxFit.cover),
          ), text: "Dry Clean",),
          Tab(icon: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.network(
                'http://119.59.115.80/cleanmate_god_test/Upload/Service/Service1.png',
                fit: BoxFit.cover),
          ), text: "Laundry"),
          Tab(icon: SizedBox(
            height: 32.0,
            width: 32.0,
            child: Image.network(
                'http://119.59.115.80/cleanmate_god_test/Upload/Service/Service.png',
                fit: BoxFit.cover),
          ), text: "Spa Leathers",),
        ],
      ),
      title: new Text(
        "Service",
        style: new TextStyle(
            fontSize: Theme
                .of(context)
                .platform == TargetPlatform.iOS ? 17.0 : 20.0,
            fontFamily: 'Poppins'
        ),
      ),
      backgroundColor: cl_bar,
      elevation: Theme
          .of(context)
          .platform == TargetPlatform.iOS ? 0.0 : 4.0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            categoty();
          },
        )
      ],
    );
    /*return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: topAppBar,
        body: TabBarView(
          children: [
            new _service1.DryClean(),
            new _service2.Laundry(),
            new _service3.SpaLeathers(),
          ],
        ),
        bottomNavigationBar: Container(
            height: 60.0,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                    'Total: \$' + totalAmount.toString(),
                    style: TextStyle(color: cl_text_pro_th,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins')

                ),
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {},
                    elevation: 0.5,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        'Pay Now',
                        style: TextStyle(color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                    textColor: Colors.white,
                  ),
                )
              ],
            )
        ),
      ),
    );*/
    return new Scaffold(
      backgroundColor: cl_back,
      appBar: new AppBar(
        title: new Text(
          "Service",
          style: new TextStyle(
            color: HexColor("#667787"),
              fontSize: Theme
                  .of(context)
                  .platform == TargetPlatform.iOS ? 17.0 : 20.0,
              fontFamily: 'Poppins'
          ),
        ),
        elevation: Theme
            .of(context)
            .platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            color: HexColor("#667787"),
            onPressed: () {
              categoty();
            },
          ),
          /*Container(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16,right: 14),
                  child: InkResponse(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>Cart()));
                    },
                    child: Icon(Icons.shopping_cart),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    child: Text((counts > 0) ? counts.toString() : "",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ),*/

        ],
      ),
      body: makeBodyCate,
    );
  }
}

