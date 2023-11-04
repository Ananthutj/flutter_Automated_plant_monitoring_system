
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InputDataScreen extends StatefulWidget {
  @override
  _InputDataScreenState createState() => _InputDataScreenState();
}

class _InputDataScreenState extends State<InputDataScreen> {
  TextEditingController maxTemperatureController = TextEditingController();
  TextEditingController minTemperatureController = TextEditingController();
  TextEditingController soilmoistureController = TextEditingController();

  Future<void> sendTemperatureDataToThingSpeak() async {
    int maxTemperature = int.tryParse(maxTemperatureController.text) ?? 0;
    int minTemperature = int.tryParse(minTemperatureController.text) ?? 0;
    int soilmoisture = int.tryParse(soilmoistureController.text) ?? 0;

    if (maxTemperature == 0 && minTemperature == 0 && soilmoisture == 0) {
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Please enter values for Maximum Temperature and/or Minimum Temperature."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      String apiKey = '31FCQSDRXNP2ATNZ';
      //String apiKey = '4SF678VZTPEQ29RZ';
      String url = 'https://api.thingspeak.com/update?api_key=$apiKey&field1=$maxTemperature&field2=$minTemperature&field3=$soilmoisture';
      //String url = 'https://api.thingspeak.com/update?api_key=$apiKey&field1=$maxTemperature&field2=$minTemperature&field3=$soilmoisture';
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Data sent"),
              content: Text('Max Temperature: $maxTemperature\nMin Temperature: $minTemperature\nSoil Moisture:$soilmoisture'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to send data to ThingSpeak. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ThingSpeak Data Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: maxTemperatureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Maximum Temperature'),
            ),
            TextField(
              controller: minTemperatureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Minimum Temperature'),
            ),
            TextField(
              controller: soilmoistureController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Soil Moisture'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                sendTemperatureDataToThingSpeak();
              },
              child: Text('Send Data to ThingSpeak'),
            ),
          ],
        ),
      ),
    );
  }
}
