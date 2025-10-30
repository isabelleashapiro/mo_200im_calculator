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
  final List<TextEditingController> _percentControllers = [
    TextEditingController(text: "23.4"),
    TextEditingController(text: "25.5"),
    TextEditingController(text: "27.5"),
    TextEditingController(text: "23.61"),
  ];
  List<String> _results = [];

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
    try {
      double total = _parseTime(_goalTimeController.text);
      final percents = _percentControllers
          .map((c) => double.parse(c.text) / 100)
          .toList();
      final splits = percents.map((p) => total * p).toList();

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
    final strokes = ["Fly", "Back", "Breast", "Free"];

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
            const Text("Split percentages for each 50:"),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: _percentControllers[i],
                  decoration: InputDecoration(
                    labelText: strokes[i],
                    suffixText: "%",
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                  for (int i = 0; i < _results.length; i++)
                    Text(
                      "${strokes[i]}: ${_results[i]}",
                      style: const TextStyle(fontSize: 18),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
