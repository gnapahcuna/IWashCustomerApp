import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cleanmate_customer_app/Server/server.dart';
import 'package:cleanmate_customer_app/data/Product.dart' as _product;
import 'package:cleanmate_customer_app/colorCode/HexColor.dart';
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

class SearchList extends StatefulWidget {

  @override
  _SearchListState createState() => new _SearchListState();

}

class _SearchListState extends State<SearchList>
{
  Widget appBarTitle = new Text("Search Sample", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;
  String _searchText = "";

  _SearchListState() {
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
  @override
  void initState() {
    super.initState();
    _IsSearching = false;

  }

  @override
  Widget build(BuildContext context) {
    Color cl_card=HexColor("#ffffff");
    Color cl_text_pro_th=HexColor("#667787");
    Color cl_text_pro_en=HexColor("#989fa7");

    final makeBody = FutureBuilder<List<_product.Product>>(
        future: fetchProduct(1,"service"),
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

          if (!(_searchText.isEmpty)) {
            List<_product.Product> tempList = new List();
            for (int i = 0; i < product.length; i++) {
              if (product[i].ProductNameEN.toLowerCase().contains(_searchText.toLowerCase())) {
                tempList.add(product[i]);
              }
            }
            product = tempList;
          }

          return Container(
            child: ListView.builder(
              //itemCount: product.length,
              itemCount: product.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    //getTotalAmount(int.tryParse(product[index].ProductPrice),product[index].ProductID);
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
          );
        }
    );

    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: makeBody
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(icon: actionIcon, onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                this.appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,

                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),
                );
                _handleSearchStart();
              }
              else {
                _handleSearchEnd();
              }
            });
          },),
        ]
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Search Sample", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}
