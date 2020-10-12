import 'package:flutter/material.dart';
import 'package:my_quote/my_quote_view.dart';

import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(MyApp());

// void main() => runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder: (context) => MyApp(),
//       ),
//     );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: MyQuoteView(),
    );
  }
}
