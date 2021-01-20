import 'dart:typed_data';

import 'presenter/flickPresenter.dart';
import 'presenter/networkPresenter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => flickpresenter(),
      ),
      ChangeNotifierProvider(
        create: (BuildContext context) => network(),
      ),
    ],
    child: MaterialApp(
      home: api(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}

class api extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: MediaQuery.of(context).size.width - 50,
                child: ListTile(
                  title: ListTile(
                    trailing: Icon(Icons.search),
                    onTap: () async {
                      await Provider.of<flickpresenter>(context,
                          listen: false)
                          .showSearch1(context);
                    },
                  ),
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: LazyLoadScrollView(
              onEndOfPage: ()async {
                return  Provider.of<flickpresenter>(context, listen: false)
                    .doSearch();
              },
              child:
              FutureBuilder(
                future: Provider.of<flickpresenter>(context).displayImages(),
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    return snapshot.data;
                  else return Center(child: CircularProgressIndicator(),);
                },
              )
            ),
          ),
        ],
      ),
    );
  }
}
