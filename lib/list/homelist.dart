import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartplant/detail/homedetail.dart';
import 'package:smartplant/detail/list.dart';
import 'package:smartplant/detail/mapslist.dart';
import 'package:smartplant/fuzzy/fuzzy.dart';
import 'package:smartplant/gps/location.dart';
import 'package:provider/provider.dart';
import 'package:smartplant/mqtt/mqtt.dart';
import 'package:intl/intl.dart';

class MyHomeList extends StatefulWidget {
  const MyHomeList({Key? key}) : super(key: key);

  @override
  State<MyHomeList> createState() => _MyHomeListState();
}

class _MyHomeListState extends State<MyHomeList> {
  //date
  String date = DateFormat("EEEEE, dd MMMM yyyy").format(DateTime.now());
  //hive
  final _data = Hive.box('plantDb');
  List<Map<String, dynamic>> _items = [];

  void refreshItems() {
    final data = _data.keys.map((key) {
      final value = _data.get(key);
      return {
        "key": key,
        "name": value["name"],
        "long": value['long'],
        "lat": value['lat'],
        "ph": value['ph'],
        "temp": value['temp'],
        "hum": value['hum'],
        "date": value['date'],
        "address": value['address'],
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _data.add(newItem);
    refreshItems();
  }

  Map<String, dynamic> readItem(int key) {
    final item = _data.get(key);
    return item;
  }

  Future<void> updateItem(int key, Map<String, dynamic> newItem) async {
    await _data.put(key, newItem);
    refreshItems();
  }

  Future<void> deleteItem(int key) async {
    await _data.delete(key);
    refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  @override
  void initState() {
    var prov = Provider.of<Location>(context, listen: false);
    var provMqtt = Provider.of<Mqtt>(context, listen: false);
    prov.checkGPS();
    provMqtt.connectMqtt();
    refreshItems();
    super.initState();
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _ph = TextEditingController();
  final TextEditingController _hum = TextEditingController();
  final TextEditingController _temp = TextEditingController();

  void showForm(BuildContext ctx, int? itemKey) async {
    final provi = Provider.of<Location>(context, listen: false);
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _name.text = existingItem['name'];
      _ph.text = existingItem['ph'];
      _hum.text = existingItem['hum'];
      _temp.text = existingItem['temp'];
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _ph,
                    decoration: const InputDecoration(hintText: 'PH'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _hum,
                    decoration: const InputDecoration(hintText: 'Humidity'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    controller: _temp,
                    decoration: const InputDecoration(hintText: 'Temperature'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        createItem({
                          "name": _name.text,
                          "ph": _ph.text,
                          "hum": _hum.text,
                          "long": provi.getLong,
                          "lat": provi.getLat,
                          "temp": _temp.text,
                          "date": date,
                          "address": provi.adrress
                        });
                      }
                      if (itemKey != null) {
                        updateItem(itemKey, {
                          'name': _name.text.trim(),
                          'ph': _ph.text.trim(),
                          'hum': _hum.text.trim(),
                          'temp': _temp.text.trim(),
                          "long": provi.getLong,
                          "lat": provi.getLat,
                          "date": date,
                          "address": provi.adrress
                        });
                      }
                      _name.text = '';
                      _ph.text = '';
                      _hum.text = '';
                      _temp.text = '';
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }

  final TextEditingController name = TextEditingController();
  void addNew(BuildContext ctx) {
    final provi = Provider.of<Location>(context, listen: false);
    var provMqtt = Provider.of<Mqtt>(context, listen: false);
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    autofocus: true,
                    controller: name,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      createItem({
                        "name": name.text,
                        "ph": provMqtt.getphData(),
                        "hum": provMqtt.gethumData(),
                        "long": provi.getLong,
                        "lat": provi.getLat,
                        "temp": provMqtt.gettempData(),
                        "date": date,
                        "address": provi.adrress
                      });
                      name.text = '';
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Create New'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var provMqtt = Provider.of<Mqtt>(context);
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListTanaman()));
                }),
          ],
          title: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Data List Recorded',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          onPressed: () {
            showForm(context, null);
          },
          child: const Icon(Icons.add),
        ),
        body: _items.isEmpty
            ? Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(137, 111, 110, 110)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text("Data Streaming",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.purple[400],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text("PH",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text("${provMqtt.getphData()}",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text("Humidity",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text("${provMqtt.gethumData()} %",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.pink[300],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Text("Temp",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text("${provMqtt.gettempData()} C",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if(provMqtt.gethumData() != "-")
                          addNew(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: provMqtt.gethumData() != "-" ? Colors.blue[600] : Colors.grey[700],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 1,
                                  offset: Offset(2, 2), // Shadow position
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Save Data",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final dataItem = _items[index];
                  return Column(
                    children: <Widget>[
                      if (index == 0)
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(137, 111, 110, 110)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Text("Data Streaming",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      decoration: BoxDecoration(
                                        color: Colors.purple[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Text("PH",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                "${provMqtt.getphData()}",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      decoration: BoxDecoration(
                                        color: Colors.green[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Text("Humidity",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                "${provMqtt.gethumData()} %",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[400],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: Text("Temp",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                                "${provMqtt.gettempData()} C",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    addNew(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.blue[600],
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Save Data",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      InkWell(
                        onLongPress: () {
                          showForm(context, dataItem['key']);
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeDetail(
                                        nama: dataItem['name'],
                                        ph: dataItem['ph'],
                                        hum: dataItem['hum'],
                                        temp: dataItem['temp'],
                                        long: dataItem['long'],
                                        lat: dataItem['lat'],
                                        address: dataItem['address'],
                                      )));
                        },
                        onDoubleTap: () {
                          deleteItem(dataItem['key']);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(137, 111, 110, 110)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 15, top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${dataItem['name']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    top: 10,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${dataItem['address']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 15, top: 10, bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${dataItem['date']}",
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
                                      "PH : ${dataItem['ph']}  |  Humidity : ${dataItem['hum']} %  |  Temperature : ${dataItem['temp']} C",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }));
  }
}
