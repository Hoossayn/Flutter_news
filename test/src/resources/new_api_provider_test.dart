import 'package:flutter_news/src/resources/new_api_provider.dart';
import 'dart:convert';
import 'package:test_api/test_api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main(){
  test('FetchTopids return a list of ids',()async {
    //setup the test case
    final newApi = NewApiProvider();

    newApi.client = MockClient((request) async {
      return Response(json.encode([1,2,3,4,5]), 200);
    });

    final ids = await newApi.fetchTopIds();
    expect(ids, [1,2,3,4,5]);
  });

  test('FetchItem return a item model', ()async{
    final newsApi = NewApiProvider()
        newsApi.client = MockClient((request) async {
          final jsonMap = {'id':123};

          return Response(json.encode(jsonMap), 200);
        });

      final item = await newsApi.fetchItem(999);
      expect(item.id, 123);

  });
}