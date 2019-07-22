import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/comment_provider.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          onGenerateRoute: routes,

        ),
      ),

    );
  }

  Route routes(RouteSettings settings){
    if(settings.name == '/'){
      return MaterialPageRoute(
        builder:(context){
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          
          return NewsList();
        },
      );
    }else {
      return MaterialPageRoute(
        builder: (context){
          //good place to extract item id from setting.name
          //and pass into news detail
          //place to do initialization or data fetching for newsDetail
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/',''));

          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(itemId: itemId);
        }
      );
    }
  }

}











