import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(const SmartFarmApp());

class SmartFarmApp extends StatelessWidget {
  const SmartFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture QA',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _telemetryData;
  Map<String, dynamic>? _inventoryData;
  Timer? _timer;

  final String apiUrl =
      "http://<SERVER_IP>/smart_farm/api/get_latest.php";

  @override
  void initState() {
    super.initState();

    fetchData();

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => fetchData(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            _telemetryData = jsonResponse['telemetry'];
            _inventoryData = jsonResponse['inventory'];
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    }
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Warehouse Dashboard"),
      ),
      body: _telemetryData == null || _inventoryData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildCard(
                    "Temperature",
                    "${_telemetryData!['temperature']} °C",
                    Icons.thermostat,
                    Colors.red,
                  ),
                  buildCard(
                    "Humidity",
                    "${_telemetryData!['humidity']} %",
                    Icons.water_drop,
                    Colors.blue,
                  ),
                  const Divider(height: 30),
                  buildCard(
                    "Apple Count",
                    "${_inventoryData!['apple_count']} pcs",
                    Icons.apple,
                    Colors.redAccent,
                  ),
                  buildCard(
                    "Mango Count",
                    "${_inventoryData!['mango_count']} pcs",
                    Icons.eco,
                    Colors.amber,
                  ),
                  buildCard(
                    "Orange Count",
                    "${_inventoryData!['orange_count']} pcs",
                    Icons.circle,
                    Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Last Updated: ${_inventoryData!['created_at']}",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
