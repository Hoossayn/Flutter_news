import 'dart:async';
import 'new_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {

  List<Source> sources = <Source>[
    newsDbProvider,
    NewApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];


  //TODO: Iterate over sources when dpProvider get fetchTopIds implemented
  Future<List<int>> fetchTopIds(){
    return sources[1].fetchTopIds();

  }
  Future<ItemModel> fetchItems(int id) async {
  ItemModel item;
  var source;

  for(source in sources){
    item = await source.fetchItem(id);
    if(item != null){
      break;
    }
  }

  for (var cache in caches){
    if(cache != source){
      cache.addItem(item);
    }

  }
    return item;
  }
  clearCache() async {
    for(var cache in caches){
      await cache.clear();
    }
  }
}

abstract class Source{
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);

}
abstract class Cache{
  Future<int> addItem(ItemModel item);
  Future<int> clear();

}


