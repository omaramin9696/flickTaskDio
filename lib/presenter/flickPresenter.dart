import 'dart:typed_data';
import 'package:apibymetest/model/flickModel.dart';
import 'package:apibymetest/presenter/dataBasePresenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_search_delgates.dart';
import 'networkPresenter.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
class flickpresenter with ChangeNotifier {
  FlickrData _flickrData = new FlickrData();
  network _network =new network();
  List<String> url = [];
  List<Uint8List> urlBinary = [];
  String searchText;

 Widget imageVeiwFromNetwork(){
  return GridView.count(
     crossAxisCount: 2,
     children: [
       for (String link
       in this.url)
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Card(
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                 child:  Image.network(link),
               ),
             ),
           ),
         ),
     ],
   );
 }
  Widget imageVeiwFromDatabase(){
    return GridView.count(
      crossAxisCount: 2,
      children: [
        for (Uint8List link
        in this.urlBinary)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child:  Image.memory(link),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future <Widget> displayImages()async{
   return await _network.getConnectionState()?
      imageVeiwFromNetwork():
     imageVeiwFromDatabase();
 }

  void doSearch() async {
    Map searchResult;
    if (searchText != null)
    {
      db db1 = new db(searchText.replaceAll(' ', ''));

      if(await _network.getConnectionState())
      {
        this.urlBinary.isNotEmpty??this.urlBinary.clear();
        searchResult = await _network.getData(searchText,
            _flickrData.photos != null ? _flickrData.photos.perpage += 10 : 10);
        _flickrData = FlickrData.fromJson(searchResult);
        generarteURLs();
        await db1.insertDB(await _network.getImageBytes(this.url));
        await saveToRecentSearches(searchText);
      }
      else
        {
          this.url.isNotEmpty??this.url.clear();
          this.urlBinary=await db1.retriveDB();
        }
    }
    notifyListeners();
  }


  void generarteURLs()async{
    this.url.clear();
    for (Photo photo in _flickrData.photos.photo) {
      url.add(
          "https://farm${photo.farm}.static.flickr.com/${photo.server}/${photo.id}_${photo.secret}.jpg");
    }
  }

  Future<void> showSearch1(BuildContext context) async {
    searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithSuggestionDelegate(
        onSearchChanged: getRecentSearchesLike,
      ),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    //should not be null
    if (searchText != null &&
        searchText.trim().length > 0) //no need to save white spaces
    {
       this.url.isNotEmpty??this.url.clear();
        _flickrData = new FlickrData();
        doSearch();
    }
    notifyListeners();
  }

  Future<List<String>> getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches.where((search) => search.startsWith(query)).toList();
  }

  Future<void> saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
}
