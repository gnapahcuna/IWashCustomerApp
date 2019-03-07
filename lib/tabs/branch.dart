import 'package:carousel_pro/carousel_pro.dart';
import 'package:cleanmate_customer_app/screens/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Branch extends StatefulWidget {
  @override
  _BranchState createState() => new _BranchState();
}
class _BranchState extends State<Branch> {
  List<NetworkImage> arrImg = new List();
  @override
  void initState() {
    super.initState();
    arrImg.add(new NetworkImage('http://119.59.115.80/cleanmate_god_test/Upload/Brochure/S__82739290.jpg'));
    arrImg.add(new NetworkImage('http://119.59.115.80/cleanmate_god_test/Upload/Brochure/S__81002521.jpg'));

  }


  @override
  Widget build(BuildContext context){
    var size = MediaQuery
        .of(context)
        .size;
    final double itemHeight = (size.height * 80) / 100;
    //final double itemWidth = size.width / 2;

    return Container(
      child: new SingleChildScrollView(
        child: new Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Container(
              //margin: EdgeInsets.only(left: 4.0,right: 4.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey[300], width: 1.0),
                        bottom: BorderSide(color: Colors.grey[300], width: 1.0)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left:12.0,top: 8.0,bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Icon(FontAwesomeIcons.gift,color: Colors.cyan,),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("panel 1",
                                      style: TextStyle(fontSize: 16.0, color: Colors.deepOrange,fontWeight: FontWeight.bold),),)
                                ],
                              )

                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            new Container(
              //margin: EdgeInsets.only(left: 4.0,right: 4.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: Colors.grey[300], width: 1.0),
                        bottom: BorderSide(color: Colors.grey[300], width: 1.0)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left:12.0,top: 8.0,bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Icon(FontAwesomeIcons.gift,color: Colors.cyan,),
                                  new Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("โปรโมชั่น",
                                      style: TextStyle(fontSize: 16.0, color: Colors.deepOrange,fontWeight: FontWeight.bold),),)
                                ],
                              )

                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            new SizedBox(
              height: itemHeight,
              width: double.infinity,
              child: new Carousel(
                boxFit: BoxFit.contain,
                images: arrImg,
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(seconds: 1),
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: cl_text_pro_th,
                indicatorBgPadding: 2.0,
                dotBgColor: Colors.transparent,
                //borderRadius: true,
              ),
            ),

          ],
        ),
      ),
    );
  }
}