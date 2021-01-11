import 'package:apibymetest/model/flickModel.dart';
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
  String searchText;
  void doSearch() async {
    Map searchResult;
    if (searchText != null)
    {
      searchResult = await _network.getData(
          searchText, url.isNotEmpty ? _flickrData.photos.perpage += 10 : 10);
      _flickrData = FlickrData.fromJson(searchResult);
      generarteURLs();
   await saveToRecentSearches(searchText.trim());
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
