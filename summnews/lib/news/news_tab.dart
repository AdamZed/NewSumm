import 'package:flutter/material.dart';
import './article_cell.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsWidget extends StatefulWidget {
  final String category;
  NewsWidget({Key key, this.category}): super(key: key);
  @override
  _NewsWidgetState createState() => _NewsWidgetState(); 
}

class _NewsWidgetState extends State<NewsWidget> {
  var maxToLoad = 100;
  var _isLoading = true;
  var _articles;
  var fails = 0;

  final String disaster = '[{"category": "disaster", "date_published": "20 September 2018", "image": "https://cdn4.dogonews.com/images/a34fdc24-fb6f-48ad-8b22-7ee88521b6a7/1000w_q95.jpg", "source": "DOGOnews", "summary": " As had been expected, Hurricane Florence made landfall near Wrightsville Beach, North Carolina at 7:15 am ET. While downgraded to a Category 1, with sustained winds of 90 mph, the storm still packed a powerful punch, causing widespread flooding, destroying several structures and knocking out power to over 900,000 homes. In South Carolina, the flooding has damaged cotton, peanut, and hemp crops. Then there is the danger of coal ash polluting the water supply as well. Many of the over 8,000 North Carolina, South Carolina, and Virginia residents forced to evacuate, are still living in Red Cross shelters or with family and friends.", "title": "Hurricane Florence Causes Widespread Flooding in The Carolinas", "url": "https://www.dogonews.com/2018/9/20/tropical-storm-florence-causes-widespread-flooding-in-the-carolinas"},';
  _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final api = 'https://newsumm-70f1d.firebaseio.com/articles/${widget.category}.json';
    final res = await http.get(api);
    if (res.statusCode == 200) {
      final toDec = disaster + res.body.substring(1);
      print(toDec);
      _articles = json.decode(toDec);
    }
    else _articles = null;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_articles == null) _fetchData();
    return new Center(
      child: _isLoading
          ? new CircularProgressIndicator()
          : new ListView.builder(
              itemCount: this._articles != null
                  ? this._articles.length > maxToLoad ? maxToLoad : this._articles.length
                  : 0,
              itemBuilder: (context, i) {
                return new FlatButton(
                  child: ArticleCell(this._articles[i]),
                  onPressed: () {},
                );
              }),
    );
  }
}