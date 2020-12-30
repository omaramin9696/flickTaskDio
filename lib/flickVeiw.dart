import 'package:apibymetest/presenter/flickPresenter.dart';
import 'package:apibymetest/presenter/networkPresenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) => flickpresenter(),),
      ChangeNotifierProvider(create: (BuildContext context) => network(),),

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
                      await Provider.of<flickpresenter>(context,listen: false).showSearch1(context);
                    },
                  ),
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height-200,
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                for(var x in Provider.of<flickpresenter>(context).url)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network(x),
                      ),
                    ),
                  ),
                ),
              ],

              //  itemCount: _flickPresenter.url.length,
              //  itemBuilder: (context, index) {},
            ),
          ),
        ],
      ),
    );
  }
}