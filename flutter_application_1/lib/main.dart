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
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Home Page'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int _counter = 0;
  WordPair curWPObj = WordPair.random();
  var favWPList = <WordPair>[];

  MyAppState() {
    _counter = 0;
    favWPList.add(WordPair('Hello', 'World'));
  }

  void _getNewIdea() {
    curWPObj = WordPair.random();
    notifyListeners();
  }

  void _toggleFavoriteWordPair() {
    if (favWPList.contains(curWPObj)) {
      favWPList.remove(curWPObj);
    } else {
      favWPList.add(curWPObj);
    }
    notifyListeners();
  }

  void _resetFavorites() {
    favWPList.clear();
    notifyListeners();
  }

  void _incrementCounter() {
    _counter++;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    Widget pageToShow;
    switch (selectedIndex) {
      case 0:
        pageToShow = const SelectionPage();
        break;
      case 1:
        pageToShow = const FavoritePage();
        break;
      case 2:
        pageToShow = const CounterDemo();
        break;
      default:
        throw UnimplementedError("Invalid page @ $selectedIndex");
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: false,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.favorite_rounded), label: Text('Favorites')),
              NavigationRailDestination(icon: Icon(Icons.streetview), label: Text('Counter')),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          )),
          Expanded(child: Container(color: Theme.of(context).colorScheme.primaryContainer, child: pageToShow))
        ],
      ),
    );
  }
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var curWP = appState.curWPObj;

    IconData iconFav;
    if (appState.favWPList.contains(curWP)) {
      iconFav = Icons.favorite;
    } else {
      iconFav = Icons.favorite_border;
    }

    return Center(
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
                    const Text('A random title idea !!!', style: TextStyle(fontSize: 30, color: Colors.cyan)),
                    WPCardWidget(wpObject: curWP),
                  ],
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    appState._toggleFavoriteWordPair();
                  },
                  icon: Icon(iconFav),
                ),
                IconButton(
                  onPressed: () {
                    appState._getNewIdea();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.green, size: 30),
                ),
              ],
            ),
          ],
        )
      ],
    ));
  }
}

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Favorite Ideas: ', style: TextStyle(fontSize: 20)),
          WPListWidget(favWPList: appState.favWPList),
          ElevatedButton(
              onPressed: () {
                appState._resetFavorites();
              },
              child: const Icon(Icons.delete, color: Colors.redAccent, size: 20)),
        ],
      ),
    );
  }
}

class CounterDemo extends StatelessWidget {
  const CounterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var counter = appState._counter;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 200),
          Text(
            'You have pushed this button\t $counter \tmany times.\t',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          FloatingActionButton(
            onPressed: appState._incrementCounter,
            tooltip: 'Increment',
            foregroundColor: Colors.blue,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
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
    final style = theme.textTheme.displayMedium!.copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 30.0,
      shadowColor: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(wpObject.asPascalCase, style: style, textAlign: TextAlign.left),
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
            children: List<Widget>.generate(widget.favWPList.length, (int index) {
              return TextButton(
                  onPressed: () {
                    _removeFav(index);
                  },
                  child: Text(widget.favWPList[index].asPascalCase, style: style));
            })),
      ),
    );
  }
}
