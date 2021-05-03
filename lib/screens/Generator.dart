import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qoutes_app/utils/CutomToast.dart';
import 'package:flutter_grid_delegate_ext/rendering/grid_delegate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qoutes_app/utils/Customcolors.dart';
import 'package:qoutes_app/utils/Lists.dart';
import 'package:qoutes_app/utils/Screensize.dart';

class Generator extends StatefulWidget {
  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator>
    with AutomaticKeepAliveClientMixin {
  Color _selectedColor = Color(0xFFFFFFFF);
  Color _textColor = Color(0xFF000000);
  bool _labeLText = false;
  bool _enableText = false;
  File _image;
  final picker = ImagePicker();
  bool _check = true;
  FocusNode focusNode;
  List<Widget> movableItems = [];
  TextAlign _alignment = TextAlign.justify;
  Alignment _align = Alignment.center;
  String _fontFamily = '';
  double _fontSize = 18;
  bool _showSlider = false;
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 5,
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * .5,
                  child: Stack(
                    children: [
                      _image == null
                          ? Container(
                              color: _selectedColor,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(
                                        _image,
                                      ),
                                      fit: BoxFit.cover)),
                              //  height: MediaQuery.of(context).size.height * .5),
                            ),
                      Positioned.fill(
                        // top: yPosition,
                        //  left: xPosition,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: _align,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                enabled: _enableText,
                                focusNode: focusNode,
                                textInputAction: TextInputAction.done,
                                maxLines: null,
                                style: TextStyle(
                                    fontSize: _fontSize,
                                    color: _textColor,
                                    fontFamily: _fontFamily),
                                keyboardType: TextInputType.multiline,
                                textAlign: _alignment,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: _labeLText == true
                                        ? 'Enter text here'
                                        : '',
                                    hintStyle: TextStyle(fontSize: 28)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _check == true
            ? Padding(
                padding: EdgeInsets.only(
                    left: Screensize.heightMultiplier * 3,
                    right: Screensize.heightMultiplier * 3),
                child: Container(
                  height: 100,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            highlightColor: Colors.white,
                            onTap: () {
                              if (_image == null) {
                                getImage();
                              } else {
                                setState(() {
                                  _image = null;
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Customcolors.green,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  _image == null
                                      ? Icons.add_photo_alternate
                                      : Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            highlightColor: Colors.white,
                            onTap: () {
                              _showMyDialog();
                            },
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Icon(
                                  Icons.color_lens,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Customcolors.green,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            highlightColor: Colors.white,
                            onTap: () {
                              setState(() {
                                _check = false;
                              });
                            },
                            child: Container(
                              height: 50,
                              child: Center(
                                child: Icon(
                                  Icons.text_fields,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Customcolors.green,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            highlightColor: Colors.white,
                            onTap: () {
                              //   _capturePng();
                              _saveScreenshot();
                            },
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Customcolors.green,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            :

            //TEXT DESIGNING CONTAINER//
            _showSlider == true
                ? Padding(
                    padding: EdgeInsets.only(
                        left: Screensize.heightMultiplier * 3,
                        right: Screensize.heightMultiplier * 3),
                    child: Container(
                      height: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _showSlider = false;
                                });
                              }),
                          Flexible(
                            child: Slider(
                              value: _fontSize,
                              min: 15,
                              max: 50,
                              divisions: 10,
                              label: _fontSize.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _fontSize = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        left: Screensize.heightMultiplier * 3,
                        right: Screensize.heightMultiplier * 3),
                    child: Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: Lists.icons.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (index == 0) {
                                  setState(() {
                                    _check = true;
                                    _labeLText = false;
                                    _enableText = false;
                                  });
                                } else if (index == 1) {
                                  setState(() {
                                    _labeLText = true;
                                    _enableText = true;
                                  });
                                  focusNode.requestFocus();
                                } else if (index == 2) {
                                  _showDialogTextcolor();
                                } else if (index == 3) {
                                  _showDialogTexAlignment();
                                } else if (index == 4) {
                                  setState(() {
                                    if (_align == Alignment.center) {
                                      _align = Alignment.topCenter;
                                    } else {
                                      _align = Alignment.center;
                                    }
                                  });
                                } else if (index == 5) {
                                  _setFontFamilydialogue();
                                } else if (index == 6) {
                                  setState(() {
                                    _showSlider = true;
                                  });
                                }
                              },
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Lists.icons[index],
                                      size: Screensize.heightMultiplier * 4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Customcolors.green,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: Lists.colors.length,
              physics: ScrollPhysics(),
              gridDelegate: XSliverGridDelegate(
                crossAxisCount: 3,
                smallCellExtent: Screensize.heightMultiplier * 8,
                bigCellExtent: Screensize.heightMultiplier * 8,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    shadowColor: Colors.blueGrey,
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedColor = Lists.colors[index];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Lists.colors[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Customcolors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogTextcolor() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color for Text'),
          content: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: Lists.colors.length,
              physics: ScrollPhysics(),
              gridDelegate: XSliverGridDelegate(
                crossAxisCount: 3,
                smallCellExtent: Screensize.heightMultiplier * 8,
                bigCellExtent: Screensize.heightMultiplier * 8,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _textColor = Lists.colors[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1),
                          color: Lists.colors[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Customcolors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDialogTexAlignment() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Set Alignment')),
          content: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: Lists.align.length,
              physics: ScrollPhysics(),
              gridDelegate: XSliverGridDelegate(
                crossAxisCount: 2,
                smallCellExtent: Screensize.heightMultiplier * 8,
                bigCellExtent: Screensize.heightMultiplier * 8,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _alignment = Lists.align[index].align;
                      });
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(Lists.align[index].txt),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Customcolors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _setFontFamilydialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Set FontFamily')),
          content: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: Lists.fonts.length,
              physics: ScrollPhysics(),
              gridDelegate: XSliverGridDelegate(
                crossAxisCount: 2,
                smallCellExtent: Screensize.heightMultiplier * 8,
                bigCellExtent: Screensize.heightMultiplier * 8,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _fontFamily = Lists.fonts[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "QUOTES",
                            style: TextStyle(
                                fontFamily: Lists.fonts[index],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Customcolors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> getImage() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } else {
      var result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);

        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
          } else {
            print('No image selected.');
          }
        });
      }
    }
  }

  Future<void> _saveScreenshot() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      saveImage();
    } else {
      var result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        saveImage();
      }
    }
  }

  void saveImage() async {
    try {
      final RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      //create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String fullPath = '$dir/${DateTime.now().millisecond}.png';
      File capturedFile = File(fullPath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);
      await GallerySaver.saveImage(capturedFile.path).then((value) {
        CustomToast.ShowToast('Image saved Successfully');
        print("Saved");
      });
    } catch (e) {
      print("Error");
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
