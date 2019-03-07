import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/data/Product.dart' as _product;
import 'package:money/money.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:cleanmate_customer_app/tabs/tab_menu_service/cart.dart';
import 'package:cleanmate_customer_app/alert/messageAlert.dart' as _message;
//fetch product
Future<List<_product.Product>> fetchProduct(id,type) async {
  String branchGroupID="1";
  try {
    http.Response response;
    List responseJson;
    if(type=="service") {
      response =
      await http.get(
          Server().IPAddress + '/data/get/ser/Product.php?BranchGroupID=' +
              branchGroupID + '&ServiceType=' + id.toString());
      responseJson = json.decode(response.body);

    }else{
      response =
      await http.get(Server().IPAddress + '/data/get/cate/Product.php?BranchGroupID=' +
          branchGroupID+'&CategoryID='+id.toString());
      responseJson = json.decode(response.body);
    }
    return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
  }catch (exception) {
    print(exception.toString());
  }
}

class Product extends StatefulWidget {
  int typeID;
  String typeName;
  String type;
  Product({
    Key key,
    @required this.typeID,
    @required this.typeName,
    @required this.type,
  }) : super(key: key);
  @override
  _ProductState createState() => new _ProductState(this.typeName);

}
class _ProductState extends State<Product> {
  Color cl_bar = HexColor("#18b4ed");
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#e64d3f");
  Color cl_line_ver=HexColor("#677787");
  Color cl_favorite=HexColor("#e44b3b");


  SharedPreferences prefs;
  int totalAmount = 0;
  int counts=0;

  List<String> proID,proCount;

  getTotalAmount(price,proID,proName,image,color) {
    setState(() {
      _putCount(price,proID,proName,image,color);
    });
  }

  _putCount(price,productID,productName,images,color) async {
    _initPref();
    //print(price.toString()+", "+proID.toString());
    int counter = (prefs.getInt('count') ?? 0) + 1;
    int total = (prefs.getInt('total') ?? 0) + price;
    counts=counter;
    totalAmount = total;
    await prefs.setInt('count', counter);
    await prefs.setInt('total', totalAmount);


    List<String> itemsID=(prefs.getStringList('productID')??new List());
    List<String> itemsName=(prefs.getStringList('productName')??new List());
    List<String> itemsPrice=(prefs.getStringList('productPrice')??new List());
    List<String> itemsImage=(prefs.getStringList('productImage')??new List());
    List<String> itemsCount=(prefs.getStringList('productCount')??new List());
    List<String> itemsColor=(prefs.getStringList('productColor')??new List());
    int index = itemsID.indexOf(productID.toString());
    if(index!=-1){
      int counts=int.parse(itemsCount[index])+1;
      itemsCount[index]=counts.toString();
    }else{
      itemsID.add(productID.toString());
      itemsCount.add(1.toString());
      itemsName.add(productName.toString());
      itemsPrice.add(price.toString());
      itemsImage.add(images.toString());
      itemsColor.add(color.toString());
    }
    await prefs.setStringList('productID', itemsID);
    await prefs.setStringList('productCount', itemsCount);
    await prefs.setStringList('productName', itemsName);
    await prefs.setStringList('productImage', itemsImage);
    await prefs.setStringList('productPrice', itemsPrice);
    await prefs.setStringList('productColor', itemsColor);

    //print(prefs.getStringList('productID').toString()+" , "+prefs.getStringList('productCount').toString());
    proID=itemsID;
    proCount=itemsCount;
  }
  _getShafe() async{
    prefs = await SharedPreferences.getInstance();
    int counter = (prefs.getInt('count') ?? 0);
    int total = (prefs.getInt('total') ?? 0);
    List<String> arr1=(prefs.getStringList('productID')??new List());
    List<String> arr2=(prefs.getStringList('productCount')??new List());
    List<String> arr3=(prefs.getStringList('productPrice')??new List());
    /*int counter=0;
    int total=0;
    for(int i=0;i<arr1.length;i++){
      counter+=int.parse(arr2[i]);
      total+=int.parse(arr2[i])*int.parse(arr3[i]);
    }*/
    setState(() {
      counts = counter;
      totalAmount = total;
      proID=arr1;
      proCount=arr2;
    });
  }
  _clearShafe() async {
    setState(() {
      _initPref();
      prefs.clear();
      counts = 0;
      totalAmount=0;
    });
  }
  _initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    //print("state");
    _getShafe();
    _IsSearching = false;
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
  bool _IsSearching;
  String _searchText = "";

  _ProductState(typeName) {
    appBarTitle = Text(typeName, style: new TextStyle(color: HexColor("#667787")),);
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }
  setItemClicked(productID){
    //print(proID.contains(productID.toString()));
    return Text( "${proID.contains(productID.toString())==true&&proID.length>0
        ? proCount[proID.indexOf(productID.toString())].toString():''}",
      style: TextStyle(fontSize: 14.0, color: cl_text_pro_th,fontFamily: 'Poppins'),);
  }

  _getRequests()async{
    //print("_getRequests");
    _getShafe();
  }

  void _showDialog() {
    _message.Message('แจ้งเตือน!','คุณยังไม่มีรายการในตะกร้าสินค้า.',context,null,2);
  }

  @override
  Widget build(BuildContext context) {
    //test search
    final money = Money(totalAmount, Currency('USD'));
    final makeBody = FutureBuilder<List<_product.Product>>(
        future: fetchProduct(widget.typeID, widget.type),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load.
            return new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: new Scaffold(
                  backgroundColor: cl_back,
                  body: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                )
            );
          // Shows the real data with the data retrieved.
          List<_product.Product> product = snapshot.data;
          if (!(_searchText.isEmpty)) {
            List<_product.Product> tempList = new List();
            for (int i = 0; i < product.length; i++) {
              if (product[i].ProductNameEN.toLowerCase().contains(
                  _searchText.toLowerCase())) {
                tempList.add(product[i]);
              }
            }
            product = tempList;
          }

          var size = MediaQuery
              .of(context)
              .size;
          /*24 is for notification bar on Android*/
          final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
          final double itemWidth = size.width / 2;
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
                        getTotalAmount(
                            int.tryParse(product[index].ProductPrice),
                            product[index].ProductID,
                            product[index].ProductNameEN,
                            Server().pathImageFile +
                                product[index].ImageFile
                                    .substring(
                                    3,
                                    product[index].ImageFile
                                        .length),
                            product[index].ColorCode);
                      },
                      child: Container(
                          height: 350.0,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8.0
                                )
                              ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
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
                                                        product[index].ImageFile
                                                            .length),
                                                fit: BoxFit.contain)
                                        ),
                                      ),
                                      Container(
                                          child: setItemClicked(
                                              product[index].ProductID
                                                  .toString()) /*Text( "${proID.contains(product[index].ProductID.toString())==true&&proID.length>0
                                            ? proCount[proID.indexOf(product[index].ProductID.toString())].toString():''}",
                                          style: TextStyle(fontSize: 14.0, color: cl_text_pro_th,fontFamily: 'Poppins'),),*/ /*Icon(
                                          Icons.favorite_border, size: 20.0,),*/
                                        //child: data[index].fav ? Icon(Icons.favorite,size: 20.0,color: Colors.red,) : Icon(Icons.favorite_border,size: 20.0,),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                    margin: new EdgeInsets.symmetric(
                                        vertical: 4.0),
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
                                  "${product[index].ProductNameEN.length < 13
                                      ? product[index].ProductNameEN
                                      : product[index].ProductNameEN.substring(
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
                                        rating: 0,
                                        color: Colors.orange,
                                        borderColor: Colors.grey,
                                        starCount: 5
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "\$${product[index].ProductPrice
                                            .toString()}", style: TextStyle(
                                          color: cl_text_pro_en,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins'),),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                      ),
                    )
                );
              },
              itemCount: product.length,
            ),
          );
          /*return Container(
            child: ListView.builder(
              itemCount: product.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    getTotalAmount(int.tryParse(product[index].ProductPrice),product[index].ProductID);
                  },
                  child: Card(
                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: cl_card),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(
                                      width: 1.0,
                                      color: HexColor(
                                          product[index].ColorCode)))),
                          child: new SizedBox(
                            height: 60.0,
                            width: 60.0,
                            child: Image.network(
                                'http://119.59.115.80/cleanmate_god_test/' +
                                    product[index].ImageFile.substring(
                                        3, product[index].ImageFile.length),
                                fit: BoxFit.cover),

                          ),
                        ),
                        title: Text(
                          product[index].ProductNameEN,
                          style: TextStyle(color: cl_text_pro_th,
                              fontFamily: 'Poppins'
                          ),
                        ),

                        subtitle: Row(
                          children: <Widget>[
                            Text(product[index].ProductPrice + ' ฿',
                                style: TextStyle(color: cl_text_pro_en,
                                    fontFamily: 'Poppins'
                                )
                            ),
                          ],
                        ),
                        trailing:
                        new SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.more_vert, color: cl_text_pro_th,
                                  size: 28.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );*/
        }
    );

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
                    child: Text("Total Amount :",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                  ),
                  Text('\$' + money.amount.toString(),
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
                    child: Text("Total Count :",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),),
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
                child: RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                        new MaterialPageRoute(builder: (context) => Cart()))
                        .whenComplete(_getRequests);
                    //_clearShafe();
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        'GO TO',
                        style: new TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white
                        ),
                      ),
                      BadgeIconButton(
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
                                  new MaterialPageRoute(builder: (context) => Cart()))
                                  .whenComplete(_getRequests);
                              //_clearShafe();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),

          ],
        )
    );

    // TODO: implement build
    return Scaffold(
        backgroundColor: cl_back,
        appBar: AppBar(
            //backgroundColor: cl_back,
            elevation: 0.0,
            leading: new IconButton(
              icon: new Icon(Icons.chevron_left, color: HexColor("#667787")),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: appBarTitle,
            //backgroundColor: cl_bar,
            actions: <Widget>[
              new IconButton(icon: actionIcon, onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon =
                    new Icon(Icons.close, color: HexColor("#667787"),);
                    this.appBarTitle = new TextField(
                      controller: _searchQuery,
                      style: new TextStyle(
                        color: HexColor("#667787"),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(
                              Icons.search, color: HexColor("#667787")),
                          hintText: "Search...",
                          hintStyle: new TextStyle(
                            color: HexColor("#667787"),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          )
                      ),
                    );
                    _handleSearchStart();
                  }
                  else {
                    _handleSearchEnd(widget.typeName);
                  }
                });
              },),
            ]
        ),
        body: makeBody,
        bottomNavigationBar: makeBottom
    );
  }
  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd(typeName) {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: HexColor("#667787"),);
      this.appBarTitle =
      new Text(typeName, style: new TextStyle(color: HexColor("#667787")),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}
