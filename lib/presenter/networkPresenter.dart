
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class network with ChangeNotifier{
  Future<String> getData(String textSearch,int perpage) async {
    http.Response response = await http.get(
      Uri.encodeFull(
          'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&text=$textSearch&per_page=$perpage'),
      headers: {'key': '11c40ef31e4961acf4f98c8ff4e945d7'},
    );
    return response.body;
  }
  Future<List<Uint8List>> getImageBytes(List url)async{
    http.Response response;
    List<Uint8List>returnedList=[];
    for(int i=0;i<url.length;i++)
    {
      response = await http.get(Uri.encodeFull(url[i]));
      returnedList.add(response.bodyBytes);
    }
    return returnedList;
  }
  Future<bool>getConnectionState()async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

  }

}