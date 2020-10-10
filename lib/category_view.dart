import 'package:flutter/material.dart';
import 'package:my_quote/constants.dart';
import 'package:my_quote/models/json_loader.dart';
import 'package:my_quote/size_config.dart';
import 'package:my_quote/models/category.dart';
import 'package:my_quote/my_quote_view.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  String _categoryText;
  String _jsonPath;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: cTextColor,
          // appBar: buildAppBar(),
          body: GridView.count(
            physics: BouncingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            childAspectRatio: 3 / 4.5,
            children: List.generate(categoryList.length, (index) {
              return GestureDetector(
                child: buildCard(categoryList[index].categoryName,
                    categoryList[index].imgPath),
                onTap: () async {
                  _categoryText = categoryList[index].categoryName;
                  _jsonPath = categoryList[index].json;

                  result = [_categoryText, _jsonPath];
                  isChanged = true;
                  setState(() {
                    ornek.shuffle();
                    write(ornek, writeJsonName);
                    future1 = readMyCatJson(result[1]);
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    ornek = await jsonYukle(result[1]);
                  });

                  final BottomNavigationBar navigationBar =
                      globalKey.currentWidget;
                  navigationBar.onTap(0);
                  // ornek = await jsonYukle(result[1]);

                  // Navigator.pop(context, [_categoryText, _jsonPath]);
                },
              );
            }),
          )),
    );
  }

  AppBar buildAppBar() => AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: cBackGroundColor,
        elevation: 0,
        title: Text("Categories"),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(25),
            child: Icon(Icons.arrow_back)),
      );

  Container buildCard(String titleText, String imgName) => Container(
        child: Card(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 30,
                left: 0,
                bottom: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: getProportionateScreenWidth(150),
                    height: getProportionateScreenHeight(180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(imgName),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 35,
                left: 0,
                bottom: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    titleText,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
