import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smartplant/fuzzy/fuzzy.dart';

class HomeDetail extends StatefulWidget {
  String nama, ph, temp, hum, long, lat, address;
  HomeDetail({
    Key? key,
    required this.nama,
    required this.ph,
    required this.temp,
    required this.hum,
    required this.long,
    required this.lat,
    required this.address,
  }) : super(key: key);

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  late var nama = widget.nama;
  late var ph = widget.ph;
  late var temp = widget.temp;
  late var hum = widget.hum;
  late double long = double.parse(widget.long);
  late double lat = double.parse(widget.lat);
  late var address = widget.address;
  late List<String> plantList;

  void credist() {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              height : MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.only(
                  bottom: 5,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text("APK Version 1.0.0+1",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    child: Text("Running On : Google Pixel XL",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                    )),
                  ),
                  SizedBox(height: 15,),
                  Container(
                     child: Text("Support By : ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                    )),
                  ),
                  SizedBox(height: 15,),
                  Container(
                     child: Image.asset("images/logo.png",
                        height: 100,
                        fit: BoxFit.cover,
                    )
                  ),
                  SizedBox(height: 15,),
                  Container(
                     child: Text("@2022",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                    )),
                  ),
                ],
              ),
            ));
  }


  void initState()
  {
    plantList = fuzzyData().getPlantData(double.parse(temp), double.parse(ph), int.parse(hum));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                center: LatLng(lat, long),
                zoom: 16.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    tileBuilder: darkModeTileBuilder,
                    backgroundColor: Colors.black54),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat, long),
                      builder: (ctx) => Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on),
                          color: Colors.red,
                          iconSize: 42.0,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              maxChildSize: 0.9,
              minChildSize: 0.3,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 34, 38, 39),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: plantList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Column(
                        children: <Widget>[
                          if (index == 0)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.42,
                                      right: MediaQuery.of(context).size.width *
                                          0.42),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.008,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$nama",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "$address",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 15, bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "LongLat ( $long, $lat )",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15, right: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "PH : $ph  |  Humidity : $hum %  |  Temperature : $temp C",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tanaman Rekomendasi",
                                    style: TextStyle(
                                        color: Colors.blue[400],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.002,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ListTile(
                              title: Text(
                            '${plantList[index]}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            Positioned(
              top: 30,
              left: 10,
              height: 50,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
