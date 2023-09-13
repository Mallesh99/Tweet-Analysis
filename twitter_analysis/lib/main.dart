import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tweet - Analysis',
      theme: ThemeData(
        primaryColor: Colors.black, // Change the primary color to black
        scaffoldBackgroundColor: Colors.white, // Set background color
      ),
      home: const MyHomePage(title: 'Tweet Analysis..'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _tweetController = TextEditingController();
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 5), // Adjust the rotation duration
      vsync: this,
    )..repeat(); // Repeats the rotation animation continuously
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _tweetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white, // Title text color
            fontSize: 24, // Title text size
            fontWeight: FontWeight.bold, // Title text weight
          ),
        ),
        centerTitle: true,
        elevation: 0, // Remove app bar shadow
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20), // Add spacing at the top

          // Rotating Twitter Logo
          RotationTransition(
            turns: _rotationController,
            child: ClipOval(
              child: Container(
                width: 150, // Adjust the width as needed
                height: 150, // Adjust the height as needed
                decoration: const BoxDecoration(
                  color: Colors.black, // Logo background color is now black
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover, // Adjust the fit as needed
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Beautiful Text Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _tweetController,
              maxLines: 5,
              style: const TextStyle(
                fontSize: 16, // Text size
              ),
              decoration: InputDecoration(
                hintText: 'Type your tweet here',
                filled: true,
                fillColor: Colors.grey[200], // Background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Redesigned Submit Button
          ElevatedButton(
            onPressed: () {
              // Add your logic to handle the tweet submission here
              // You can access the entered tweet using _tweetController.text
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Button color is now black
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Button shape
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 18, // Text size
                fontWeight: FontWeight.bold, // Text weight
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Spacer to push the copyright notice to the bottom
          const Spacer(),

          // Copyright Notice centered at the bottom
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              '© 2023 IOMP Team-15. All rights reserved.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
