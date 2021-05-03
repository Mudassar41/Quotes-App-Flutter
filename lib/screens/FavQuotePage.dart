import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:provider/provider.dart';
import 'package:qoutes_app/provider/ConnectivityProvider.dart';
import 'package:qoutes_app/provider/LikeProvider.dart';
import 'package:qoutes_app/services/ConnectionService.dart';
import 'package:qoutes_app/services/SqliteHelper.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';
import 'Detail.dart';

class FavQuotePage extends StatefulWidget {
  @override
  _FavQuotePageState createState() => _FavQuotePageState();
}

class _FavQuotePageState extends State<FavQuotePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  LikeProvider _provider;
  SqliteHelper _sqliteHelper = SqliteHelper();
  String checker = 'no';
  AnimationController _controller;
  Animation<Offset> _slideRightToLeft;
  String Name;
  ConnectivityProvider connectivityProvider;
  ConnectionService connectionService = ConnectionService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Check();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideRightToLeft = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(_controller);

    _slideRightToLeft.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _provider = Provider.of<LikeProvider>(context);
    connectivityProvider = Provider.of<ConnectivityProvider>(context);
    connectionService.checkConnection(connectivityProvider);
    _sqliteHelper.getiteminCart(_provider);
    _sqliteHelper.GetData(_provider);

    return Scaffold(
      body: Container(
        child: connectivityProvider.connectionStatus != 'None'
            ? AnimatedBuilder(
          animation: _controller,
          child: _provider.Total == 0
              ? Center(
              child: Text(
                "No Liked Quotes",
                style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontWeight: FontWeight.bold,
                    fontSize: Screensize.textMultiplier * 3.3,
                    color: Customcolors.black),
              ))
              : FutureBuilder(
            future: _provider.getLikedImages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  gridDelegate: XSliverGridDelegate(
                    crossAxisCount: 2,
                    smallCellExtent:
                    Screensize.heightMultiplier * 30,
                    bigCellExtent: Screensize.heightMultiplier * 34,
                  ),
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: snapshot.data[index].p_id +
                          snapshot.data[index].p_image +
                          "Liked",
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Customcolors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Center(
                                child:
                                CupertinoActivityIndicator()),
                            Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snapshot
                                            .data[index].p_image),
                                        fit: BoxFit.fill))),
                            Positioned.fill(
                                child: new Material(
                                    color: Colors.transparent,
                                    child: new InkWell(
                                      splashColor:
                                      Customcolors.green,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    Detail(
                                                      Name:
                                                      "Liked",
                                                      Check:
                                                      checker,
                                                      Image: snapshot
                                                          .data[
                                                      index]
                                                          .p_image,
                                                      Id: snapshot
                                                          .data[
                                                      index]
                                                          .p_id,
                                                    )));
                                      },
                                    ))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Center(child: CupertinoActivityIndicator());
            },
          ),
          builder: (context, Widget child) {
            return SlideTransition(
              position: _slideRightToLeft,
              child: child,
            );
          },
        )
            : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NO INTERNET',
                style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontWeight: FontWeight.bold,
                    color: Customcolors.green),
              ),
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    setState(() {});
                  })
            ],
          ),
        ),
      ),
    );
  }

  void Check() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
          setState(() {
            _connectionStatus = event.toString();
          });
        });
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
