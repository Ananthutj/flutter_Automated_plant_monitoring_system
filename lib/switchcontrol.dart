import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DataDisplayScreen extends StatefulWidget {
  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {
  late Future<Map<String, dynamic>> latestData;

  Future<Map<String, dynamic>> fetchDataFromThingSpeak() async {
    final response = await http.get(
        Uri.parse('https://api.thingspeak.com/channels/2332099/feeds.json?api_key=8PBPI7HYZJYIZRNC'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final feeds = List<Map<String, dynamic>>.from(jsonResponse['feeds']);
      if (feeds.isNotEmpty) {
        return feeds.first;
      }
    }
    throw Exception('Failed to fetch data from ThingSpeak');
  }

  @override
  void initState() {
    super.initState();
    latestData = fetchDataFromThingSpeak();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, 
      child: ListView(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: latestData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final data = snapshot.data!;
                final temperature = double.tryParse(data['field4'] ?? '0.0') ?? 0.0;
                final soilMoisture = double.tryParse(data['field5'] ?? '0.0') ?? 0.0;

                return Column(
                  children: [
                     ListTile(
                      title: Text('Data from Crop'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Temperature: ${data['field4']}'),
                          Text('Soil Moisture: ${data['field5']}'),
                          Text('Timestamp: ${data['created_at']}'),
                        ],
                      ),
                    ),
                    SfRadialGauge(
                      title: GaugeTitle(text: 'Temperature'),
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 50,
                              color: Colors.green,
                            ),
                            GaugeRange(
                              startValue: 50,
                              endValue: 100,
                              color: Colors.orange,
                            ),
                            GaugeRange(
                              startValue: 100,
                              endValue: 150,
                              color: Colors.red,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: temperature,
                              enableAnimation: true,
                              animationType: AnimationType.ease,
                              animationDuration: 1500,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Container(
                                child: Text(
                                  temperature.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SfRadialGauge(
                      title: GaugeTitle(text: 'Moisture'),
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 1000,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 500,
                              color: Colors.red,
                            ),
                            GaugeRange(
                              startValue: 500,
                              endValue: 1000,
                              color: Colors.green,
                            ),
                            // GaugeRange(
                            //   startValue: 100,
                            //   endValue: 150,
                            //   color: Colors.blue,
                            // ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: soilMoisture,
                              enableAnimation: true,
                              animationType: AnimationType.ease,
                              animationDuration: 1500,
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Container(
                                child: Text(
                                  soilMoisture.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          ),
        ],
      ),
    );
  }
}


class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  int heatPumpStatus = 0;
  int light = 0;
  int fanIn = 0;
  int fanOut = 0;

  Future<void> updateStatus(String field, int status) async {
    final apiKey = 'ZN80PFE0AVLPGO4A';
    final apiUrl = 'https://api.thingspeak.com/update?api_key=$apiKey&field=$field';

    try {
      final response = await http.post(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        if (field == '3') {
          setState(() {
            heatPumpStatus = status;
          });
        } else if (field == '4') {
          setState(() {
            light = status;
          });
        } else if (field == '1') {
          setState(() {
            fanIn = status;
          });
        } else if (field == '2') {
          setState(() {
            fanOut = status;
          });
        }
      } else {
        print('HTTP request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending HTTP request: $e');
    }
  }

  Widget buildDeviceControl(String imageName, String label, int status, String field) {
    return Stack(
      children: [
        Image.asset(
          imageName,
          height: 130,
          width: 150,
        ),
        Container(
          margin: EdgeInsets.only(top: 45, left: 50),
          child: Column(
            children: [
              Text(label, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Switch(
                value: status == 1,
                onChanged: (value) {
                  updateStatus(field, value ? 1 : 0);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 230, 208),
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tomato",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              DataDisplayScreen(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: buildDeviceControl('assets/images/light.png', 'Light', light, '4'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: buildDeviceControl('assets/images/pump.png', 'Pump', heatPumpStatus, '3'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: buildDeviceControl('assets/images/fanin.png', 'Fan In', fanIn, '1'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: buildDeviceControl('assets/images/fanout.png', 'Fan Out', fanOut, '2'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}