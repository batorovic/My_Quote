import 'package:flutter/material.dart';

class Category {
  final String categoryName;
  final String imgPath;
  final String json;

  Category({
    @required this.categoryName,
    @required this.imgPath,
    this.json,
  });
}

List<Category> categoryList = [
  Category(
      categoryName: "LOVE",
      imgPath: "assets/images/love.jpg",
      json:
          "/storage/emulated/0/Android/data/com.example.my_quote/files/love.json"),
  Category(
      categoryName: "INSPIRATION",
      imgPath: "assets/images/inspiration.jpg",
      json:
          "/storage/emulated/0/Android/data/com.example.my_quote/files/inspiration.json"),
  Category(
      categoryName: "LIFE",
      imgPath: "assets/images/life.jpg",
      json:
          "/storage/emulated/0/Android/data/com.example.my_quote/files/life.json"),
  Category(
      categoryName: "GOD",
      imgPath: "assets/images/god.jpg",
      json:
          "/storage/emulated/0/Android/data/com.example.my_quote/files/god.json"),
  Category(
    categoryName: "RANDOM",
    imgPath: "assets/images/random.jpg",
    json:
        "/storage/emulated/0/Android/data/com.example.my_quote/files/random.json",
  )
];
