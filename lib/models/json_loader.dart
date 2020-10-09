import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_quote/my_quote_view.dart';

// To parse this JSON data, do
//
//     final quotes = quotesFromJson(jsonString);

List<Quotes> quotesFromJson(String str) =>
    List<Quotes>.from(json.decode(str).map((x) => Quotes.fromJson(x)));

String quotesToJson(List<Quotes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Quotes {
  Quotes({
    this.quoteText,
    this.quoteAuthor,
    this.favStatus,
  });

  String quoteText;
  String quoteAuthor;
  bool favStatus;

  factory Quotes.fromJson(Map<String, dynamic> json) => Quotes(
        quoteText: json["quoteText"],
        quoteAuthor: json["quoteAuthor"],
        favStatus: json["favStatus"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quoteText'] = this.quoteText;
    data['quoteAuthor'] = this.quoteAuthor;
    data['favStatus'] = this.favStatus;
    return data;
  }
}

Future<String> _loadAQuotesAsset(jsonPath) async {
  return await rootBundle.loadString("assets/ornek.json");
}

Future<List> getQuote(jsonFile) async {
  String jsonString = await rootBundle.loadString(jsonFile);

  List<dynamic> list = json.decode(jsonString);
  // Quotes quotes = Quotes.fromJson(list[1]);
  return list;
}

loadQuotes(jsonFile) async {
  // await wait(5);
  String jsonString = await rootBundle.loadString(jsonFile);
  final jsonResponse = json.decode(jsonString);

  return jsonResponse;
}

Future<String> get _localPath async {
  final directory = await getExternalStorageDirectory();
  return directory.path;
}

Future<File> get _dbFile async {
  final path = await _localPath;
  return File("$path/naber.json");
}

/*void*/ write(snapshot, jsonFileName) async {
  // final file = await _dbFile;
  final filePath = await _localPath;

  if (File('$filePath/' + jsonFileName).existsSync()) {
    File('$filePath/' + jsonFileName).writeAsStringSync(json.encode(snapshot));
  } else {
    final file = File('$filePath/' + jsonFileName);
    file.writeAsStringSync(json.encode(snapshot));
  }
  // print(file.path);

  // Read the file.
  // String contents = await file.readAsString();

  print("dosyaya yazildi.");
}

Future<List> read(json) async {
  String text;
  try {
    final Directory directory = await getExternalStorageDirectory();
    final File file = File('${directory.path}/' + json);
    print(file.path);
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  print(text);
}

readMyCatJson(json) async {
  String text;
  try {
    final File file = File(json);
    print(file.path);
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}

jsonYukle(jsonName) async {
  final Directory directory = await getExternalStorageDirectory();
  // final File file = File('${directory.path}/naber.json');
  final File file = File(jsonName);

  String jsonString = file.readAsStringSync();
  final list = json.decode(jsonString);

  return list;
}

loadAllJsonFile() async {
  List<String> jsonFiles = [
    "love.json",
    "god.json",
    "life.json",
    "random.json",
    "inspiration.json",
  ];
  final Directory directory = await getExternalStorageDirectory();

  int i = 0;
  while (i < 5) {
    String jsonString = await rootBundle.loadString('assets/' + jsonFiles[i]);
    final list = json.decode(jsonString);

    if (!File('${directory.path}/' + jsonFiles[i]).existsSync()) {
      final File file = File('${directory.path}/' + jsonFiles[i]);
      file.writeAsStringSync(json.encode(list));
    }

    i++;
  }
}

createFavoriteFile() async {
  final Directory directory = await getExternalStorageDirectory();
  final File file = File('${directory.path}/favorites.json');
  List x = [];
  if (!file.existsSync()) {
    file.writeAsStringSync(json.encode(x));
  }
}
