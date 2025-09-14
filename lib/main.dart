import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

// Mock data for DWLR station dataset
class WaterLevel {
  final DateTime date;
  final double level;

  WaterLevel(this.date, this.level);
}

void main() {
  runApp(const DWLRApp());
}

class DWLRApp extends StatelessWidget {
  const DWLRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DWLR Groundwater App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<WaterLevel> waterData = [];
  double availability = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulating API fetch (replace with your REST API)
    await Future.delayed(const Duration(seconds: 2));
    List<WaterLevel> mockData = List.generate(
      10,
      (i) => WaterLevel(
        DateTime.now().subtract(Duration(days: i)),
        5 + i.toDouble() + (i % 3) * 2,
      ),
    );

    setState(() {
      waterData = mockData;
      availability = _calculateAvailability(mockData);
      loading = false;
    });
  }

  double _calculateAvailability(List<WaterLevel> data) {
    if (data.isEmpty) return 0.0;
    double avg = data.map((d) => d.level).reduce((a, b) => a + b) / data.length;
    return avg > 10 ? 80.0 : 50.0; // dummy logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DWLR Groundwater Dashboard"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    child: ListTile(
                      title: const Text("Real-time Availability"),
                      subtitle: Text("$availability %"),
                      trailing: Icon(
                        availability > 60
                            ? Icons.check_circle
                            : Icons.warning,
                        color: availability > 60 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Water Level Trends",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: waterData
                                .map((e) => FlSpot(
                                    e.date.day.toDouble(), e.level.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: Colors.blue,
                            belowBarData: BarAreaData(show: true),
                          ),
                        ],
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Decision Support",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        availability > 60
                            ? "Groundwater levels are stable. Recharge projects can be planned conservatively."
                            : "Warning: Groundwater stress detected. Immediate recharge measures recommended.",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
