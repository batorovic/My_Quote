import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_quote/themes_view.dart';
import 'package:my_quote/constants.dart';
import 'package:my_quote/favorites_view.dart';
import 'package:my_quote/models/json_loader.dart';
import 'package:my_quote/size_config.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:my_quote/category_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/flushbar.dart';
import 'models/json_loader.dart';
import 'package:google_fonts/google_fonts.dart';

class MyQuoteView extends StatefulWidget {
  MyQuoteView({Key key}) : super(key: key);

  @override
  _MyQuoteViewState createState() => _MyQuoteViewState();
}

String backgroundImagePath;
Color babanizinColoru = cBackGroundColor;
Color newColor;

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
GlobalKey globalKey1 = new GlobalKey(debugLabel: '_future');

List result = [];
bool isChanged = false;
List fav = [];
List<dynamic> ornek = [];
String writeJsonName = "random.json";
int pageIndex = 0;
int currentPage = 0;
Future future1;
String appBartext = 'RANDOM';
String categoryText = 'RANDOM';

class _MyQuoteViewState extends State<MyQuoteView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static GlobalKey previewContainer = GlobalKey();

  final tabs = [MyQuoteView(), FavoritesView(), CategoryView(), ThemesView()];

  int bottomIndex = 0;

  PageController _pageController = new PageController();

  bool bottomNavBarSelected = false;
  bool isVisible = true;
  bool durum = false;
  bool quoteFav = false;
  bool pageRoute = false;
  File _imageFile;

  // Future _future;
  Future<String> loadJson() async => await rootBundle.loadString(
      // "/storage/emulated/0/Android/data/com.example.my_quote/files/random.json");
      "assets/random.json");

  batuhan(x) async {
    ornek = await jsonYukle(x);
  }

  batuhanFav(x) async {
    fav = await jsonYukle(x);
  }

  batuhanBaslangic(randomJson, favJson) async {
    ornek = await loadQuotes(randomJson);
    ornek.shuffle();
    fav = await jsonYukle(favJson);
  }

  @override
  void initState() {
    super.initState();
    // getSelectedBackGround();
    getBackgroundImage();
    checkPermissions();
    loadAllJsonFile();
    createFavoriteFile();
    future1 = loadJson();
    // batuhan(
    //     "/storage/emulated/0/Android/data/com.example.my_quote/files/random.json");
    batuhanBaslangic("assets/random.json",
        "/storage/emulated/0/Android/data/com.example.my_quote/files/favorites.json");

    // batuhanFav(
    //     "/storage/emulated/0/Android/data/com.example.my_quote/files/favorites.json");
  }

  getSelectedBackGround() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _seen = (prefs.getInt('backgroundColor') ?? cBackGroundColor.value);
    print(_seen);
    setState(() {
      newColor = Color(_seen);
    });

    // prefs.remove("backgroundColor");
  }

  Future getBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundImagePath = prefs.getString("backgroundImage");
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, //bar'in rengini koruduk
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.white,
            currentIndex: bottomIndex,
            backgroundColor: Colors.black,
            key: globalKey,
            onTap: (value) {
              setState(() {
                if (isChanged == true) {
                  appBartext = result[0];
                  categoryText = appBartext;

                  writeJsonName = appBartext.toLowerCase() + ".json";

                  // print(result[1]);
                  currentPage = 0;
                  pageIndex = 0;
                  isChanged = false;
                  FlusBarBuilder(context: context, msg: result[0] + " selected")
                      .build(context);
                }
                if (bottomIndex != value) {
                  bottomIndex = value;
                }
              });
            },
            items: [
              buildBottomNavigationBarItem("Home", Icon(Icons.home), null),
              buildBottomNavigationBarItem(
                  "Favorites",
                  bottomIndex == 1
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                  ""),
              buildBottomNavigationBarItem(
                  categoryText, Icon(Icons.category), null),
              buildBottomNavigationBarItem("Themes", Icon(Icons.palette), null)
            ],
          ),
          body: bottomIndex == 0
              ? RepaintBoundary(key: previewContainer, child: buildBody())
              : tabs[bottomIndex]),
    );
    // body: RepaintBoundary(key: previewContainer, child: buildBody()));
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(txt, icon, imgPath) =>
      BottomNavigationBarItem(title: Text(txt), icon: icon);

  // Text buildText() {
  //   return Text(appBartext,
  //       style: TextStyle(
  //         color: cTextColor,
  //       ));
  // }

  Column buildBody() => Column(children: [
        Expanded(
          child: Container(
              decoration: backgroundImagePath == null
                  ? BoxDecoration(
                      color: cBackGroundColor /*cBackGroundColor */,
                    )
                  : BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(backgroundImagePath),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.1), BlendMode.srcOver),
                      ),
                    ),
              child: buildFutureBuilder()),
        ),
      ]);

  // FittedBox buildQuotes() => FittedBox(
  //       fit: BoxFit.fill,
  //       child: Container(
  //         // color: durum ? newColor /*cBackGroundColor */ : Colors.transparent,
  //         child: buildFutureBuilder(),
  //         // child: futureWidget(),
  //       ),
  //     );

  FutureBuilder buildFutureBuilder() => FutureBuilder(
        future: future1,
        builder: getJsonData,
      );

  Widget getJsonData(context, snapshot) {
    var info = json.decode(snapshot.data.toString());

    if (snapshot.hasData) {
      return buildPageView(ornek.length);
    } else {}
    return Center(child: CircularProgressIndicator());
  }

  PageView buildPageView(infoLen) => PageView.custom(
        //Mevcut sayfanin indexi
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
        controller: PageController(initialPage: pageIndex),
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10)),
              child: jsonDataConfig(ornek, index));
        }, childCount: infoLen),
      );

  SizedBox jsonDataConfig(info, int index) => SizedBox(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              quoteText(info, index),
              SizedBox(height: getProportionateScreenHeight(30)),
              quoteAuthor(info, index),
              SizedBox(height: getProportionateScreenHeight(30)),
              Visibility(visible: isVisible, child: quoteIcons(info, index))
            ]),
      );

  Text quoteAuthor(info, int index) => Text(
        "- " + info[index]["quoteAuthor"],
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      );

  Text quoteText(info, int index) => Text(
        info[index]["quoteText"],
        style: GoogleFonts.lato(
          textStyle: Theme.of(context).textTheme.headline4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        ),
        // style: Theme.of(context).textTheme.headline4.copyWith(
        //       color: Colors.white,
        //       fontWeight: FontWeight.bold,
        //       fontStyle: FontStyle.italic,
        //     ),
        textAlign: TextAlign.center,
        // style: TextStyle(
        //     color: cQuoteTextColor,
        //     fontSize: getProportionateScreenHeight(30),
        //     fontWeight: FontWeight.bold),
        // textAlign: TextAlign.center,
      );

  Flushbar buildFlusbar(String msg) => Flushbar(
        message: msg,
        flushbarPosition: FlushbarPosition.TOP,
        margin: EdgeInsets.all(8),
        leftBarIndicatorColor: Colors.blue[300],

        borderRadius: 8,
        // flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 1),
      )..show(context);

  Row quoteIcons(info, index) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
            onTap: () async {
              if (ornek[index]["favStatus"]) {
                // snackBar("Removed from favorites");
                FlusBarBuilder(context: context, msg: "Removed from favorites")
                    .build(context);

                fav.removeWhere((element) =>
                    element["quoteText"] == ornek[index]["quoteText"]);
              } else {
                FlusBarBuilder(context: context, msg: "Added to favorites.")
                    .build(context);

                fav.add({
                  "id": ornek[index]["id"],
                  "quoteText": ornek[index]["quoteText"],
                  "quoteAuthor": ornek[index]["quoteAuthor"],
                  "category": writeJsonName,
                });
              }

              setState(() {
                ornek[index]["favStatus"] = !ornek[index]["favStatus"];
              });
              write(fav, "favorites.json");
              write(ornek, writeJsonName);
            },
            // child: Icon(Icons.favorite, color: Colors.redAccent)),
            child: ornek[index]["favStatus"]
                ? Icon(Icons.favorite, color: Colors.redAccent)
                : Icon(Icons.favorite_border, color: Colors.redAccent)),

        SizedBox(width: getProportionateScreenWidth(25)),
        InkWell(
            onTap: () {
              widgetVisiblity();
              setState(() {
                durum = !durum;
              });
              Timer(Duration(milliseconds: 30), () => convertWidgetoImage());
            },
            child: Icon(Icons.share)),

        // child: SvgPicture.asset(
        //   "images/export.svg",
        //   height: getProportionateScreenHeight(45),
        //   color: Colors.white,
        // ))
      ]);

  // dosya silme islemi

  Future<File> get _localFile async {
    final path =
        "/storage/emulated/0/Android/data/com.example.my_quote/files/naber.json";
    print('path ${path}');
    return File('$path');
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {
      print("error");
      return 0;
    }
  }

  void convertWidgetoImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        previewContainer.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 2);

    final directory = (await getExternalStorageDirectory()).path;

    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8list = byteData.buffer.asUint8List();
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(uint8list);

    final RenderBox box = context.findRenderObject();

    await Share.shareFiles(['$directory/screenshot.png'],
        text: "Check out my favorite quote from " +
            ornek[pageIndex]["quoteAuthor"],
        subject: "QUOTE",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

    setState(() {
      durum = !durum;
      print(durum);
    });
    widgetVisiblity();
  }

  void widgetVisiblity() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void snackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        msg,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }
}
