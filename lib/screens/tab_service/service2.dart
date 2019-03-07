import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/data/Product.dart' as _product;
class Laundry extends StatefulWidget {
  @override
  _LaundryState createState() => new _LaundryState();
}
//fetch product
Future<List<_product.Product>> fetchProduct() async {
  String branchGroupID="1";
  String serviceType="2";
  try {
    http.Response response =
    await http.get(Server().IPAddress + '/data/get/ser/Product.php?BranchGroupID=' +
        branchGroupID+'&ServiceType='+serviceType);
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
  }catch (exception) {
    print(exception.toString());
  }
}

class _LaundryState extends State<Laundry> {
  Color cl_bar = HexColor("#18b4ed");
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#e64d3f");
  Color cl_line_ver=HexColor("#677787");
  Color cl_favorite=HexColor("#e44b3b");

  @override
  Widget build(BuildContext context) {

    final makeBody = FutureBuilder<List<_product.Product>>(
        future: fetchProduct(),
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
                            //fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'
                        ),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                      subtitle: Row(
                        children: <Widget>[
                          /* Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),*/
                          Text(product[index].ProductPrice+' ฿',
                              style: TextStyle(color: cl_text_pro_en,
                                  fontFamily: 'Poppins'
                              ),
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

    return Scaffold(
      backgroundColor: cl_back,
      body: makeBody,
    );
  }
}