import 'package:flutter/material.dart';
import 'package:my_quote/constants.dart';
import 'package:my_quote/my_quote_view.dart';
import 'package:my_quote/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/flushbar.dart';
import 'models/image_paths.dart';

class ThemesView extends StatefulWidget {
  ThemesView({Key key}) : super(key: key);

  @override
  _ThemesViewState createState() => _ThemesViewState();
}

class _ThemesViewState extends State<ThemesView> {
  ThemesView x = ThemesView();
  List<Color> colorList = [
    Colors.red,
    Colors.yellow,
    Colors.grey,
    Colors.brown,
    Colors.blue
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: cTextColor,
      body: GridView.count(
          crossAxisCount: 2,
          physics: BouncingScrollPhysics(),
          mainAxisSpacing: 15,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          childAspectRatio: 3 / 4,
          children: List.generate(imagePath.length, (index) {
            return GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                setState(() {
                  // prefs.setInt("backgroundColor", colorList[index].value);
                  prefs.setString("backgroundImage", imagePath[index].imgPath);
                  backgroundImagePath = imagePath[index].imgPath;
                });
                FlusBarBuilder(context: context, msg: "Theme Selected")
                    .build(context);
                final BottomNavigationBar navigationBar =
                    globalKey.currentWidget;
                navigationBar.onTap(0);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(5)),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imagePath[index].imgPath),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            );
          })),
    );
  }
}
