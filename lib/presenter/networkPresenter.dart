
import 'dart:io';
import 'dart:typed_data';

import 'package:apibymetest/presenter/dataBasePresenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class network with ChangeNotifier{
  var dio = Dio();
  Future<Map<String,dynamic>> getData(String textSearch,int perpage) async {
    DioCacheManager _dioCacheManager = DioCacheManager(
        CacheConfig(
            baseUrl:
            'https://api.flickr.com/services/rest/?method=flickr.photos.search&'
                'api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&'
                'text=$textSearch&per_page=$perpage',
          databaseName: 'test.db',
          databasePath:await db(textSearch).DBPath(),
          defaultMaxAge: Duration(days: 10),
        ));
    Options _cacheOptions = buildCacheOptions(Duration(days: 10), forceRefresh: true);
    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(
          'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&text=$textSearch&per_page=$perpage',
      options: _cacheOptions,
    );
    return response.data;
  }
  Future<Map<String,Uint8List>> getImageBytes(List url)async{
    Response response;
    Map<String,Uint8List>returnedList={};
    for(int i=0;i<url.length;i++)
    {
      response = await Dio().get(url[i],options: Options(
        responseType: ResponseType.bytes,));
      returnedList[url[i]]=response.data;
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