import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartplant/gps/location.dart';
import 'package:provider/provider.dart';

class Mqtt with ChangeNotifier{
  final client = MqttServerClient('broker.hivemq.com', '');
  String topic = 'smartplant/plant1';
  String? dataMqtt;
  String? get mqttData => dataMqtt;
  String? ph = "-", hum = "-", temp = "-";
  getphData() => ph;
  gethumData() => hum;
  gettempData() => temp;

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  }

  void connectMqtt() async {
    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdQ2')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting...321');
    final snackBar = SnackBar(
      backgroundColor: Colors.black54,
      content: const Text(
        'Connecting...',
        style: TextStyle(color: Colors.grey),
      ),
    );
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      final snackBar = SnackBar(
        backgroundColor: Colors.black54,
        content: const Text(
          'Connected',
          style: TextStyle(color: Colors.white),
        ),
      );
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      exit(-1);
    }
    subscribeToTopic(topic);
  }

  void subscribeToTopic(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
        //dataMqtt = pt;
        List<String> dataInList = pt.split(',');
        temp = dataInList[0];
        hum = dataInList[1];
        ph = dataInList[2];
        print("Temp : $temp , Hum : $hum , Ph : $ph");
        notifyListeners();
    });
  }
}