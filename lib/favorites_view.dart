import 'package:flutter/material.dart';
import 'package:my_quote/constants.dart';
import 'package:my_quote/models/json_loader.dart';
import 'package:my_quote/my_quote_view.dart';
import 'package:my_quote/size_config.dart';

import 'components/flushbar.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({
    Key key,
  }) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: cTextColor,
        body: fav.length != 0
            ? GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 15,
                childAspectRatio: 10 / 4,
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                physics: BouncingScrollPhysics(),
                children: List.generate(fav.length, (index) {
                  return Dismissible(
                    onDismissed: (e) async {
                      String cateName;
                      int id;
                      String quote;
                      setState(() {
                        cateName = fav[index]["category"];
                        id = fav[index]["id"];
                        quote = fav[index]["quoteText"];
                        fav.removeAt(index);
                      });
                      if (writeJsonName == cateName) {
                        ornek.forEach((element) {
                          if (element["quoteText"] == quote) {
                            element["favStatus"] = false;
                          }
                        });

                        jsonWrite(ornek, index, cateName);
                      } else {
                        removeFav(index, cateName, id);
                      }

                      FlusBarBuilder(
                              context: context, msg: "Removed from favorites")
                          .build(context);
                    },
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xffee9617), Color(0xfffe5858)],
                          )),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            fav[index]["quoteText"],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '- ' + fav[index]["quoteAuthor"],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            : Center(
                child: Text(
                  "Your favorite list is empty.",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       // Dismissible(
        //       //   direction: DismissDirection.endToStart,
        //       //   key: UniqueKey(),
        //       //   background: Container(
        //       //     margin: EdgeInsets.all(4.0),
        //       //     decoration: BoxDecoration(
        //       //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //       //       color: Colors.white,
        //       //     ),
        //       //     alignment: AlignmentDirectional.centerEnd,
        //       //     child: Icon(
        //       //       Icons.delete,
        //       //       color: Colors.black,
        //       //     ),
        //       //   ),
        //       //   child: Container(
        //       //     width: 150,
        //       //     height: 50,
        //       //     child: Card(
        //       //       color: Colors.red,
        //       //     ),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  void jsonWrite(list, index, jsonName) {
    write(list, jsonName);
    write(fav, "favorites.json");
  }

  void removeFav(int index, jsonName, id) async {
    final ornekk = await jsonYukle(
        "/storage/emulated/0/Android/data/com.example.my_quote/files/" +
            jsonName);

    ornekk.forEach((element) {
      if (element["id"] == id) {
        element["favStatus"] = false;
        return;
      }
    });
    jsonWrite(ornekk, index, jsonName);
  }
}
