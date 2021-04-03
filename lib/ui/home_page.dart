import 'dart:io';

import 'package:dicoding_news_app/data/api/api_service.dart';
import 'package:dicoding_news_app/data/model/article.dart';
import 'package:dicoding_news_app/provider/news_provider.dart';
import 'package:dicoding_news_app/provider/scheduling_provider.dart';
import 'package:dicoding_news_app/ui/article_detail_page.dart';
import 'package:dicoding_news_app/ui/article_list_page.dart';
import 'package:dicoding_news_app/ui/bookmarks_page.dart';
import 'package:dicoding_news_app/ui/settings_page.dart';
import 'package:dicoding_news_app/utils/background_service.dart';
import 'package:dicoding_news_app/utils/notification_helper.dart';
import 'package:dicoding_news_app/widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  int _bottomNavIndex = 0;
  static const String _headlineText = 'Headline';

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _service.someTask());
    _notificationHelper.configureSelectNotificationSubject(
        ArticleDetailPage.routeName);
  }
  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.public),
      title: Text(_headlineText)
    ),
    BottomNavigationBarItem(
        icon: Icon(Platform.isIOS ? CupertinoIcons.bookmark : Icons.collections_bookmark),
      title: Text(BookmarksPage.bookmarksTitle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      title: Text(SettingsPage.settingsTitle)
    )
  ];
  
  List<Widget> _listWidget = [
    ArticleListPage(),
    BookmarksPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavigationBarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavigationBarItems,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }
}