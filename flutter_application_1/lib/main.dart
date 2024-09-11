import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page _ Updated'),
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
  int _counter = 0;
  WordPair curWPObj = WordPair.random();
  var favWPList = <WordPair>[];

  _MyHomePageState() {
    favWPList.add(WordPair('Hello', 'World'));
  }
  void _getNewIdea() {
    setState(() {
      curWPObj = WordPair.random();
    });
  }

  void _toggleFavoriteWordPair() {
    setState(() {
      if (favWPList.contains(curWPObj)) {
        favWPList.remove(curWPObj);
      } else {
        favWPList.add(curWPObj);
      }
    });
  }

  void _resetFavorites() {
    setState(() {
      favWPList.clear();
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('A random idea !!!',
                            style: TextStyle(fontSize: 20, color: Colors.cyan)),
                        WPCardWidget(wpObject: curWPObj),
                      ],
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        onPressed: _toggleFavoriteWordPair,
                        icon: const Icon(Icons.favorite,
                            color: Colors.pinkAccent, size: 30)),
                    IconButton(
                        onPressed: _getNewIdea,
                        icon: const Icon(Icons.refresh,
                            color: Colors.green, size: 30)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Favorite Ideas: ', style: TextStyle(fontSize: 20)),
                WPListWidget(favWPList: favWPList),
                ElevatedButton(
                    onPressed: _resetFavorites,
                    child: const Icon(Icons.delete,
                        color: Colors.redAccent, size: 20)),
              ],
            ),
            const SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('You have pushed bottom button this many times:\t'),
                Text('$_counter',
                    style: Theme.of(context).textTheme.headlineMedium),
                FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add)),
              ],
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )));
  }
}

class WPCardWidget extends StatelessWidget {
  const WPCardWidget({
    super.key,
    required this.wpObject,
  });

  final WordPair wpObject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 30.0,
      shadowColor: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(wpObject.asPascalCase,
            style: style, textAlign: TextAlign.left),
      ),
    );
  }
}

class WPListWidget extends StatefulWidget {
  const WPListWidget({
    super.key,
    required this.favWPList,
  });

  final List<WordPair> favWPList;

  @override
  State<StatefulWidget> createState() => _WPListWidgetState();
}

class _WPListWidgetState extends State<WPListWidget> {
  void _removeFav(int index) {
    setState(() {
      widget.favWPList.remove(widget.favWPList[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium!.copyWith(color: Colors.green);
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: SizedBox(
        width: 400,
        child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children:
                List<Widget>.generate(widget.favWPList.length, (int index) {
              return TextButton(
                  onPressed: () {
                    _removeFav(index);
                  },
                  child:
                      Text(widget.favWPList[index].asPascalCase, style: style));
            })),
      ),
    );
  }
}
