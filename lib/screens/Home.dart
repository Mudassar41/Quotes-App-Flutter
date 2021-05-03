import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:qoutes_app/apiconfig/ApiData.dart';
import 'package:qoutes_app/models/Category.dart';
import 'package:qoutes_app/models/Images.dart';
import 'package:qoutes_app/screens/AllTrendingQoutes.dart';
import 'package:qoutes_app/screens/Detail.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';
import 'package:qoutes_app/widgets/SlideRightRoute.dart';
import 'QoutesOfDay.dart';
import 'SubCategories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ApiData _apiData = ApiData();
  AdmobBannerSize bannerSize;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  Future<List<Images>> Quotesoftheday;
  Future<List<Images>> TrendingQuotes;
  Future<List<Category>> Popularcategories;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  StreamSubscription<ConnectivityResult> subscription;
  AnimationController _controller;
  String checker = 'yes';
  String result;
  String Name;
  Animation<double> _sizeAnimation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _sizeAnimation = Tween<double>(
            begin: Screensize.textMultiplier * 2,
            end: Screensize.textMultiplier * 3.0)
        .animate(_controller);

    _sizeAnimation.addListener(() {
      setState(() {});
    });

    _controller.forward();
    Quotesoftheday = _apiData.qouteofday();
    TrendingQuotes = _apiData.trending();
    Popularcategories = _apiData.PopularCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          Quotesoftheday = _apiData.qouteofday();
          TrendingQuotes = _apiData.trending();
          Popularcategories = _apiData.PopularCategories();
          setState(() {});
        });
      },
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                TrendingQoutes(),
                SizedBox(
                  height: 10,
                ),
                QoutesoftheDay(),
                SizedBox(
                  height: 10,
                ),
                PopularCategories(),

                Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AdmobBanner(
                          adUnitId: Strings.bannerId,
                          adSize: AdmobBannerSize.BANNER),
                    )),
              ],
            )),
      ),
    );
  }

  Widget QoutesoftheDay() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.quotesOftheDay,
                style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: _sizeAnimation.value,
                    color: Customcolors.black),
              ),
              FlatButton(
                child: Text(
                  "view more",
                  style: TextStyle(color: Customcolors.green),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QoutesofDay()),
                  );
                },
              )
            ],
          ),
        ),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                gridDelegate: XSliverGridDelegate(
                  crossAxisCount: 3,
                  smallCellExtent: Screensize.heightMultiplier * 19,
                  bigCellExtent: Screensize.heightMultiplier * 19,
                ),
                itemBuilder: (context, index) {
                  return Hero(
                    tag: snapshot.data[index].p_id +
                        snapshot.data[index].p_image +
                        'HomequotesOftheDay',
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
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
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
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
                                                builder: (context) => Detail(
                                                      Name:
                                                          'HomequotesOftheDay',
                                                      Check: checker,
                                                      Image: snapshot
                                                          .data[index].p_image,
                                                      Id: snapshot
                                                          .data[index].p_id,
                                                    )));
                                      },
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong.Pull to Refresh'),
              );
            }
            return Center(
              child: CupertinoActivityIndicator(),
            );
          },
          future: Quotesoftheday,
        ),
      ],
    );
  }

  Widget TrendingQoutes() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.trendings,
                style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: _sizeAnimation.value,
                    color: Customcolors.black),
              ),
              FlatButton(
                child: Text(
                  "view more",
                  style: TextStyle(color: Customcolors.green),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetallTrendingQoutes()),
                  );
                },
              )
            ],
          ),
        ),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return CarouselSlider(
                options: CarouselOptions(
                  height: Screensize.heightMultiplier * 30,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: snapshot.data.map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          clipBehavior: Clip.antiAlias,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: i.p_image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
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
                                                  builder: (context) => Detail(
                                                      Name: 'Strings.trendings',
                                                      Check: checker,
                                                      Id: i.p_id,
                                                      Image: i.p_image)));
                                        },
                                      ))),
                            ],
                          ));
                    },
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('');
            }
            return Center(
              child: CupertinoActivityIndicator(),
            );
          },
          future: TrendingQuotes,
        ),
      ],
    );
  }

  Widget PopularCategories() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.populatCats,
                style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: _sizeAnimation.value,
                    color: Customcolors.black),
              ),
              Icon(
                Icons.arrow_forward,
                color: Customcolors.green,
              ),
            ],
          ),
        ),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Container(
                height: Screensize.heightMultiplier * 25,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,
                  // physics: ScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: snapshot.data[index].cat_image,
                            imageBuilder: (context, imageProvider) => Container(
                              width: Screensize.widthMultiplier * 40,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Center(child: Icon(Icons.error)),
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                width: Screensize.widthMultiplier * 40,
                                height: Screensize.heightMultiplier * 6,
                                color: Colors.white10,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data[index].cat_name
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Customcolors.green),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )),
                          new Positioned.fill(
                              child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Customcolors.green,
                                    onTap: () {
                                      Navigator.of(context).push(
                                          SlideRightRoute(
                                              widget: SubCategories(
                                                  ID: snapshot
                                                      .data[index].cat_id,
                                                  NAME: snapshot
                                                      .data[index].cat_name)));
                                    },
                                  ))),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('');
            }
            return Center(
              child: CupertinoActivityIndicator(),
            );
          },
          future: Popularcategories,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    _controller.dispose();

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
