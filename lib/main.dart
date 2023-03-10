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
        iconTheme: IconThemeData(color: Colors.purple.shade200),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _urlController = TextEditingController();
  final _responseController = TextEditingController();

  Future<Response>? _future;

  String _displayContent = "";
  Map<String, String> header = {};

  List<String> previousUrls = [];

  bool isPhone() {
    return Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.iOS;
  }

  void runButtonMethod(
      Function(Uri, Map<String, String> header) toRun, String url) {
    setState(() {
      _responseController.text = "";
      _future = toRun(Uri.parse(url), header)
        ..then((value) {
          http.Response response = value as http.Response;
          updateCookie(response);
          setState(() {
            if (!previousUrls.contains(_urlController.text))
              previousUrls.insert(0, _urlController.text);
            print(
                "Added url ${_urlController.text}. Now at ${previousUrls.length}");
            _displayContent =
                "Status: ${response.statusCode} | Reason: ${response.reasonPhrase}";
          });
        });
      FocusScope.of(context).unfocus();
    });
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers["set-cookie"];
    if (rawCookie != null) {
      print("Received Raw Cookie");
      print(rawCookie);
      List<String> split = rawCookie.split(";");
      header["cookie"] = split[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonSize = isPhone() ? 64 : 48;

    return Scaffold(
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      key: _scaffoldKey,
      body: Center(
        child: Column(
          children: [
            if (isPhone())
              const SizedBox(
                height: 32,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  TextField(
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
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                            splashRadius: 12,
                            icon: const Icon(Icons.history)),
                      ],
                    ),
                  )
                ],
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
                        onPressed: () => runButtonMethod(
                            (p0, h) => http.post(p0, headers: h),
                            _urlController.text),
                        child: const Text("POST"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () => runButtonMethod(
                            (p0, h) => http.get(p0, headers: h),
                            _urlController.text),
                        child: const Text("GET"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () => runButtonMethod(
                            (p0, h) => http.put(p0, headers: h),
                            _urlController.text),
                        child: const Text("PUT"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () => runButtonMethod(
                            (p0, h) => http.patch(p0, headers: h),
                            _urlController.text),
                        child: const Text("PATCH"),
                      ))),
                  SizedBox(
                      height: buttonSize,
                      child: FittedBox(
                          child: ElevatedButton(
                        onPressed: () => runButtonMethod(
                            (p0, h) => http.delete(p0, headers: h),
                            _urlController.text),
                        child: const Text("DELETE"),
                      ))),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(_displayContent,
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 4.0, 32.0, 32.0),
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
                        } else if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
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
      endDrawer: Drawer(
        backgroundColor: Colors.black45,
        child: Column(
          children: [
            SafeArea(
                child: SizedBox(
              height: 92,
              child: DrawerHeader(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            previousUrls.clear();
                          });
                        },
                        icon: const Icon(Icons.playlist_remove)),
                  ],
                ),
              ),
            )),
            Expanded(
              child: previousUrls.isEmpty
                  ? Center(
                      child: Text(
                      "(Empty)",
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      itemCount: previousUrls.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(previousUrls[i]),
                          tileColor: Colors.black54,
                          trailing: IconButton(
                            splashRadius: 12,
                            onPressed: () {
                              setState(() {
                                previousUrls.removeAt(i);
                              });
                            },
                            icon: const Icon(Icons.remove, color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                              _urlController.text = previousUrls[i];
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery
          .of(context)
          .size
          .width,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _responseController.text = "";
                _displayContent = "";
                _future = null;
              });
            },
            tooltip: 'Clear Log',
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(
            height: 12,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                header = {};
              });
            },
            tooltip: 'Clear Header',
            child: const Icon(Icons.cookie),
          ),
        ],
      ),
    );
  }
}
