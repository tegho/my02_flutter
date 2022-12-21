// Dart imports:
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:window_manager/window_manager.dart';

// https://pub.dev/documentation/window_manager/latest/window_manager/window_manager-library.html
// https://pub.dev/packages/flutter_svg
// https://github.com/serenader2014/flutter_carousel_slider

void main() {
  bool haveWin = false;
  bool platformWeb = true;

  // we can't use dart:io in web
  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) haveWin = true;
    if (Platform.isAndroid || Platform.isIOS || haveWin) platformWeb = false;
  } catch (_){}

  if (haveWin) tuneApplicationWindow();

  runApp( MyApp(platformWeb) );
}

// async and await are just from package usage example
// it is too early for this study stage
void tuneApplicationWindow() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 600),
    minimumSize: Size(400, 600),
    center: true,
    title: 'Task 3.6',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  final bool platformWeb;
  const MyApp(this.platformWeb, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', platformWeb: platformWeb),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.platformWeb});

  final String title;
  final bool platformWeb;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _urlNum = 0;
  int _iconNum = 0;

  final List<String> _iconNames = [
    'assets/city-buildings-svgrepo-com.svg',
    'assets/city-svgrepo-com.svg',
    'assets/city-tower-building-surrounded-by-trees-svgrepo-com.svg',
    'assets/city-towers-view-svgrepo-com.svg',
    'assets/san-francisco-tower-city-transamerica-tower-svgrepo-com.svg',
  ];
  final List<String> _iconUrls = [
    'https://www.svgrepo.com/download/176712/lion-animals.svg',
    'https://www.svgrepo.com/download/176692/owl-animals.svg',
    'https://www.svgrepo.com/download/176700/cow-animals.svg',
    'https://www.svgrepo.com/download/176708/cat-animals.svg',
    'https://www.svgrepo.com/download/176706/fish-animals.svg',
    'https://www.svgrepo.com/download/176691/whale-animals.svg',
    'https://www.svgrepo.com/download/176711/sheep-animals.svg',
    'https://www.svgrepo.com/download/176688/rabbit-animals.svg',
    'https://www.svgrepo.com/download/176695/elephant-animals.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Container(
              height: 84,
              color: Colors.cyan,
              padding: const EdgeInsets.all(10),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ( ! widget.platformWeb ) ? const SizedBox.shrink() : const Text('SvgPicture.network NOT SUPPORTED IN WEB.'),
                    ( widget.platformWeb ) ? const SizedBox.shrink() : SvgPicture.network(
                      _iconUrls[_urlNum],
                      // https://pub.dev/documentation/flutter_svg/latest/svg/SvgPicture/SvgPicture.network.html
                      // Manual says
                      // "Either the width and height arguments should be specified, or the widget should be placed in a context that sets tight layout constraints"
                      // In our case parent container sets height. It resizes this SVG image, but not SVG canvas size!
                      // So add width here as a workaround
                      width: 64,
                    ),
                    ( widget.platformWeb ) ? const SizedBox.shrink() : IconButton(
                      iconSize: 64,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.arrow_circle_right),
                      onPressed: () {
                        setState(() {
                          _urlNum++; if ( _urlNum >= _iconUrls.length ) _urlNum = 0;
                        });
                      },
                    ),
                  ]
                ),
            ),


            Container(
              height: 84,
              color: Colors.green,
              padding: const EdgeInsets.all(10),
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      _iconNames[_iconNum],
                      width: 64,
                    ),
                    IconButton(
                      iconSize: 64,
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.arrow_circle_right),
                      onPressed: () {
                        setState(() {
                          _iconNum++; if ( _iconNum >= _iconNames.length ) _iconNum = 0;
                        });
                      },
                    ),
                  ]
              ),
            ),

            ( widget.platformWeb ) ? const Text('SvgPicture.network NOT SUPPORTED IN WEB.') : Expanded(
              child:
                Container(
                  // width: 1300,
                  color: Colors.grey,
                  padding: const EdgeInsets.all(10),
                    child:
                      CarouselSlider(
                        options: CarouselOptions(),
                        items: _iconUrls.map((item) =>
                          SvgPicture.network(item, fit: BoxFit.contain)
                        ).toList(),
                      )

                )
            )

        ],
      ),
    );
  }
}
