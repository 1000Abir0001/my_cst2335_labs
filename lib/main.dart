import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
// LAB 5: Import the new url_launcher package
import 'profile_repository.dart';
import 'profile_page.dart';

void main() {
  runApp(const MyApp());
}

// LAB 5: The Repository Pattern



//
// MyApp & Login Page (First Page)
//
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
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  // LAB 5: create the repository instance
  final ProfileRepository _repository = ProfileRepository();

  String imageSource = 'assets/question.png';
  String imageLabel = 'Question Mark';

  //also starts when refresh
  @override
  void initState() {
    super.initState();

    _loadSavedLoginData();
    // LAB 5: load the repository data on the first page once app loads
    _repository.loadData();
  }

  void _loadSavedLoginData() async {
    String? savedLogin = await _encryptedData.getString('login_key');
    String? savedPassword = await _encryptedData.getString('password_key');

    // a check to make sure it ignores Password
    if (savedLogin.isNotEmpty && savedPassword.isNotEmpty && savedLogin != 'CLEARED#@1') {
      setState(() {
        _loginController.text = savedLogin;
        _passwordController.text = savedPassword;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login information loaded! ${_loginController.text}')),
        );
      }
    }
  }

  void _handleLogin() {
    setState(() {
      String password = _passwordController.text;

      if (password == "ASDF" ) {
        imageSource = 'assets/idea.png';
        imageLabel = 'Light Bulb';

        // LAB 5: shows "Welcome Back" + login name
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome Back ${_loginController.text}')),
        );

        // LAB 5: navigate to the ProfilePage and pass the repository
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              loginName: _loginController.text,
              repository: _repository,
            ),
          ),
        );
      } else {
        imageSource = 'assets/stop.png';
        imageLabel = 'Stop Sign';
      }
    });

    // Week 4 Alert Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Login?"),
          content: const Text("Do you want to save your username and password for next time?"),
          actions: [
            TextButton(
              onPressed: () async {
                // overwrite the safe with our secret codeword
                await _encryptedData.setString('login_key', 'CLEARED#@1');
                await _encryptedData.setString('password_key', 'CLEARED#@1');

                // wipe the text boxes on the screen instantly
                _loginController.clear();
                _passwordController.clear();

                // close popup
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                _encryptedData.setString('login_key', _loginController.text);
                _encryptedData.setString('password_key', _passwordController.text);

                // close popup
                Navigator.of(context).pop();
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
    // week4 box sizes, spaces
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Login', style: TextStyle(color: Colors.blue, fontSize: 25)),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: imageLabel,
                child: Image.asset(
                  imageSource, width: 300, height: 300,
                  errorBuilder: (context, error, stackTrace) => const Column(
                    children: [Icon(Icons.error, size: 50, color: Colors.red), Text("Image not found!")],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


