import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/data/CategoryTitle.dart' as _categoryName;
import 'package:cleanmate_customer_app/data/Product.dart' as _product;
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'product.dart';

//fetch product
Future<List<_product.Product>> fetchProduct(cateID) async {
  print(cateID);
  String branchGroupID="1";
  try {
    http.Response response =
    await http.get(Server().IPAddress + '/data/get/cate/Product.php?BranchGroupID=' +
        branchGroupID+'&CategoryID='+cateID.toString());
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
  }catch (exception) {
    print(exception.toString());
  }
}
//fetch category
Future<List<_categoryName.Category>> fetchCategory() async {
  try {
    http.Response response =
    await http.get(Server().IPAddress + '/data/get/Category.php');
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new _categoryName.Category.fromJson(m)).toList();
  }catch (exception) {
    print(exception.toString());
  }
}
Color cl_bar = HexColor("#18b4ed");
Color cl_back=HexColor("#e9eef4");
Color cl_card=HexColor("#ffffff");
Color cl_text_pro_th=HexColor("#667787");
Color cl_text_pro_en=HexColor("#989fa7");
Color cl_cart=HexColor("#e64d3f");
Color cl_line_ver=HexColor("#677787");
Color cl_favorite=HexColor("#e44b3b");

final makeBodyCate = FutureBuilder<List<_categoryName.Category>>(
    future: fetchCategory(),
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
      List<_categoryName.Category> category = snapshot.data;
      return new Container(
        child: ListView.builder(
          itemCount: category.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              /*onTap: () {
                _onTapItem(context, category[index].CategoryID,category[index].CategoryNameTH);
              },*/
              onTap: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context) {
                      return new Product(
                        typeID: category[index].CategoryID,
                        typeName: category[index].CategoryNameEN,
                        type: "category",
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 120.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
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
                            new Text(category[index].CategoryNameTH,
                              style: TextStyle(
                                  fontFamily: 'Poppins'
                              ).copyWith(
                                  color: cl_text_pro_th,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            new Container(height: 10.0),
                            new Text(category[index].CategoryNameEN,
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
                                width: category[index].CategoryNameEN.length
                                    .toDouble() * 7,
                                color: new Color(0xff00c6ff)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(
                          vertical: 16.0
                      ),
                      alignment: FractionalOffset.centerLeft,
                      child: new Image(
                        image: new AssetImage("assets/images/cate.png"),
                        height: 92.0,
                        width: 92.0,
                        color: HexColor(category[index].ColorCode),
                      ),
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
void _onTapItem(BuildContext context,cateID,cateName) {
  print(cateID);
  final makeBodyProduct = FutureBuilder<List<_product.Product>>(
      future: fetchProduct(cateID),
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
        // Shows the real data with the data retrieved.
        List<_product.Product> product = snapshot.data;
        return new Container(
          child: ListView.builder(
            itemCount: product.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Card(
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
                                  width: 1.0, color: HexColor(product[index].ColorCode)))),
                      child: new SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: Image.network(
                            'http://119.59.115.80/cleanmate_god_test/' +
                                product[index].ImageFile.substring(3, product[index].ImageFile.length),
                            fit: BoxFit.cover),

                      ),
                    ),
                    title: Text(
                      product[index].ProductNameEN,
                      style: TextStyle(color: cl_text_pro_th,
                          //fontWeight: FontWeight.bold
                          fontFamily: 'Poppins',),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    subtitle: Row(
                      children: <Widget>[
                        /* Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),*/
                        Text(product[index].ProductPrice+' ฿',
                            style: TextStyle(color: cl_text_pro_en,
                                fontFamily: 'Poppins'
                            )
                        ),
                      ],
                    ),
                    trailing:
                    Icon(Icons.favorite_border, color: cl_favorite,
                        size: 28.0),
                  ),
                ),
              );
            },
          ),
        );
      }
  );

  final makeAppBar = Text(cateName,style: TextStyle(fontFamily: 'Poppins'),);
  Navigator.of(context).push(
    new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new Scaffold(
          backgroundColor: cl_back,
          appBar: new AppBar(
            backgroundColor: cl_bar,
            title: makeAppBar,
          ),
          body: makeBodyProduct,
          /*floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.shopping_cart),
            backgroundColor: cl_cart,
            //onPressed: ,
          ),*/
          bottomNavigationBar: Container(
              height: 60.0,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      'Total: \$' + 12000.toString(),
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
        );
      },
    ),
  );
}
class Category{
  Category() : super();
}