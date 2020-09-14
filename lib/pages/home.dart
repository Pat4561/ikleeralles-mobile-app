import 'package:flutter/material.dart';
import 'package:ikleeralles/ui/appbar.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemedAppBar(
        title: "Mijn lijsten",
      ),
      body: Container(),

    );
  }

}