import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Tweet Analyzer';

  // Define a custom MaterialColor
  static const MaterialColor customBlack = MaterialColor(
    0xFF000000, // This is the primary value, which is black in this case
    <int, Color>{
      50: Color(0xFFEDEDED), // You can define shades of black if needed
      100: Color(0xFFD1D1D1),
      200: Color(0xFFB6B6B6),
      300: Color(0xFF9A9A9A),
      400: Color(0xFF808080),
      500: Color(0xFF000000), // Primary color (black)
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primarySwatch: customBlack, // Use the customBlack MaterialColor
          scaffoldBackgroundColor: Colors.white, // Set background color
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController inputController = TextEditingController();
  String RESULT = "";
  String resultColor = ""; // Store the color value

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: inputController,
                decoration: const InputDecoration(
                  labelText: 'Enter Tweet',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              FocusScope(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          predict();
                          FocusScope.of(context).unfocus();
                        },
                  child: Text(isLoading ? 'Processing...' : 'Predict'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 9, 20, 9),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else if (RESULT.isNotEmpty)
                ResultDisplay(RESULT, resultColor), // Pass the color value
            ],
          ),
        ),
      ),
    );
  }

  Future<void> predict() async {
    final inputText = inputController.text;
    if (inputText.isEmpty) {
      return;
    }
    setState(() {
      isLoading = true;
      RESULT = "";
    });

    try {
      final response = await http.get(Uri.parse(
          "https://719b-2405-201-c00e-60b7-f540-6d3-64c7-d709.ngrok-free.app/?query=$inputText"));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          RESULT = decoded["output"];
          resultColor = decoded["color"]; // Store the color value
        });
      } else {
        setState(() {
          RESULT = "Error occurred.";
        });
      }
    } catch (e) {
      setState(() {
        RESULT = "Error occurred: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class ResultDisplay extends StatelessWidget {
  final String resultText;
  final String resultColor;

  const ResultDisplay(this.resultText, this.resultColor, {Key? key})
      : super(key: key);

  Color getCardColor(String color) {
    if (color == "neutral") {
      return Colors.blue;
    } else if (color == "positive") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;

    if (resultColor == "neutral") {
      textColor = Colors.black; // Change text color to black for neutral
    } else if (resultColor == "positive") {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }

    return Card(
      elevation: 4,
      color: getCardColor(resultColor), // Set card color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          resultText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
