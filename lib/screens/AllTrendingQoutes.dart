import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:qoutes_app/apiconfig/ApiData.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';

import 'Detail.dart';

class GetallTrendingQoutes extends StatefulWidget {
  @override
  _GetallTrendingQoutesState createState() => _GetallTrendingQoutesState();
}

class _GetallTrendingQoutesState extends State<GetallTrendingQoutes> {
  ApiData _apiData = ApiData();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String checker = 'yes';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending Quotes'),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 3));
          setState(() {});
        },
        child:
            ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
          FutureBuilder(
            builder: (context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  // TODO: Handle this case.
                  return Center(
                    child: Text('No Internet Connection'),
                  );
                  break;
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                  // TODO: Handle this case.

                  // TODO: Handle this case.
                  break;
                case ConnectionState.done:
                  return snapshot.hasData
                      ? GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          gridDelegate: XSliverGridDelegate(
                            crossAxisCount: 2,
                            smallCellExtent: Screensize.heightMultiplier * 32,
                            bigCellExtent: Screensize.heightMultiplier * 32,
                          ),
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: snapshot.data[index].p_id +
                                  snapshot.data[index].p_image +
                                  'allsubtrendings',
                              child: Card(
                                elevation: 5,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data[index].p_image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                    ),
                                    Positioned.fill(
                                        child: new Material(
                                            color: Colors.transparent,
                                            child: new InkWell(
                                              splashColor: Customcolors.green,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Detail(
                                                                Check: checker,
                                                                Name:
                                                                    'allsubtrendings',
                                                                Id: snapshot
                                                                    .data[index]
                                                                    .p_id,
                                                                Image: snapshot
                                                                    .data[index]
                                                                    .p_image)));
                                              },
                                            ))),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Text("");
                  // TODO: Handle this case.
                  break;
              }
            },
            future: _apiData.GetAllTrendings(),
          ),
        ]),
      ),
    );
  }



}
