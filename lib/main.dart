import 'package:flutter/material.dart';
// lab4: import the encryption package
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

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

  // lab4: create the instance of EncryptedSharedPreferences
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  // login / home page png
  String imageSource = 'assets/question.png';
  String imageLabel = 'Question Mark';

  // lab4: check for saved data when the app starts
  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // lab4: logic to load username/password
  void _loadSavedData() async {
    // using 'await' because reading from disk takes a tiny bit of time
    String? savedLogin = await _encryptedData.getString('login_key');
    String? savedPassword = await _encryptedData.getString('password_key');

    // if found data, fill boxes and show the SnackBar
    if (savedLogin != null && savedPassword != null && savedLogin.isNotEmpty) {
      setState(() {
        _loginController.text = savedLogin;
        _passwordController.text = savedPassword;
      });

      // show the SnackBar as required
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login information loaded!')),
        );
      }
    }
  }

  void _handleLogin() {
    // Week 2 logic for the images
    setState(() {
      String password = _passwordController.text;
      if (password == "ASDF") {
        imageSource = 'assets/idea.png';
        imageLabel = 'Light Bulb';
      } else {
        imageSource = 'assets/stop.png';
        imageLabel = 'Stop Sign';
      }
    });

    // 2-> lab4: show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Login?"),
          content: const Text("Do you want to save your username and password for next time?"),
          actions: [
            // "No" button
            TextButton(
              onPressed: () {
                // overwriting with empty
                _encryptedData.setString('login_key', '');
                _encryptedData.setString('password_key', '');

                Navigator.of(context).pop(); // close dialog
              },
              child: const Text("No"),
            ),
            // "Yes" button
            TextButton(
              onPressed: () {
                // Requirement: "save the two strings to EncryptedSharedPreferences"
                _encryptedData.setString('login_key', _loginController.text);
                _encryptedData.setString('password_key', _passwordController.text);
                Navigator.of(context).pop(); // close dialog
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
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

              // login button
              ElevatedButton(
                onPressed: _handleLogin, // calls new function
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // image with semantics
              Semantics(
                label: imageLabel,
                child: Image.asset(
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