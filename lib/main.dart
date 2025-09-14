import 'package:flutter/material.dart';
import 'package:interactive_country_map/interactive_country_map.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const DWLRMapApp());
}

class DWLRMapApp extends StatelessWidget {
  const DWLRMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Water Levels',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const WaterLevelMapPage(),
    );
  }
}

class WaterLevelMapPage extends StatefulWidget {
  const WaterLevelMapPage({super.key});

  @override
  State<WaterLevelMapPage> createState() => _WaterLevelMapPageState();
}

class _WaterLevelMapPageState extends State<WaterLevelMapPage> {
  final Map<String, double> waterLevels = {
    'IN-AP': 28.5, 'IN-AR': 35.2, 'IN-AS': 25.7, 'IN-BR': 18.3,
    'IN-CT': 22.6, 'IN-GA': 30.1, 'IN-GJ': 29.9, 'IN-HR': 20.8,
    'IN-HP': 26.3, 'IN-JK': 32.1, 'IN-JH': 24.5, 'IN-KA': 27.8,
    'IN-KL': 40.5, 'IN-MP': 21.4, 'IN-MH': 33.2, 'IN-MN': 36.0,
    'IN-ML': 28.1, 'IN-MZ': 34.6, 'IN-NL': 29.5, 'IN-OR': 23.3,
    'IN-PB': 18.9, 'IN-RJ': 15.2, 'IN-SK': 31.7, 'IN-TN': 28.4,
    'IN-TG': 26.2, 'IN-TR': 27.0, 'IN-UP': 22.5, 'IN-UT': 25.0,
    'IN-WB': 24.9, 'IN-AN': 37.0, 'IN-CH': 29.0, 'IN-DN': 27.5,
    'IN-DD': 30.2, 'IN-DL': 21.8, 'IN-LD': 33.5, 'IN-LK': 26.7,
    'IN-PY': 28.8,
  };

  final Map<String, String> isoToName = {
    'IN-AP': 'Andhra Pradesh', 'IN-AR': 'Arunachal Pradesh', 'IN-AS': 'Assam',
    'IN-BR': 'Bihar', 'IN-CT': 'Chhattisgarh', 'IN-GA': 'Goa',
    'IN-GJ': 'Gujarat', 'IN-HR': 'Haryana', 'IN-HP': 'Himachal Pradesh',
    'IN-JK': 'Jammu & Kashmir', 'IN-JH': 'Jharkhand', 'IN-KA': 'Karnataka',
    'IN-KL': 'Kerala', 'IN-MP': 'Madhya Pradesh', 'IN-MH': 'Maharashtra',
    'IN-MN': 'Manipur', 'IN-ML': 'Meghalaya', 'IN-MZ': 'Mizoram',
    'IN-NL': 'Nagaland', 'IN-OR': 'Odisha', 'IN-PB': 'Punjab',
    'IN-RJ': 'Rajasthan', 'IN-SK': 'Sikkim', 'IN-TN': 'Tamil Nadu',
    'IN-TG': 'Telangana', 'IN-TR': 'Tripura', 'IN-UP': 'Uttar Pradesh',
    'IN-UT': 'Uttarakhand', 'IN-WB': 'West Bengal',
    'IN-AN': 'Andaman & Nicobar Islands', 'IN-CH': 'Chandigarh',
    'IN-DN': 'Dadra & Nagar Haveli', 'IN-DD': 'Daman & Diu',
    'IN-DL': 'Delhi', 'IN-LD': 'Lakshadweep', 'IN-LK': 'Ladakh',
    'IN-PY': 'Puducherry',
  };

  String? selectedCode;

  Color colorFor(double? level) {
    if (level == null) return Colors.grey.shade200;
    if (level < 20.0) return Colors.red.shade400;
    if (level < 30.0) return Colors.orange.shade400;
    return Colors.green.shade500;
  }

  Map<String, Color> buildMapping() {
    return waterLevels.map((key, value) => MapEntry(key, colorFor(value)));
  }

  void _showStateBottomSheet(BuildContext context, String code) {
    final name = isoToName[code] ?? code;
    final level = waterLevels[code] ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text("Level: ${level.toStringAsFixed(2)} m",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.trending_up, color: Colors.green),
                        SizedBox(width: 8),
                        Text("Recharge Pattern: Stable",
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.eco, color: Colors.teal),
                        SizedBox(width: 8),
                        Text("Availability: Moderate",
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),

              // Right side button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.show_chart),
                label: const Text("Trends"),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WaterTrendPage(
                        stateCode: code,
                        stateName: name,
                        level: level,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapping = buildMapping();

    return Scaffold(
      appBar: AppBar(
        title: const Text('India — State Water Levels'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: InteractiveMap(
        MapEntity.india,
        theme: InteractiveMapTheme(
          backgroundColor: Colors.blueGrey.shade50,
          borderColor: Colors.grey.shade400,
          borderWidth: 0.8, // thinner borders
          mappingCode: mapping,
        ),
        onCountrySelected: (code) {
          setState(() => selectedCode = code);
          if (code != null && waterLevels.containsKey(code)) {
            _showStateBottomSheet(context, code);
          }
        },
        selectedCode: selectedCode,
      ),
    );
  }
}

class WaterTrendPage extends StatelessWidget {
  final String stateCode;
  final String stateName;
  final double level;

  const WaterTrendPage({
    super.key,
    required this.stateCode,
    required this.stateName,
    required this.level,
  });

  List<FlSpot> get trendData {
    return List.generate(12, (i) {
      final month = i.toDouble();
      final value = level + (i % 2 == 0 ? -2 : 3);
      return FlSpot(month, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$stateName Trends'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Groundwater Trend for $stateName',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          return Text('M${value.toInt() + 1}');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: trendData,
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Level: ${level.toStringAsFixed(2)} m',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
