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

//fetch service
Future<List<_service.Service>> fetchService() async {
  try {
    http.Response response =
    await http.get(Server().IPAddress + '/data/get/Service.php');
    print(response.statusCode.toString());
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new _service.Service.fromJson(m)).toList();
    } else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
    }
  } catch (exception) {
    print(exception.toString());
  }
}

class TabbedAppBarService extends StatefulWidget {
  @override
  _TabbedAppBarServiceState createState() => new _TabbedAppBarServiceState();
}
class _TabbedAppBarServiceState extends State<TabbedAppBarService> {

  Color cl_bar = HexColor("#18b4ed");
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#e64d3f");
  Color cl_line_ver=HexColor("#677787");
  Color cl_favorite=HexColor("#e44b3b");

  TextEditingController controller = new TextEditingController();
  List<_product.Product> _searchResult = [];
  List<_product.Product> _branchDetails = [];

  SharedPreferences prefs;
  int totalAmount = 0;
  int counts=0;

  List<String> proID,proCount;
  //fetch product
  Future<List<_product.Product>> fetchProduct(id) async {
    String branchGroupID="1";
    try {
      http.Response response;
      List responseJson;
      response =
      await http.get(
          Server().IPAddress + '/data/get/ser/Product.php?BranchGroupID=' +
              branchGroupID + '&ServiceType=' + id.toString());
      responseJson = json.decode(response.body);
      for (Map user in responseJson) {
        _branchDetails.add(_product.Product.fromJson(user));
      }
      return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
    }catch (exception) {
      print(exception.toString());
    }
  }

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


  Widget _buildUsersList(serviceType) {
    final formatter = new NumberFormat("#,###.#");
    return FutureBuilder<List<_product.Product>>(
        future: fetchProduct(serviceType),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load.
            return new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: new Scaffold(
                  //backgroundColor: cl_back,
                  body: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
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
            padding: const EdgeInsets.only(left: 4.0,right: 4.0,top: 4.0,bottom: 4.0),
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
                                        "\฿${product[index].ProductPrice
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
        }
    );
  }

  Widget _buildSearchResults() {
    final formatter = new NumberFormat("#,###.#");
    var size = MediaQuery
        .of(context)
        .size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Padding(
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
                  getTotalAmount(
                      int.tryParse(_searchResult[index].ProductPrice),
                      _searchResult[index].ProductID,
                      _searchResult[index].ProductNameEN,
                      Server().pathImageFile +
                          _searchResult[index].ImageFile
                              .substring(
                              3,
                              _searchResult[index].ImageFile
                                  .length),
                      _searchResult[index].ColorCode);
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
                                              _searchResult[index].ImageFile
                                                  .substring(
                                                  3,
                                                  _searchResult[index].ImageFile
                                                      .length),
                                          fit: BoxFit.contain)
                                  ),
                                ),
                                Container(
                                    child: setItemClicked(
                                        _searchResult[index].ProductID
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
                                  _searchResult[index].ColorCode)
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${_searchResult[index].ProductNameEN.length < 13
                                ? _searchResult[index].ProductNameEN
                                : _searchResult[index].ProductNameEN.substring(
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
                                  "\฿${_searchResult[index].ProductPrice
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
        itemCount: _searchResult.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final money = Money(totalAmount, Currency('USD'));
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

    final makeTab = FutureBuilder<List<_service.Service>>(
        future: fetchService(),
        builder: (context, snapshot) {
          print("statusCode : "+snapshot.hasData.toString());
          if (!snapshot.hasData)
            // Shows progress indicator until the data is load
            return new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: new Scaffold(
                  //backgroundColor: cl_back,
                  body: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                )
            );
          List<_service.Service> service = snapshot.data;
          return DefaultTabController(
            length: service.length,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: new IconButton(
                  icon: new Icon(Icons.chevron_left, color: HexColor("#667787")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: new Text('บริการ',style: new TextStyle(color: cl_text_pro_th),),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: service.map((_service.Service service) {
                    return Tab(
                      text: service.ServiceNameTH,
                      icon: SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: Image.network(
                            'http://119.59.115.80/cleanmate_god_test/' +
                                service.ImageFile.substring(
                                    3, service.ImageFile.length),
                            fit: BoxFit.cover,color: cl_text_pro_th,),
                      ),
                    );
                  }).toList(),
                ),
              ),
              body: TabBarView(
                children: service.map((_service.Service service) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0,left: 4.0,right: 4.0),
                            child: new Card(
                              //color: cl_back,
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller,
                                  decoration: new InputDecoration(
                                      hintText: 'Search', border: InputBorder.none),
                                  onChanged: onSearchTextChanged,
                                ),
                                trailing: new IconButton(
                                  icon: new Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.clear();
                                    onSearchTextChanged('');
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _searchResult.length != 0 || controller.text.isNotEmpty
                              ? _buildSearchResults()
                              : _buildUsersList(service.ServiceType),
                        ),

                      ],
                    ),
                  );
                }).toList(),
              ),
              bottomNavigationBar: makeBottom,
            ),
          );
        }
    );
    return makeTab;
  }
  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _branchDetails.forEach((userDetail) {
      if (userDetail.ProductNameTH.contains(text) ||
          userDetail.ProductNameEN.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}