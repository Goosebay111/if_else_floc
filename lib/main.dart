import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var myController = TextEditingController();
  late Drink dropdownValue;

  @override
  void initState() {
    dropdownValue = selection.first;
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            var bartender = Bartender();
            var writtenAge = myController.text;
            var convertedAge = int.parse(writtenAge);
            var response = bartender.askForDrink(dropdownValue, convertedAge);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Your drink is...'),
                  content: Text(response),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } catch (_) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Please enter a valid number'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          }
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<String>(
              value: dropdownValue.name,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = selection.firstWhere(
                    (Drink drink) => drink.name == newValue,
                  );
                });
              },
              items: selection.map<DropdownMenuItem<String>>(
                (Drink drink) {
                  return DropdownMenuItem<String>(
                    value: drink.name,
                    child: Text(drink.name),
                  );
                },
              ).toList(),
            ),
          ),
          Text(dropdownValue.name),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your age',
              ),
              keyboardType: TextInputType.number,
              controller: myController,
            ),
          ),
        ],
      ),
    );
  }
}

abstract class Drink {
  var name = "";
  String handle(int age);
}

List<Drink> selection = [
  Beer(),
  Juice(),
];

class Beer implements Drink {
  @override
  var name = "Beer";
  @override
  String handle(int age) {
    if (age < 18) {
      return 'You are too young to drink $name, in Australia!';
    }
    return 'Have a beer.';
  }
}

class Juice implements Drink {
  @override
  var name = "Juice";
  @override
  String handle(int age) => 'Here is your $name.';
}

class Bartender {
  String askForDrink(Drink drink, int age) => drink.handle(age);
}
