import 'dart:convert';
import 'package:apibymetest/model/flickModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_search_delgates.dart';
import 'networkPresenter.dart';

class flickpresenter with ChangeNotifier{
FlickrData _flickrData=new FlickrData();
List<String> url = [];

 void doSearch(String searchText) async {
   String searchResult = await network().getData(searchText);
   _flickrData = FlickrData.fromJson(jsonDecode(searchResult));
   generarteURLs();
   notifyListeners();
 }


  void generarteURLs() {
   url.clear();
   for (Photo photo in _flickrData.photos.photo) {
      url.add(
          "https://farm${photo.farm}.static.flickr.com/${photo.server}/${photo.id}_${photo.secret}.jpg");
    }
  }

  Future<void> showSearch1(BuildContext context) async {
    final searchText = await showSearch<String>(
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
      await saveToRecentSearches(searchText.trim());
      doSearch(searchText);
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
    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};
    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
}
