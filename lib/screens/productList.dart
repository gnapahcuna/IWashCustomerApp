import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
import 'package:cleanmate_customer_app/data/Product.dart' as _product;

class ProductList extends StatefulWidget {

  @override
  _ProductListState createState() => new _ProductListState();
}
//fetch product
Future<List<_product.Product>> fetchProduct() async {
  String branchGroupID="1";
  http.Response response =
  await http.get(Server().IPAddress+'/data/get/Product.php?BranchGroupID='+branchGroupID);
  List responseJson = json.decode(response.body);
  return responseJson.map((m) => new _product.Product.fromJson(m)).toList();
}


class _ProductListState extends State<ProductList> {
  Color cl_back=HexColor("#e9eef4");
  Color cl_card=HexColor("#ffffff");
  Color cl_text_pro_th=HexColor("#667787");
  Color cl_text_pro_en=HexColor("#989fa7");
  Color cl_cart=HexColor("#18b4ed");
  Color cl_line_ver=HexColor("#677787");
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      backgroundColor: cl_cart,
      elevation: 0.1,
      title: Text("Product List"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        )
      ],
    );

    //message toast
    void _showToast(BuildContext context) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Added to favorite'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    final makeBody = FutureBuilder<List<_product.Product>>(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: cl_card),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: cl_line_ver))),
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
                            product[index].ProductNameTH,
                            style: TextStyle(color: cl_text_pro_th,
                                fontWeight: FontWeight.bold),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          subtitle: Row(
                            children: <Widget>[
                             /* Icon(Icons.linear_scale,
                                  color: Colors.yellowAccent),*/
                              Text(product[index].ProductNameEN,
                                  style: TextStyle(color: cl_text_pro_en)
                              ),
                            ],
                          ),
                          trailing:
                          /*Icon(Icons.add_shopping_cart, color: cl_cart,
                              size: 30.0),*/
                          Text(product[index].ProductPrice+' ฿',
                              style: TextStyle(color: cl_text_pro_en)
                          ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
        }
    );


    return Scaffold(
      backgroundColor: cl_back,
      appBar: topAppBar,
      body: makeBody,
    );
  }

}

