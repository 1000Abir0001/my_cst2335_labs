import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my_cst2335_labs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // controllers to capture user input
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login / home page png
  String imageSource = 'assets/question.png';
  String imageLabel = 'Question Mark';

  void _handleLogin() {
    setState(() {
      String password = _passwordController.text;

      // logic-> if password is "ASDF", show the idea.png shows
      if (password == "ASDF") {
        imageSource = 'assets/idea.png'; // Matches your YAML 'idea.png'
        imageLabel = 'Light Bulb';
      } else {
        // Otherwise show the stop.png
        imageSource = 'assets/stop.png'; // Matches your YAML 'stop.png'
        imageLabel = 'Stop Sign';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // login name field
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: _handleLogin,
                child:
                const Text('Login',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Image with Semantics
              Semantics(
                label: imageLabel,
                child:
                Image.asset(
                  imageSource,
                  width: 300,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return const Column(
                      children: [
                        Icon(Icons.error, size: 50, color: Colors.red),
                        Text("Image not found! Check file names."),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}