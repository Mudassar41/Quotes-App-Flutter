import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qoutes_app/models/Images.dart';
import 'package:qoutes_app/provider/LikeProvider.dart';
import 'package:qoutes_app/services/SqliteHelper.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/CutomToast.dart';
import 'package:qoutes_app/utils/Screensize.dart';
import 'package:qoutes_app/utils/strings.dart';

class Detail extends StatefulWidget {
  final String Image;
  final String Id;
  final String Check;
  final String Name;

  const Detail({
    Key key,
    this.Image,
    this.Id,
    this.Check,
    this.Name,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool downloading = false;
  var progressString = "";
  Images _images = Images();
  SqliteHelper helper = SqliteHelper();
  LikeProvider _likeProvider;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    _likeProvider = Provider.of<LikeProvider>(context);
    helper.isQuoteisLiked(widget.Id, _likeProvider);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Card(
          elevation: 5,
          child: new Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: IconButton(
                  icon: Icon(
                    Icons.save_alt,
                    color: Customcolors.green,
                  ),
                  onPressed: () {
                    downloadPermission();
                    //downloadFile();
                    //  _asyncMethod();
                  },
                )),
                Expanded(
                    child: IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Customcolors.green,
                  ),
                  onPressed: () {
                    _shareImageFromUrl();
                  },
                  // child: Text("Checkout"),
                )),
                Expanded(
                    child: widget.Check == 'yes'
                        ? IconButton(
                            icon: Icon(
                              helper.chek == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Customcolors.green,
                            ),
                            onPressed: () {
                              _images.p_id = widget.Id;
                              _images.p_image = widget.Image;
                              helper.AddPhoto(_images);
                              setState(() {
                                helper.chek = true;
                              });
                            },
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Customcolors.green,
                            ),
                            onPressed: () {
                              _images.p_id = widget.Id;
                              _images.p_image = widget.Image;
                              helper.DeletePhoto(widget.Id);
                              Navigator.pop(context);
                              //   _likeProvider.AddPhoto(_images);
                              //  helper.AddPhoto(_images);
                            },
                          ))
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: Screensize.heightMultiplier * 12,
              bottom: Screensize.heightMultiplier * 12,
              left: 10,
              right: 10),
          child: Stack(
            children: [
              Hero(
                tag: widget.Id + widget.Image + widget.Name,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: CachedNetworkImage(
                    imageUrl: widget.Image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                           ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                top: Screensize.heightMultiplier,
                left: Screensize.widthMultiplier + 4,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_back,
                      size: Screensize.imageSizeMultiplier * 4,
                      color: Customcolors.green,
                    ),
                    height: Screensize.imageSizeMultiplier + 45,
                    width: Screensize.imageSizeMultiplier + 40,
                    decoration: BoxDecoration(
                        color: Colors.white38, shape: BoxShape.circle),
                  ),
                ),
              ),
              Positioned.fill(
                  child: Center(
                child: downloading
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Downloading File: $progressString",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    : Text(""),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareImageFromUrl() async {
    try {
      CustomToast.ShowToast('Please wait..');
      var request = await HttpClient().getUrl(Uri.parse(widget.Image));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Qotue', 'Qotue.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
      CustomToast.ShowToast(e);
    }
  }

  Future<void> downloadPermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      downloadImage();
    } else {
      var result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        downloadImage();
      }
    }
  }

  Future<void> downloadImage() async {
    try {
      var imageId = await ImageDownloader.downloadImage(widget.Image,
          destination: AndroidDestinationType.directoryDownloads);
      if (imageId == null) {
        return;
      } else {
        var fileName = await ImageDownloader.findName(imageId);
        var path = await ImageDownloader.findPath(imageId);
        var size = await ImageDownloader.findByteSize(imageId);
        var mimeType = await ImageDownloader.findMimeType(imageId);
        CustomToast.ShowToast("Successfully downloaded");
      }
    } on PlatformException catch (error) {
      print(error);
      CustomToast.ShowToast("Some Error occured");
    }
  }


}
