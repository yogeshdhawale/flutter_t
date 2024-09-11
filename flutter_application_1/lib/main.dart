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
  void _removeFavoriteItem(int index) {
      favWPList.remove(favWPList[index]);
      notifyListeners();
  }
  void _clearFavoriteList() {
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

  Widget getPageToShow(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const SelectionPage();
      case 1:
        return const FavoritePage();
      case 2:
        return const CounterDemo();
      default:
        throw UnimplementedError("Invalid page @ $selectedIndex");
    }
  }

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

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
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: getPageToShow(selectedIndex),
          ))
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
                  icon: Icon(
                    iconFav,
                    color: Colors.pinkAccent,
                    size: 30,
                  ),
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


  Container buildFavoriteList(BuildContext context, MyAppState appState) {

    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge!.copyWith(color: Colors.blue);
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: SizedBox(
          width: 400,
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: List<Widget>.generate(appState.favWPList.length, (int index) {
                return ListTile(
                  title: Text(appState.favWPList[index].asCamelCase, style: style,),
                  onLongPress: () {
                    appState._removeFavoriteItem(index);
                  },
                );
              }))),
    );
  }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Favorite Ideas: ${appState.favWPList.length}\t', style: const TextStyle(fontSize: 20)),
          ElevatedButton(
              onPressed: () {
                appState._clearFavoriteList();
              },
              child: const Icon(Icons.delete, color: Colors.redAccent, size: 20)),
          buildFavoriteList(context, appState),
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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 200),
          Text(
            'You have pushed this button\t ${appState._counter} \tmany times.\t',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          FloatingActionButton(
            onPressed: appState._incrementCounter,
            tooltip: 'Increment',
            foregroundColor: Colors.yellowAccent,
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



