import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:smartplant/gps/location.dart';

class mapsList extends StatefulWidget {
  const mapsList({super.key});

  @override
  State<mapsList> createState() => _mapsListState();
}

class _mapsListState extends State<mapsList> {
  @override
  void initState() {
    var prov = Provider.of<Location>(context, listen: false);
    prov.checkGPS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Location>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
                center: LatLng(double.parse(prov.getLat), double.parse(prov.getLong)),
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
                      point: LatLng(double.parse(prov.getLat), double.parse(prov.getLong)),
                      builder: (ctx) => Container(
                        child: IconButton(
                          icon: Icon(Icons.circle),
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
