import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, ScrollPhysics> scrollPhysicsMap = {
    0: PageScrollPhysics(),
    1: ClampingScrollPhysics()
  };
  Map<int, Widget> _children;

  int _controlGroupValue;
  int _selectedScrollPhysics;

  ScrollController _scrollController = ScrollController();

  bool _showArrowIndicator = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset < 254) {
        setState(() {
          _showArrowIndicator = true;
        });
      } else {
        setState(() {
          _showArrowIndicator = false;
        });
      }
    });
    _controlGroupValue = 0;
    _selectedScrollPhysics = 0;
    _children = List<Widget>.generate(9, (index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Child $index"),
      );
    }).asMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RadioListTile<int>(
              value: 0,
              groupValue: _selectedScrollPhysics,
              title: Text("Page Scroll Physics (Bounces)"),
              subtitle: Text("iOS Default"),
              onChanged: (int value) {
                setState(() {
                  _selectedScrollPhysics = 0;
                });
              }),
          RadioListTile<int>(
              value: 1,
              groupValue: _selectedScrollPhysics,
              title: Text("Clamping Scroll Physics (No Bounce"),
              subtitle: Text("Android Default"),
              onChanged: (int value) {
                setState(() {
                  _selectedScrollPhysics = 1;
                });
              }),
          Row(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(15.0),
                  physics: scrollPhysicsMap[_selectedScrollPhysics],
                  scrollDirection: Axis.horizontal,
                  child: CupertinoSegmentedControl(
                    children: _children,
                    groupValue: _controlGroupValue,
                    onValueChanged: (int value) {
                      setState(() {
                        _controlGroupValue = value;
                      });
                    },
                  ),
                ),
              ),
              _showArrowIndicator
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container()
            ],
          ),
          Chip(label: _children[_controlGroupValue])
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
