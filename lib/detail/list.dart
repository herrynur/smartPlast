import 'package:flutter/material.dart';

class ListTanaman extends StatelessWidget {
  const ListTanaman({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Tanaman'),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            MyCard(
                rangeph: "6 - 6.20",
                rangehum: "67 - 90",
                rangetemp: "26 - 26.2",
                tanaman: "Blewah, Wortel, Talas"),
            MyCard(
                rangeph: "6 - 6.20",
                rangehum: "30 - 80",
                rangetemp: "26 - 26.2",
                tanaman: "Cabai, Terong, Tomat, Kedelai, Karet, Tebu"),
            MyCard(
                rangeph: "6 - 6.1",
                rangehum: "50 - 58",
                rangetemp: "26 - 26.2",
                tanaman: "Timun, Kacang Tanah, Tomat, Melon, Tembakau"),
            MyCard(
                rangeph: "6.06 - 6.13",
                rangehum: "40 - 72",
                rangetemp: "26 - 26.15",
                tanaman: "Kedelai, Karet, Tebu, Cabai, Terong, Tomat"),
            MyCard(
                rangeph: "6.00 - 7.00",
                rangehum: "70 - 85",
                rangetemp: "26 - 26.15",
                tanaman: "Padi, Ketan, Tebu"),
            MyCard(
                rangeph: "Else",
                rangehum: "Else",
                rangetemp: "Else",
                tanaman: "Ketela, Umbi"),
          ],
        )),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  String rangeph, rangehum, rangetemp, tanaman;
  MyCard({
    Key? key,
    required this.rangeph,
    required this.rangehum,
    required this.rangetemp,
    required this.tanaman,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Range PH : $rangeph")),
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Range Humidity : $rangehum %")),
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Range Temperature : $rangetemp")),
            Container(
                padding: EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text("Tanaman : $tanaman")),
          ],
        ),
      ),
    );
  }
}
