import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class network with ChangeNotifier{
  Future<String> getData(String textSearch,int perpage) async {
    http.Response response = await http.get(
      Uri.encodeFull(
          'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&text=$textSearch&per_page=$perpage'),
      headers: {'key': '11c40ef31e4961acf4f98c8ff4e945d7'},
    );
    return response.body;
  }
}