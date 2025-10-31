import 'package:flutter/material.dart';

void main() {
  runApp(const IMSplitApp());
}

class IMSplitApp extends StatelessWidget {
  const IMSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '200 IM Split Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplitCalculator(),
    );
  }
}

class SplitCalculator extends StatefulWidget {
  const SplitCalculator({super.key});

  @override
  State<SplitCalculator> createState() => _SplitCalculatorState();
}

class _SplitCalculatorState extends State<SplitCalculator> {
  final TextEditingController _goalTimeController = TextEditingController();
  List<String> _results = [];

  // Fixed percentage values (same as before)
  final List<double> _fixedPercents = [23.4, 25.5, 27.5, 23.61];
  final List<String> _strokes = ["Fly", "Back", "Breast", "Free"];

  double _parseTime(String time) {
    final parts = time.split(":");
    if (parts.length == 2) {
      return double.parse(parts[0]) * 60 + double.parse(parts[1]);
    }
    return double.parse(time);
  }

  String _formatTime(double seconds) {
    int minutes = seconds ~/ 60;
    double sec = seconds % 60;
    return minutes > 0
        ? "$minutes:${sec.toStringAsFixed(2).padLeft(5, '0')}"
        : sec.toStringAsFixed(2);
  }

  void _calculate() {
    final goalText = _goalTimeController.text.trim();

    if (goalText.isEmpty) {
      setState(() {
        _results = ["Please enter a goal time"];
      });
      return;
    }

    try {
      double total = _parseTime(goalText);
      final splits = _fixedPercents.map((p) => total * (p / 100)).toList();

      setState(() {
        _results = splits.map(_formatTime).toList();
      });
    } catch (e) {
      setState(() {
        _results = ["Invalid input"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('200 IM Split Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _goalTimeController,
              decoration: const InputDecoration(
                labelText: "Goal Time (e.g. 1:49.00)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Split percentages for each 50:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display fixed percentages instead of editable fields
            for (int i = 0; i < _strokes.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "${_strokes[i]}: ${_fixedPercents[i].toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculate,
              child: const Text("Calculate Splits"),
            ),
            const SizedBox(height: 16),
            if (_results.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_results.length == 4)
                    for (int i = 0; i < _results.length; i++)
                      Text(
                        "${_strokes[i]}: ${_results[i]}",
                        style: const TextStyle(fontSize: 18),
                      )
                  else
                    Text(_results.first, style: const TextStyle(fontSize: 18)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
