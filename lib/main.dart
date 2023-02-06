import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  final _urlController = TextEditingController();
  final _responseController = TextEditingController();

  Future<Response>? _future;

  bool isPhone() {
    return Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = isPhone() ? 64 : 48;
    String displayContent;

    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: Center(
        child: Column(
          children: [
            if (isPhone())
              SizedBox(
                height: 32,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _urlController,
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
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: isPhone() ? -8 : 8,
                children: [
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Uri uri = Uri.parse(_urlController.text);
                            _future = http.post(uri);
                          });
                        },
                        child: const Text("POST"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Uri uri = Uri.parse(_urlController.text);
                            _future = http.get(uri);
                          });
                        },
                        child: const Text("GET"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Uri uri = Uri.parse(_urlController.text);
                            _future = http.put(uri);
                          });
                        },
                        child: const Text("PUT"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Uri uri = Uri.parse(_urlController.text);
                            _future = http.patch(uri);
                          });
                        },
                        child: const Text("PATCH"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Uri uri = Uri.parse(_urlController.text);
                            _future = http.delete(uri);
                          });
                        },
                        child: const Text("DELETE"),
                      ))),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Stack(
                children: [
                  if (_future != null)
                    FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        print("snapshot update $snapshot");
                        if (snapshot.hasError) {
                          return Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: FittedBox(
                                      child: Icon(
                                    Icons.error_outline_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ))));
                        } else if (snapshot.hasData) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            _responseController.text = snapshot.data!.body;
                          });
                          return Container();
                        } else {
                          return Container(
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(),
                              ));
                        }
                      },
                    ),
                  Container(
                      color: Colors.black12,
                      child: TextField(
                          controller: _responseController,
                          readOnly: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1000))
                ],
              ),
            ))
            //Expanded(child: Placeholder())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _future = null;
            _responseController.text = "";
          });
        },
        tooltip: 'Clear',
        child: const Icon(Icons.delete_forever),
      ),
    );
  }
}
