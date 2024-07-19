import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wine Prediction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(13, (index) => TextEditingController());
  String _prediction = '';
  String _errorMessage = '';

  Future<void> _predict() async {
    final List<double> features = _controllers.map((controller) => double.tryParse(controller.text) ?? 0.0).toList();
    final response = await http.post(
      Uri.parse('https://oche-ankeli-linear-regression-summative.onrender.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'features': features,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      setState(() {
        _prediction = responseJson['prediction'].toString();
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Error: ${response.statusCode} ${response.reasonPhrase}';
        _prediction = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wine Prediction App'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/glass-wine.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ...List.generate(13, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            ),
                            style: const TextStyle(fontSize: 16.0),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                          ),
                          Positioned(
                            right: 10,
                            top: 20,
                            child: Text(
                              [
                                'Alcohol',
                                'Malic acid',
                                'Ash',
                                'Alcalinity of ash',
                                'Magnesium',
                                'Total phenols',
                                'Flavanoids',
                                'Nonflavanoid phenols',
                                'Proanthocyanins',
                                'Color intensity',
                                'Hue',
                                'OD280/OD315 of diluted wines',
                                'Proline'
                              ][index],
                              style: const TextStyle(color: Colors.red, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _predict();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    child: const Text('Predict'),
                  ),
                  const SizedBox(height: 20),
                  if (_prediction.isNotEmpty)
                    Text('Prediction: $_prediction', style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
                  if (_errorMessage.isNotEmpty)
                    Text('Error: $_errorMessage', style: const TextStyle(fontSize: 18, color: Colors.red)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
