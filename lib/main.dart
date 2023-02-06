import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chill',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF202020),
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Chill'),
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
  bool isPhone() {
    return Theme.of(context).platform == TargetPlatform.android || Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = isPhone() ? 64 : 48;

    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Center(
        child: Column(
          children: [
            if(isPhone()) SizedBox(height: 32,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: InputDecoration(
                    label: const Text("URL"),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(128),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(128),
                        borderSide: const BorderSide(color: Colors.grey, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: isPhone() ? -8 : 8,
                children: [
                  SizedBox(height: buttonSize, child: FittedBox(child: ElevatedButton(onPressed: () {}, child: const Text("POST"), ))),
                  SizedBox(height: buttonSize, child: FittedBox(child: ElevatedButton(onPressed: () {}, child: const Text("GET"), ))),
                  SizedBox(height: buttonSize, child: FittedBox(child: ElevatedButton(onPressed: () {}, child: const Text("PUT"), ))),
                  SizedBox(height: buttonSize, child: FittedBox(child: ElevatedButton(onPressed: () {}, child: const Text("PATCH"), ))),
                  SizedBox(height: buttonSize, child: FittedBox(child: ElevatedButton(onPressed: () {}, child: const Text("DELETE"), ))),
                ],
              ),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(color: Colors.black12, child: TextField(readOnly: true, keyboardType: TextInputType.multiline, maxLines: 1000)),
            ))
            //Expanded(child: Placeholder())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Send Request',
        child: const Icon(Icons.send),
      ),
    );
  }
}
/*
class RadioElevatedButtonRow extends StatefulWidget {
  final List<String> options;
  final int selected;
  final Function(int) onSelectionChange;

  const RadioElevatedButtonRow({Key? key, required this.options, required this.selected, required this.onSelectionChange}) : super(key: key);

  @override
  State<RadioElevatedButtonRow> createState() => _RadioElevatedButtonRowState();
}

class _RadioElevatedButtonRowState extends State<RadioElevatedButtonRow> {
  @override
  Widget build(BuildContext context) {
    return
  }
}*/
