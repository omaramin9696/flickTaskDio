
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class network with ChangeNotifier{
  var dio = Dio();
  Future<Map<String,dynamic>> getData(String textSearch,int perpage) async {
    DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig());
    Options _cacheOptions = buildCacheOptions(Duration(days: 10), forceRefresh: true);
    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(
          'https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&text=$textSearch&per_page=$perpage',
   options: _cacheOptions,
    );
    return response.data;
  }

}