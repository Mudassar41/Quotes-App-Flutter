import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:qoutes_app/apiconfig/ApiData.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';
import 'package:qoutes_app/widgets/SlideRightRoute.dart';
import 'Detail.dart';

class SubCategories extends StatefulWidget {
  final String ID;
  final String NAME;

  const SubCategories({Key key, this.ID, this.NAME}) : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  ApiData _apiData = ApiData();
  String checker = 'yes';
  @override
  void initState() {
    super.initState();
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.NAME} Quotes'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              return Center(
                child: Text('No Internet Connection'),
              );
              break;
            case ConnectionState.waiting:
              return Center(
                child: CupertinoActivityIndicator(),
              );
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              return snapshot.hasData
                  ? GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      gridDelegate: XSliverGridDelegate(
                        crossAxisCount: 2,
                        smallCellExtent: Screensize.heightMultiplier * 32,
                        bigCellExtent: Screensize.heightMultiplier * 32,
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          child: Hero(
                            tag: snapshot.data[index].p_id +
                                snapshot.data[index].p_image +
                                widget.NAME,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: snapshot.data[index].p_image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    clipBehavior: Clip.antiAlias,
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
                                                    builder: (context) =>
                                                        Detail(
                                                            Name: widget.NAME,
                                                            Check: checker,
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
        future: _apiData.GetSubCategories(widget.ID),
      ),
    );
  }
  InterstitialAd myInterstitial = InterstitialAd(
    adUnitId: Strings.interAd,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
