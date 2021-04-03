import 'package:dicoding_news_app/data/api/api_service.dart';
import 'package:dicoding_news_app/data/model/article.dart';
import 'package:dicoding_news_app/provider/news_provider.dart';
import 'package:dicoding_news_app/ui/article_detail_page.dart';
import 'package:dicoding_news_app/utils/result_state.dart';
import 'package:dicoding_news_app/widgets/card_article.dart';
import 'package:dicoding_news_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ArticleListPage extends StatelessWidget {

  Widget _buildList(BuildContext context) {
      return Consumer<NewsProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return Center(child: CircularProgressIndicator(),);
          } else if (state.state == ResultState.HasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.articles.length,
              itemBuilder: (context, index) {
                var article = state.result.articles[index];
                return CardArticle(
                    article: article,
                    // onPressed: () {
                    //   Navigator.pushNamed(context, ArticleDetailPage.routeName, arguments: article);
                    // }
                );
              },
            );
          } else if ( state.state == ResultState.NoData) {
            return Center(child: Text(state.message),);
          } else if (state.state == ResultState.Error) {
            return Center(child: Text(state.message),);
          } else {
            return Center(child: Text(''),);
          }
        }
      );
  }

  // Widget _buildArticleItem(BuildContext context, Article article) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pushNamed(context, ArticleDetailPage.routeName, arguments: article);
  //     },
  //     child: Material(
  //       child: ListTile(
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //         leading: Image.network(article.urlToImage, width: 100,),
  //         title: Text(article.title),
  //         subtitle: Text(article.author),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('News App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos
    );
  }
}
