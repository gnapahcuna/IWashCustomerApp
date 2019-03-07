import 'package:cleanmate_customer_app/screens/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Other extends StatefulWidget {
  int CustomerID;
  String AccountName;
  Other({
    Key key,
    @required this.CustomerID,
    @required this.AccountName,
  }) : super(key: key);
  @override
  _OtherState createState() => new _OtherState(this.AccountName);
}
class _OtherState extends State<Other> {
  SharedPreferences prefs;
  String AccountName;

  _OtherState(this.AccountName);

  @override
  void initState() {
    super.initState();
  }

  CupertinoAlertDialog _createCupertinoAlertDialog(mContext) =>
      new CupertinoAlertDialog(
          title: new Text("ยืนยัน?", style: TextStyle(fontFamily: 'Poppins'),),
          content: new Text("ต้องการออกจากระบบ.",
              style: TextStyle(fontFamily: 'Poppins')),
          actions: <Widget>[

            new CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text(
                    'ยกเลิก', style: TextStyle(color: cl_text_pro_en,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'))),
            new CupertinoButton(
                onPressed: () {
                  _clearUserAcct();
                  Navigator.pop(context);
                  Navigator.of(mContext).pushReplacementNamed('/Login');
                },
                child: new Text('ยืนยัน', style: TextStyle(color: Colors.cyan,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'))),
          ]
      );

  void _showDialogLogOut(mContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _createCupertinoAlertDialog(mContext);
      },
    );
  }

  void _clearUserAcct() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove("CustomerID");
      prefs.remove("BranchID");
      prefs.remove("Firstname");
      prefs.remove("Lastname");
    });
  }

  @override
  Widget build(BuildContext context) =>
      new Container(
        child: new Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  top: 35.0, left: 38.0, right: 38.0, bottom: 22.0),
              child: new Image(
                  fit: BoxFit.cover,
                  image: new AssetImage(
                      'assets/images/logo_smart.png')),
            ),
            new Container(
                margin: EdgeInsets.only(left: 32, right: 32),
                height: 140.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        top: BorderSide(color: Colors.grey[300], width: 1.0),
                        bottom: BorderSide(color: Colors.grey[300], width: 1.0)
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("บัญชีของฉัน",
                                      style: TextStyle(fontSize: 18.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),),)
                                ],
                              )

                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.only(right: 12.0),
                            child: Icon(
                              FontAwesomeIcons.user, color: Colors.black38,
                              size: 22,),),
                          new Text(AccountName,
                              style: TextStyle(color: Colors.black38,
                                fontSize: 16.0,)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: FlatButton(
                        onPressed: () {
                          _showDialogLogOut(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(right: 12.0, left: 22.0),
                              child: Icon(
                                FontAwesomeIcons.history, color: Colors.black38,
                                size: 22,),),
                            Text(
                              "ประวัติการทำรายการ",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black38,
                                fontSize: 16.0,),
                            ),
                          ],
                        ),),
                    )
                  ],
                )
            ),

            new Container(
                margin: EdgeInsets.only(left: 32, right: 32),
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                        top: BorderSide(color: Colors.grey[300], width: 1.0),
                        bottom: BorderSide(color: Colors.grey[300], width: 1.0)
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text("ตั้งค่า",
                                      style: TextStyle(fontSize: 18.0,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),),)
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22.0),
                      child: FlatButton(
                        onPressed: () {
                          _showDialogLogOut(context);
                        }, child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[

                          Row(
                            children: <Widget>[
                              new Padding(padding: EdgeInsets.only(right: 12.0),
                                child: Icon(FontAwesomeIcons.globeAsia,
                                  color: Colors.black38,
                                  size: 22,),),
                              new Text('ภาษาไทย',
                                  style: TextStyle(color: Colors.black38,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16.0,)),
                            ],
                          ),
                        ],
                      ),),
                    ),
                  ],
                )
            ),
            new Padding(
              padding: EdgeInsets.only(top: 10.0, left: 28.0),
              child: FlatButton(
                onPressed: () {
                  _showDialogLogOut(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(right: 12.0),
                      child: Icon(
                        FontAwesomeIcons.signOutAlt, color: cl_text_pro_en,
                        size: 22,),),
                    Text(
                      "ออกจากระบบ",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.redAccent,
                        fontSize: 16.0,),
                    ),
                  ],
                ),),
            )
          ],
        ),
      );
}