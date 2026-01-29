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
  // changing _counter to use 'var' or 'double' and start at 0
  double _counter = 0.0;

  //  myFontSize and starting it to 30
  double myFontSize = 30.0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

// update font size and the counter
  void setNewValue(double value) {
    setState(() {
      myFontSize = value;
      _counter = value;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // use myFontSize in TextStyle and remove 'const'
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: myFontSize),
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: myFontSize), // ssing the variable here
            ),

            // add a slider widget
            Slider(
              value: myFontSize,
              min: 10.0, // min font
              max: 100.0, // max font
              onChanged: (double newValue) {
                // call function to update the size
                setNewValue(newValue);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}