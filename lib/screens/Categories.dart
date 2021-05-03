import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:qoutes_app/apiconfig/ApiData.dart';
import 'package:qoutes_app/screens/SubCategories.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/widgets/SlideRightRoute.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool value = true;
  FocusNode focusNode;
  ApiData _apiData = ApiData();
  FocusScopeNode currentFocus;
  TextEditingController editingController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 3));
        setState(() {});
      },
      child: Container(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: Customcolors.green,
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    focusNode: focusNode,
                    controller: editingController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: value == true
                            ? IconButton(
                                icon: Icon(Icons.search),
                              )
                            : IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    value = true;
                                    editingController.clear();
                                  });
                                },
                              ),
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                    onChanged: (val) {
                      setState(() {
                        value = false;
                      });

                      print(value);
                    },
                  ),
                ),
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      // TODO: Handle this case.
                      return Center(
                        child: Text("No Internet Connection"),
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
                                smallCellExtent:
                                    Screensize.heightMultiplier * 32,
                                bigCellExtent: Screensize.heightMultiplier * 32,
                              ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              snapshot.data[index].cat_image,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Center(child: Icon(Icons.error)),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Customcolors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                //width: MediaQuery.of(context).size.width,
                                                height: Screensize
                                                        .heightMultiplier *
                                                    5,

                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '${snapshot.data[index].cat_name}'
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Positioned.fill(
                                            child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  splashColor:
                                                      Customcolors.green,
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        SlideRightRoute(
                                                            widget: SubCategories(
                                                                ID: snapshot
                                                                    .data[index]
                                                                    .cat_id,
                                                                NAME: snapshot
                                                                    .data[index]
                                                                    .cat_name)));
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
                future: value == true
                    ? _apiData.AllCategories()
                    : _apiData.Searchqoute(editingController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
