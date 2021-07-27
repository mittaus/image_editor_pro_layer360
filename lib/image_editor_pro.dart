import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_editor_pro/modules/all_emojies.dart';
import 'package:image_editor_pro/modules/bottombar_container.dart';
import 'package:image_editor_pro/modules/colors_picker.dart';
import 'package:image_editor_pro/modules/emoji.dart';
import 'package:image_editor_pro/modules/text.dart';
import 'package:image_editor_pro/modules/textview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';

TextEditingController heightcontroler = TextEditingController();
TextEditingController widthcontroler = TextEditingController();
double width = 300;
double height = 300;

List fontsize = [];
var howmuchwidgetis = 0;
List multiwidget = [];
Color currentcolors = Colors.white;
var opicity = 0.0;
SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.green);

class ImageEditorPro extends StatefulWidget {
  final Color appBarColor;
  final Color bottomBarColor;
  ImageEditorPro({this.appBarColor, this.bottomBarColor});

  @override
  _ImageEditorProState createState() => _ImageEditorProState();
}

var slider = 0.0;

class _ImageEditorProState extends State<ImageEditorPro> {
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    var points = _controller.points;
    _controller = SignatureController(penStrokeWidth: 5, penColor: color, points: points);
  }

  List<Offset> offsets = [];
  Offset offset1 = Offset.zero;
  Offset offset2 = Offset.zero;
  final scaf = GlobalKey<ScaffoldState>();
  var openbottomsheet = false;
  List<Offset> _points = <Offset>[];
  List type = [];
  List aligment = [];

  final GlobalKey container = GlobalKey();
  final GlobalKey globalKey = new GlobalKey();
  File _image;
  String descripcion;
  ScreenshotController screenshotController = ScreenshotController();
  Timer timeprediction;
  double aspectRadio = 1;
  void timers() {
    Timer.periodic(Duration(milliseconds: 10), (tim) {
      setState(() {});
      timeprediction = tim;
    });
  }

  @override
  void dispose() {
    timeprediction.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    timers();
    _controller.clear();
    type.clear();
    fontsize.clear();
    offsets.clear();
    multiwidget.clear();
    howmuchwidgetis = 0;
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 500), () => bottomsheets());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    setState(() {
      width = size.width;
      height = size.height - (2 * kBottomNavigationBarHeight);
    });
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey,
      key: scaf,
      /* appBar: new AppBar(
            actions: <Widget>[
              new IconButton(
                  icon: Icon(FontAwesomeIcons.boxes),
                  onPressed: () {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: new Text("Seleccionar ancho y alto"),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      height = int.parse(heightcontroler.text);
                                      width = int.parse(widthcontroler.text);
                                    });
                                    heightcontroler.clear();
                                    widthcontroler.clear();
                                    Navigator.pop(context);
                                  },
                                  child: new Text("Aceptar"))
                            ],
                            content: new SingleChildScrollView(
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Text("Definir altura"),
                                  new SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                      controller: heightcontroler,
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          hintText: 'Altura',
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder())),
                                  new SizedBox(
                                    height: 10,
                                  ),
                                  new Text("Definir ancho"),
                                  new SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                      controller: widthcontroler,
                                      keyboardType:
                                          TextInputType.numberWithOptions(),
                                      decoration: InputDecoration(
                                          hintText: 'Ancho',
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          border: OutlineInputBorder())),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
              new IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.points.clear();
                    setState(() {});
                  }),
              new IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    bottomsheets();
                  }),
              new FlatButton(
                  child: new Text("Aceptar"),
                  textColor: Colors.white,
                  onPressed: () {
                    File _imageFile;
                    _imageFile = null;
                    screenshotController
                        .capture(
                            delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                        .then((File image) async {
                      //print("Capture Done");
                      setState(() {
                        _imageFile = image;
                      });
                      final paths = await getExternalStorageDirectory();
                      image.copy(paths.path +
                          '/' +
                          DateTime.now().millisecondsSinceEpoch.toString() +
                          '.png');
                      Navigator.pop(context, image);
                    }).catchError((onError) {
                      print(onError);
                    });
                  }),
            ],
            backgroundColor: widget.appBarColor,
          ), */
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: widget.bottomBarColor, boxShadow: [BoxShadow(blurRadius: 10.9)]),
              height: kBottomNavigationBarHeight,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Tooltip(
                    message: 'Cortar',
                    child: BottomBarContainer(
                      iconColor: widget.appBarColor,
                      colors: Colors.white,
                      icons: FontAwesomeIcons.cut,
                      ontap: () async {
                        // raise the [showDialog] widget
                        if (_image != null) {
                          File resultImage = await ImageCropper.cropImage(
                              sourcePath: _image.path,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.square,
                                CropAspectRatioPreset.ratio3x2,
                                CropAspectRatioPreset.original,
                                CropAspectRatioPreset.ratio4x3,
                                CropAspectRatioPreset.ratio16x9
                              ],
                              androidUiSettings: AndroidUiSettings(
                                  toolbarTitle: 'Cortar Imagen',
                                  toolbarColor: widget.appBarColor,
                                  toolbarWidgetColor: Colors.white,

                                  //toolbarWidgetColor:widget.appBarColor,
                                  initAspectRatio: CropAspectRatioPreset.original,
                                  lockAspectRatio: false),
                              iosUiSettings: IOSUiSettings(
                                minimumAspectRatio: 1.0,
                              ));
                          if (resultImage != null) {
                            _image = resultImage;
                          }
                          setState(() {});
                        }
                      },
                      title: 'Cortar',
                    ),
                  ),
                  Tooltip(
                    message: 'Emoticono',
                    child: BottomBarContainer(
                      iconColor: widget.appBarColor,
                      colors: Colors.white,
                      icons: FontAwesomeIcons.smile,
                      ontap: () {
                        Future getemojis = showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Emojies();
                            });
                        getemojis.then((value) {
                          if (value != null) {
                            type.add(1);
                            fontsize.add(20);
                            offsets.add(Offset.zero);
                            multiwidget.add(value);
                            howmuchwidgetis++;
                          }
                        });
                      },
                      title: 'Emoticono',
                    ),
                  ),
                  Tooltip(
                    message: 'Texto',
                    child: BottomBarContainer(
                      iconColor: widget.appBarColor,
                      colors: Colors.white,
                      icons: Icons.text_fields_sharp,
                      ontap: () async {
                        final value = await Navigator.push(context, MaterialPageRoute(builder: (context) => TextEditor()));
                        if (value.toString().isEmpty || value.toString().trim() == '') {
                          print("true");
                        } else {
                          type.add(2);
                          fontsize.add(20);
                          offsets.add(Offset(width / 2, height / 2));
                          multiwidget.add(value);
                          howmuchwidgetis++;
                        }
                      },
                      title: 'Texto',
                    ),
                  ),
                  Tooltip(
                    message: 'Borrador',
                    child: BottomBarContainer(
                      iconColor: widget.appBarColor,
                      colors: Colors.white,
                      icons: FontAwesomeIcons.eraser,
                      ontap: () {
                        _controller.clear();
                        type.clear();
                        fontsize.clear();
                        offsets.clear();
                        multiwidget.clear();
                        howmuchwidgetis = 0;
                      },
                      title: 'Borrador',
                    ),
                  ),
                  /* BottomBarContainer(
                          iconColor: widget.appBarColor,
                          colors: Colors.white,
                          icons: Icons.photo,
                          ontap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ColorPiskersSlider();
                                });
                          },
                          title: 'Filtro',
                        ), */
                  Tooltip(
                    message: 'Pincel',
                    child: BottomBarContainer(
                      iconColor: widget.appBarColor,
                      colors: Colors.white,
                      icons: FontAwesomeIcons.paintBrush,
                      ontap: () {
                        // raise the [showDialog] widget
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Elije un color'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                    showLabel: true,
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: const Text('Entendido'),
                                    onPressed: () {
                                      setState(() => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      title: 'Brocha',
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  //margin: EdgeInsets.all(20),
                  color: Colors.white,
                  width: width.toDouble(),
                  height: height.toDouble() - MediaQuery.of(context).padding.top,
                  child: RepaintBoundary(
                      key: globalKey,
                      child: Stack(
                        children: <Widget>[
                          _image != null
                              ? Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: Image.file(
                                      _image,
                                      /* height: height.toDouble(),
                                            width: width.toDouble(),
                                            fit: BoxFit.cover, */
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            child: GestureDetector(
                                onPanUpdate: (DragUpdateDetails details) {
                                  setState(() {
                                    RenderBox object = context.findRenderObject();
                                    Offset _localPosition = object.globalToLocal(details.globalPosition);
                                    _points = new List.from(_points)..add(_localPosition);
                                  });
                                },
                                onPanEnd: (DragEndDetails details) {
                                  _points.add(null);
                                },
                                child: Signat()),
                          ),
                          Stack(
                            children: multiwidget.asMap().entries.map((f) {
                              return type[f.key] == 1
                                  ? EmojiView(
                                      left: offsets[f.key].dx,
                                      top: offsets[f.key].dy,
                                      ontap: () {
                                        scaf.currentState.showBottomSheet((context) {
                                          return Sliders(
                                            size: f.key,
                                            sizevalue: fontsize[f.key].toDouble(),
                                          );
                                        });
                                      },
                                      onpanupdate: (details) {
                                        setState(() {
                                          offsets[f.key] = Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                        });
                                      },
                                      value: f.value.toString(),
                                      fontsize: fontsize[f.key].toDouble(),
                                      align: TextAlign.center,
                                    )
                                  : type[f.key] == 2
                                      ? TextView(
                                          left: offsets[f.key].dx,
                                          top: offsets[f.key].dy,
                                          ontap: () {
                                            scaf.currentState.showBottomSheet((context) {
                                              return Sliders(
                                                size: f.key,
                                                sizevalue: fontsize[f.key].toDouble(),
                                              );
                                            });
                                          },
                                          onpanupdate: (details) {
                                            setState(() {
                                              offsets[f.key] = Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                            });
                                          },
                                          value: f.value.toString(),
                                          fontsize: fontsize[f.key].toDouble(),
                                          align: TextAlign.center,
                                        )
                                      : new Container();
                            }).toList(),
                          )
                        ],
                      )),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: kBottomNavigationBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /* new IconButton(
                    icon: Icon(FontAwesomeIcons.boxes),
                    onPressed: () {
                      showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: new Text("Seleccionar ancho y alto"),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          height = double.parse(heightcontroler.text);
                                          width = double.parse(widthcontroler.text);
                                        });
                                        heightcontroler.clear();
                                        widthcontroler.clear();
                                        Navigator.pop(context);
                                      },
                                      child: new Text("Aceptar"))
                                ],
                                content: new SingleChildScrollView(
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text("Definir altura"),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                          controller: heightcontroler,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: 'Altura',
                                              contentPadding:
                                                  EdgeInsets.only(left: 10),
                                              border: OutlineInputBorder())),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      new Text("Definir ancho"),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                          controller: widthcontroler,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: 'Ancho',
                                              contentPadding:
                                                  EdgeInsets.only(left: 10),
                                              border: OutlineInputBorder())),
                                    ],
                                  ),
                                ),
                              );
                            });
                  }), */
                  /* new IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.points.clear();
                        setState(() {});
                      }), */
                  new IconButton(
                      icon: Icon(Icons.camera),
                      onPressed: () {
                        bottomsheets();
                      }),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Añade una descripción',
                        ),
                        onChanged: (value) {
                          descripcion = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.appBarColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: new IconButton(
                          color: widget.appBarColor,
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // File _imageFile;
                            // _imageFile = null;
                            screenshotController.capture(delay: Duration(milliseconds: 500), pixelRatio: 1.5).then((Uint8List image) async {
                              //print("Capture Done");
                              File _file = File.fromRawPath(image);
                              // setState(() {
                              //   _imageFile = _file;
                              // });
                              final paths = await getExternalStorageDirectory();
                              _file.copy(paths.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.png');
                              Navigator.pop(context, [image, descripcion?.trim()]);
                            }).catchError((onError) {
                              print(onError);
                            });
                          }),
                    ),
                  ),
                  /* BottomBarContainer(
                    colors: widget.appBarColor,
                    iconColor: Colors.white,
                    icons: Icons.navigate_next,
                    ontap: () async {
                      final value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TextEditor()));
                      if (value.toString().isEmpty) {
                        print("true");
                      } else {
                        type.add(2);
                        fontsize.add(20);
                        offsets.add(Offset.zero);
                        multiwidget.add(value);
                        howmuchwidgetis++;
                      }
                    },
                    title: 'Aceptar',
                  ), */
                  /* new FlatButton(
                      child: new Text("Aceptar"),
                      textColor: Colors.white,
                      onPressed: () {
                        File _imageFile;
                        _imageFile = null;
                        screenshotController
                            .capture(
                                delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                            .then((File image) async {
                          //print("Capture Done");
                          setState(() {
                            _imageFile = image;
                          });
                          final paths = await getExternalStorageDirectory();
                          image.copy(paths.path +
                              '/' +
                              DateTime.now().millisecondsSinceEpoch.toString() +
                              '.png');
                          Navigator.pop(context, image);
                        }).catchError((onError) {
                          print(onError);
                        });
                      }
                  ), */
                ],
              ),
            )
          ],
        ),
      ),
      /* bottomNavigationBar: Center(
            ,
          ), */
      /* bottomNavigationBar: openbottomsheet
              ? new Container()
              : Container(
                  decoration: BoxDecoration(
                      color: widget.bottomBarColor,
                      boxShadow: [BoxShadow(blurRadius: 10.9)]),
                  height: 70,
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      BottomBarContainer(
                        colors: widget.bottomBarColor,
                        icons: FontAwesomeIcons.brush,
                        ontap: () {
                          // raise the [showDialog] widget
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: const Text('Elije un color'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: pickerColor,
                                    onColorChanged: changeColor,
                                    showLabel: true,
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: const Text('Entendido'),
                                    onPressed: () {
                                      setState(() => currentColor = pickerColor);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                        },
                        title: 'Brocha',
                      ),
                      BottomBarContainer(
                        icons: Icons.text_fields,
                        ontap: () async {
                          final value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextEditor()));
                          if (value.toString().isEmpty) {
                            print("true");
                          } else {
                            type.add(2);
                            fontsize.add(20);
                            offsets.add(Offset.zero);
                            multiwidget.add(value);
                            howmuchwidgetis++;
                          }
                        },
                        title: 'Texto',
                      ),
                      BottomBarContainer(
                        icons: FontAwesomeIcons.eraser,
                        ontap: () {
                          _controller.clear();
                          type.clear();
                          fontsize.clear();
                          offsets.clear();
                          multiwidget.clear();
                          howmuchwidgetis = 0;
                        },
                        title: 'Borrador',
                      ),
                      BottomBarContainer(
                        icons: Icons.photo,
                        ontap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ColorPiskersSlider();
                              });
                        },
                        title: 'Filtro',
                      ),
                      BottomBarContainer(
                        icons: FontAwesomeIcons.smile,
                        ontap: () {
                          Future getemojis = showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Emojies();
                              });
                          getemojis.then((value) {
                            if (value != null) {
                              type.add(1);
                              fontsize.add(20);
                              offsets.add(Offset.zero);
                              multiwidget.add(value);
                              howmuchwidgetis++;
                            }
                          });
                        },
                        title: 'Emoticono',
                      ),
                    ],
                  ),
                )), */
    ));
  }

  void bottomsheets() {
    openbottomsheet = true;
    setState(() {});
    Future<void> future = showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey[400])]),
          height: 170,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Text("Opciones de elegir imagen"),
              ),
              Divider(
                height: 1,
              ),
              new Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.photo_library),
                                  onPressed: () async {
                                    XFile image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                    Uint8List bytes = await image.readAsBytes();
                                    var decodedImage = await decodeImageFromList(bytes);

                                    setState(() {
                                      height = decodedImage.height.toDouble();
                                      width = decodedImage.width.toDouble();
                                      aspectRadio = decodedImage.height / decodedImage.width;
                                      _image = File.fromRawPath(bytes);
                                    });
                                    setState(() => _controller.clear());
                                    Navigator.pop(context);
                                  }),
                              SizedBox(width: 10),
                              Text("Abrir de galería")
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () async {
                                  var image = await ImagePicker().pickImage(source: ImageSource.camera);
                                  Uint8List bytes = await image.readAsBytes();
                                  var decodedImage = await decodeImageFromList(bytes);

                                  setState(() {
                                    height = decodedImage.height.toDouble() - (2 * kBottomNavigationBarHeight);
                                    width = decodedImage.width.toDouble();
                                    aspectRadio = decodedImage.height / decodedImage.width;
                                    _image = File.fromRawPath(bytes);
                                  });
                                  setState(() => _controller.clear());
                                  Navigator.pop(context);
                                }),
                            SizedBox(width: 10),
                            Text("Abrir cámara")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    openbottomsheet = false;
    setState(() {});
  }
}

class Signat extends StatefulWidget {
  @override
  _SignatState createState() => _SignatState();
}

class _SignatState extends State<Signat> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  @override
  Widget build(BuildContext context) {
    return //SIGNATURE CANVAS
        //SIGNATURE CANVAS
        ListView(
      children: <Widget>[
        Signature(controller: _controller, height: height.toDouble(), width: width.toDouble(), backgroundColor: Colors.transparent),
      ],
    );
  }
}

class Sliders extends StatefulWidget {
  final int size;
  final sizevalue;
  const Sliders({Key key, this.size, this.sizevalue}) : super(key: key);
  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizevalue;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Tamaño"),
            ),
            Divider(
              height: 1,
            ),
            new Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  setState(() {
                    fontsize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    slider = v;
                    print(v.toInt());
                    fontsize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

class ColorPiskersSlider extends StatefulWidget {
  @override
  _ColorPiskersSliderState createState() => _ColorPiskersSliderState();
}

class _ColorPiskersSliderState extends State<ColorPiskersSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 260,
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Text("Slider Filter Color"),
          ),
          Divider(
            height: 1,
          ),
          SizedBox(height: 20),
          new Text("Slider Color"),
          SizedBox(height: 10),
          BarColorPicker(
              width: 300,
              thumbColor: Colors.white,
              cornerRadius: 10,
              pickMode: PickMode.Color,
              colorListener: (int value) {
                setState(() {
                  //  currentColor = Color(value);
                });
              }),
          SizedBox(height: 20),
          new Text("Slider Opicity"),
          SizedBox(height: 10),
          Slider(value: 0.1, min: 0.0, max: 1.0, onChanged: (v) {})
        ],
      ),
    );
  }
}
