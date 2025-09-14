import 'package:flutter/material.dart';
import 'package:interactive_country_map/interactive_country_map.dart';

void main() {
  runApp(const DWLRMapApp());
}

class DWLRMapApp extends StatelessWidget {
  const DWLRMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'India Water Levels',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  /// Mock state-level water levels keyed by ISO-3166-2 codes for India.
  /// Replace these with real DWLR values (make sure to use the ISO codes).
  final Map<String, double> waterLevels = {
    'IN-RJ': 15.2, // Rajasthan
    'IN-MH': 32.1, // Maharashtra
    'IN-UP': 22.5, // Uttar Pradesh
    'IN-TN': 28.4, // Tamil Nadu
    'IN-PB': 18.9, // Punjab
    'IN-GJ': 30.3, // Gujarat
    'IN-KL': 40.5, // Kerala
  };

  /// Optional: friendly names for display (map ISO code -> state name)
  final Map<String, String> isoToName = {
    'IN-RJ': 'Rajasthan',
    'IN-MH': 'Maharashtra',
    'IN-UP': 'Uttar Pradesh',
    'IN-TN': 'Tamil Nadu',
    'IN-PB': 'Punjab',
    'IN-GJ': 'Gujarat',
    'IN-KL': 'Kerala',
  };

  String? selectedCode;

  /// Convert water level value -> color
  Color colorFor(double? level) {
    if (level == null) return Colors.grey.shade300;
    if (level < 20.0) return Colors.red.shade400;
    if (level < 30.0) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  /// Build the mappingCode map required by InteractiveMapTheme
  Map<String, Color> buildMapping() {
    final Map<String, Color> map = {};
    for (final entry in waterLevels.entries) {
      map[entry.key] = colorFor(entry.value);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final mapping = buildMapping();

    return Scaffold(
      appBar: AppBar(title: const Text('India — State Water Levels')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InteractiveMap(
                // first (positional) argument is the map entity to load
                MapEntity.india,
                // theme controls colors per ISO code
                theme: InteractiveMapTheme(
                  backgroundColor: Colors.blueGrey.shade50,
                  mappingCode: mapping,
                ),
                // called when a region (state/UT) is tapped; returns ISO code like 'IN-MH'
                onCountrySelected: (code) {
                  setState(() => selectedCode = code);
                },
                // optional: initial selected code (if you want)
                selectedCode: selectedCode,
                // optional: min/max scale, markers etc.
                minScale: 0.7,
                maxScale: 6.0,
              ),
            ),
          ),

          // Selected state info
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: selectedCode == null
                ? const Text('Tap a state to see water-level details',
                    style: TextStyle(fontSize: 16))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isoToName[selectedCode] ?? selectedCode!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Water level: ${waterLevels[selectedCode]?.toStringAsFixed(2) ?? "No data"} m',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                              width: 18,
                              height: 18,
                              color: colorFor(waterLevels[selectedCode])),
                          const SizedBox(width: 8),
                          Text(_recommendation(waterLevels[selectedCode])),
                        ],
                      ),
                    ],
                  ),
          ),

          // Legend
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendItem(Colors.red.shade400, 'Low (<20 m)'),
                _legendItem(Colors.orange.shade400, 'Medium (20–30 m)'),
                _legendItem(Colors.green.shade400, 'High (≥30 m)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 18, height: 18, color: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  String _recommendation(double? level) {
    if (level == null) return 'No recommendation — missing data';
    if (level < 20) return 'Recommendation: immediate recharge measures.';
    if (level < 30) return 'Recommendation: monitor & target recharge projects.';
    return 'Recommendation: groundwater stable — continue monitoring.';
  }
}
