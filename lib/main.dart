import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
// LAB 5: Import the new url_launcher package
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// LAB 5: The Repository Pattern
// Using the repository pattern to store user's data

class ProfileRepository {
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

  // variables to hold loaded data
  String firstName = '';
  String lastName = '';
  String phone = '';
  String email = '';

  // loadData() - this function loads the variables
  Future<void> loadData() async {
    firstName = await _encryptedData.getString('firstName');
    lastName = await _encryptedData.getString('lastName');
    phone = await _encryptedData.getString('phone');
    email = await _encryptedData.getString('email');
  }

  // saveData() - this function saves the variables
  Future<void> saveData(String key, String value) async {
    await _encryptedData.setString(key, value);
  }
}

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
    if (savedLogin.isNotEmpty && savedPassword.isNotEmpty && savedLogin != 'CLEARED') {
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
                await _encryptedData.setString('login_key', 'CLEARED');
                await _encryptedData.setString('password_key', 'CLEARED');

                // wipe the text boxes on the screen instantly
                _loginController.clear();
                _passwordController.clear();

                // close the popup
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                _encryptedData.setString('login_key', _loginController.text);
                _encryptedData.setString('password_key', _passwordController.text);
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

//
// LAB 5: The Profile Page ->2nd page
//
class ProfilePage extends StatefulWidget {
  final String loginName;
  final ProfileRepository repository;

  const ProfilePage({super.key, required this.loginName, required this.repository});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // LAB 5: TextFields
  late final TextEditingController _firstController;
  late final TextEditingController _lastController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    //  loading data into the TextFields
    _firstController = TextEditingController(text: widget.repository.firstName);
    _lastController = TextEditingController(text: widget.repository.lastName);
    _phoneController = TextEditingController(text: widget.repository.phone);
    _emailController = TextEditingController(text: widget.repository.email);

    // LAB 5: addListener() to save data whenever text change
    _firstController.addListener(() => widget.repository.saveData('firstName', _firstController.text));
    _lastController.addListener(() => widget.repository.saveData('lastName', _lastController.text));
    _phoneController.addListener(() => widget.repository.saveData('phone', _phoneController.text));
    _emailController.addListener(() => widget.repository.saveData('email', _emailController.text));
  }

  // helper function to launch URLs and show AlertDialog if not supported
  Future<void> _launch(String scheme, String path) async {
    final Uri uri = Uri(scheme: scheme, path: path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text("URL is not supported on this device."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // LAB 5: Text widget saying "Welcome Back" followed by login name
            Text(
              "Welcome Back ${widget.loginName}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // first name
            TextField(
              controller: _firstController,
              decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // last name
            TextField(
              controller: _lastController,
              decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),

            // LAB 5: phone number row with Flexible widget
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _launch('tel', _phoneController.text),
                ),
                IconButton(
                  icon: const Icon(Icons.message),
                  onPressed: () => _launch('sms', _phoneController.text),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // LAB 5: Email Address Row with Flexible widget
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email address', border: OutlineInputBorder()),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mail),
                  onPressed: () => _launch('mailto', _emailController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}