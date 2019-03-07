import 'package:badges/badges.dart';
import 'package:cleanmate_customer_app/HomeScreen.dart';
import 'package:cleanmate_customer_app/tabs/home.dart';
import 'package:cleanmate_customer_app/tabs/tab_menu_service/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/data/Service.dart' as _service;
import 'package:cleanmate_customer_app/data/Product.dart' as _product;
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:intl/intl.dart';
import 'package:money/money.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cleanmate_customer_app/alert/messageAlert.dart' as _message;

class FavoriteJson {
  String ProductID;
  String BranchGroupID;
  FavoriteJson(this.ProductID,this.BranchGroupID);
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["ProductID"] = ProductID;
    map["BranchGroupID"] = BranchGroupID;
    return map;
  }
}
class FavoriteProduct extends StatefulWidget {
  @override
  _FavoriteProductState createState() => new _FavoriteProductState();
}
class _FavoriteProductState extends State<FavoriteProduct> {

  Color cl_bar = HexColor("#18b4ed");
  Color cl_back = HexColor("#e9eef4");
  Color cl_card = HexColor("#ffffff");
  Color cl_text_pro_th = HexColor("#1d313a");
  Color cl_text_pro_en = HexColor("#667787");
  Color cl_cart = HexColor("#e64d3f");
  Color cl_line_ver = HexColor("#677787");
  Color cl_favorite = HexColor("#e44b3b");

  SharedPreferences prefs;
  int totalAmount = 0;
  int counts = 0;
  int BranchGroupID;

  List<String> proID, proCount, isFavorite;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> itemsServiceType=[];

  //fetch product
  Future<List<_product.Product>> fetchProduct() async {
    List<Map> productOptionJson = new List();
    for (int i = 0; i < isFavorite.length; i++) {
      FavoriteJson carJson = new FavoriteJson(
        isFavorite[i].toString(),
        BranchGroupID.toString(),
      );
      productOptionJson.add(carJson.TojsonData());
    }
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var bodyJson = json.encode({
      "Favorite": productOptionJson
    });
    try {
      http.Response response;
      List responseJson;
      response =
      await http.post(
          Server().IPAddress + '/data/get/pro/ProductFavorite.php',
          body: bodyJson, headers: headers);
      responseJson = json.decode(response.body);
      return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
    } catch (exception) {
      print(exception.toString());
    }
  }
  void showInSnackBar(String value,Color color,bool error) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Container(
        height: 40.0,
        child: Center(
          child: new Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: "Poppins"),
          ),
        ),
      ),
      backgroundColor: color,
      duration: Duration(seconds: 2),
      action: !error?new SnackBarAction(
        textColor: Colors.deepOrange,
        label: 'ไปที่ตะกร้า',
        onPressed: () {
          if (totalAmount == 0) {
            //_showDialog('เตือน!', 'คุณยังไม่มีสินค้าในตะกร้า.');
          } else {
            Navigator.of(context)
                .push(
                new MaterialPageRoute(
                    builder: (context) => Cart()))
                .whenComplete(_getRequests);
            //_clearShafe();
          }
        },
      ):null,
    ));
  }

  getTotalAmount(price, proID, proName, image, color, serviceType, categoryID,
      rating) {
    setState(() {
      print(serviceType.toString()+", "+itemsServiceType.contains("3").toString());
      if(itemsServiceType.length<=0){
        _putCount(price,proID,proName,image,color,serviceType,categoryID,rating);
        showInSnackBar("เพิ่ม "+proName+" ลงตะกร้าแล้ว.",cl_text_pro_th,false);
      }else if(itemsServiceType.contains("3")==false){
        if(serviceType==3){
          showInSnackBar("ไม่สามารถเลือกสินค้าที่วันนัดรับไม่ตรงกันได้!",Colors.red,true);
        }else{
          _putCount(price,proID,proName,image,color,serviceType,categoryID,rating);
          showInSnackBar("เพิ่ม "+proName+" ลงตะกร้าแล้ว.",cl_text_pro_th,false);
        }
      }else if(itemsServiceType.contains("3")==true){
        if(serviceType==3){
          _putCount(price,proID,proName,image,color,serviceType,categoryID,rating);
          showInSnackBar("เพิ่ม "+proName+" ลงตะกร้าแล้ว.",cl_text_pro_th,false);
        }else{
          showInSnackBar("ไม่สามารถเลือกสินค้าที่วันนัดรับไม่ตรงกันได้!",Colors.red,true);
        }
      }

    });
  }

  _putCount(price, productID, productName, images, color, serviceType,
      categoryID, rating) async {
    _initPref();
    int counter = (prefs.getInt('count') ?? 0) + 1;
    int total = (prefs.getInt('total') ?? 0) + price;
    counts = counter;
    totalAmount = total;
    await prefs.setInt('count', counter);
    await prefs.setInt('total', totalAmount);


    List<String> itemsID = (prefs.getStringList('productID') ?? new List());
    List<String> itemsCount = (prefs.getStringList('productCount') ??
        new List());
    List<String> itemsService = (prefs.getStringList('productServiceType') ??
        new List());
    int index = itemsID.indexOf(productID.toString());
    if (index != -1) {
      int counts = int.parse(itemsCount[index]) + 1;
      itemsCount[index] = counts.toString();
    } else {
      itemsID.add(productID.toString());
      itemsCount.add(1.toString());
      itemsService.add(serviceType.toString());
    }
    await prefs.setStringList('productID', itemsID);
    await prefs.setStringList('productCount', itemsCount);
    await prefs.setStringList('productServiceType', itemsService);

    proID = itemsID;
    proCount = itemsCount;
    itemsServiceType=itemsService;
  }

  _getShafe() async {
    prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('count') ?? 0);
    int total = (prefs.getInt('total') ?? 0);
    List<String> arr1 = (prefs.getStringList('productID') ?? new List());
    List<String> arr2 = (prefs.getStringList('productCount') ?? new List());
    List<String> arr4 = (prefs.getStringList('favorit') ?? new List());

    List<String> arr_ser=(prefs.getStringList('productServiceType')??new List());
    BranchGroupID = (prefs.getInt("BranchGroupID") ?? 0);

    setState(() {
      counts = counter;
      totalAmount = total;
      proID = arr1;
      proCount = arr2;
      isFavorite = arr4;
      itemsServiceType=arr_ser;
    });
  }

  _clearShafe() async {
    setState(() {
      _initPref();
      prefs.clear();
      counts = 0;
      totalAmount = 0;
    });
  }

  _initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    //print("state");
    _getShafe();
    super.initState();
  }

  @override
  void dispose() {
    //print("dispose");
    super.dispose();
  }

  //test search
  String appTitle;
  Widget appBarTitle;
  Icon actionIcon = new Icon(Icons.search, color: HexColor("#667787"),);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  String _searchText = "";


  setItemClicked(productID) {
    //print(proID.contains(productID.toString()));
    return Text(
      "${proID.contains(productID.toString()) == true && proID.length > 0
          ? 'x ' + proCount[proID.indexOf(productID.toString())].toString()
          : ''}",
      style: TextStyle(
          /*fontSize: 16.0,*/ color: Colors.white, fontFamily: 'Poppins'),);
  }

  setItemFavorite(productID) {
    return isFavorite.contains(productID.toString()) == true &&
        isFavorite.length > 0
        ? Icon(Icons.favorite, color: Colors.red,) :
    Icon(Icons.favorite_border, color: Colors.red,);
  }

  _getFavorit(productID) {
    setState(() {
      _putFavorit(productID);
    });
  }

  _putFavorit(productID) async {
    _initPref();
    print(productID.toString());
    List<String> itemsID = (prefs.getStringList('favorit') ?? new List());
    int index = itemsID.indexOf(productID.toString());
    if (index != -1) {
      itemsID.removeAt(index);
    } else {
      itemsID.add(productID.toString());
    }
    await prefs.setStringList('favorit', itemsID);

    isFavorite = itemsID;
  }

  _getRequests() async {
    //print("_getRequests");
    _getShafe();
  }

  void _showDialog() {
    _message.Message(
        'แจ้งเตือน!', 'คุณยังไม่มีรายการในตะกร้าสินค้า.', context, null, 2);
  }

  Widget ratingStack(int rating) =>
      Positioned(
        top: 0.0,
        left: 0.0,
        child: Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              color: cl_text_pro_th,
              //color: Colors.red,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0))),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                color: Colors.white,
                size: 10.0,
              ),
              SizedBox(
                width: 2.0,
              ),
              Text(
                rating.toString() + " วัน",
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              )
            ],
          ),
        ),
      );


  Widget _buildUsersList() {
    final formatter = new NumberFormat("#,###.#");
    return FutureBuilder<List<_product.Product>>(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load.
            return new MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new Scaffold(
                //backgroundColor: cl_back,
                body: Center(
                  child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.deepOrange),),
                ),
              ),
            );
          // Shows the real data with the data retrieved.
          List<_product.Product> product = snapshot.data;
          List<_product.Product> tempList = new List();
          for (int i = 0; i < product.length; i++) {
            for (int j = 0; j < isFavorite.length; j++) {
              if (product[i].ProductID == int.parse(isFavorite[j])) {
                tempList.add(product[i]);
              }
            }
          }
          product = tempList;

          var size = MediaQuery
              .of(context)
              .size;

          final double itemHeight = size.height / 3;
          final double itemWidth = size.width / 2;

          return product.length > 0 ? Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 4.0, bottom: 4.0),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight)),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      /*getTotalAmount(
                            int.tryParse(product[index].ProductPrice),
                            product[index].ProductID,
                            product[index].ProductNameTH,
                            Server().pathImageFile +
                                product[index].ImageFile
                                    .substring(
                                    3,
                                    product[index].ImageFile
                                        .length),
                            product[index].ColorCode,
                            product[index].ServiceType,
                            product[index].CategoryID,
                            (product[index].Rating * 5) / 100);*/
                    },
                    child: Container(
                      height: itemHeight/2,
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          )
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: itemHeight/3,
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            child: Image.network(
                                                Server().pathImageFile +
                                                    product[index].ImageFile
                                                        .substring(
                                                        3,
                                                        product[index]
                                                            .ImageFile
                                                            .length),
                                                fit: BoxFit.contain)
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            _getFavorit(
                                                product[index].ProductID);
                                          },
                                          child: setItemFavorite(
                                              product[index].ProductID),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                  /*margin: new EdgeInsets.symmetric(
                                          vertical: 4.0),*/
                                    height: 1.0,
                                    width: (itemWidth * 70) / 100,
                                    color: new HexColor(
                                        product[index].ColorCode)
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "${product[index].ProductNameTH.length < 13
                                      ? product[index].ProductNameTH
                                      : product[index].ProductNameTH
                                      .substring(
                                      0, 12) + '...'}",
                                  style: TextStyle(color: cl_text_pro_th,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins'),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    new StarRating(
                                        size: 15.0,
                                        rating: (product[index].Rating * 5) /
                                            100,
                                        color: Colors.yellow.shade800,
                                        borderColor: Colors.grey,
                                        starCount: 5
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "\฿${formatter.format(int.parse(
                                            product[index].ProductPrice))}",
                                        style: TextStyle(
                                            color: cl_text_pro_en,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins'),),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left:8.0,right:8.0),
                                child: Center(
                                  child: ButtonTheme(
                                    //minWidth: 80.0,
                                    height: (itemHeight*17)/100,
                                    buttonColor: Colors.cyan,
                                    splashColor: Colors.deepOrange,
                                    child: RaisedButton(
                                        onPressed: () {
                                          getTotalAmount(
                                              int.tryParse(product[index].ProductPrice),
                                              product[index].ProductID,
                                              product[index].ProductNameTH,
                                              Server().pathImageFile +
                                                  product[index].ImageFile
                                                      .substring(
                                                      3,
                                                      product[index].ImageFile
                                                          .length),
                                              product[index].ColorCode,
                                              product[index].ServiceType,
                                              product[index].CategoryID,
                                              (product[index].Rating * 5) / 100);
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text('เพิ่มลง',style: new TextStyle(
                                              //fontSize: 18,
                                                fontFamily: 'Poppins',
                                                color: Colors.white
                                            ),),
                                            Icon(Icons.shopping_cart,size: 18.0,color: Colors.white,),
                                            setItemClicked(
                                                product[index].ProductID
                                                    .toString()),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          ratingStack(
                              product[index].ServiceType != 3 ? 3 : 7),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: product.length,
            ),
          ) : Padding(
            padding: EdgeInsets.all(12.0),
            child: Container(
              child: Center(
                child: Text(
                  'ไม่มีสินค้าที่ชื่นชอบ',
                  style: new TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      color: cl_text_pro_th
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###.#");
    var size = MediaQuery
        .of(context)
        .size;
    final makeBottom = new Container(
      //margin: EdgeInsets.only(bottom: 18.0),
        height: 65.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.grey[300], width: 1.0)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: Text("รวมเงิน :",
                      style: TextStyle(fontSize: 14.0, color: cl_text_pro_en),),
                  ),
                  Text('\$' + formatter.format(totalAmount),
                      style: TextStyle(color: cl_text_pro_th,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: Text("รวมจำนวน :",
                      style: TextStyle(fontSize: 14.0, color: cl_text_pro_en),),
                  ),
                  Text('x' + counts.toString(),
                      style: TextStyle(color: cl_text_pro_th,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: 65.0,
                width: size.width/3,
                child: RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () {
                    if (totalAmount == 0) {
                      _showDialog();
                    } else {
                      Navigator.of(context)
                          .push(
                          new MaterialPageRoute(builder: (context) => Cart()))
                          .whenComplete(_getRequests);
                      //_clearShafe();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ตะกร้า',
                        style: new TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white
                        ),
                      ),
                      /*BadgeIconButton(
                          itemCount: counts,
                          badgeColor: Colors.white,
                          badgeTextColor: Colors.deepOrange,
                          icon: Icon(Icons.shopping_cart, color: Colors.white,),
                          onPressed: () {
                            if (totalAmount == 0) {
                              _showDialog();
                            } else {
                              Navigator.of(context)
                                  .push(
                                  new MaterialPageRoute(
                                      builder: (context) => Cart()))
                                  .whenComplete(_getRequests);
                              //_clearShafe();
                            }
                          }),*/
                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );

    final makeBody = Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: cl_text_pro_th),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: new Text('สินค้าที่ชื่นชอบ', style: new TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: cl_text_pro_th
        ),
        ),
      ),
      body: _buildUsersList(),
      bottomNavigationBar: makeBottom,
    );
    return makeBody;
  }
}