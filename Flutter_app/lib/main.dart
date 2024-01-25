import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_change_notifier.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => MyChangeNotifier(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'First App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First App',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[buildLeftContainer(), buildRightContainer()],
      ),
    );
  }

  Widget buildLeftContainer() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.blue,
        child: Center(child: columnLeft()),
      ),
    );
  }

  Widget columnLeft() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Image.asset(
        //   'images/icon.png',
        //   height: 150,
        //   width: 150,
        // ),
        const SizedBox(height: 20),
        welcome()
      ],
    );
  }

  Text welcome() {
    return const Text(
      'Welcome',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildRightContainer() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[form()], // the gif is here
        ),
      ),
    );
  }

  Widget form() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          userName(),
          const SizedBox(height: 10),
          password(),
          const SizedBox(height: 20),
          buttonForm(),
        ],
      ),
    );
  }

  // Widget positionedgif() {
  //   return Positioned(
  //     top: 0,
  //     left: 0,
  //     child: Image.asset(
  //       'images/Preloader.gif',
  //       height: 100,
  //       width: 100,
  //     ),
  //   );
  // }

  Widget userName() {
    return TextField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
      ),
    );
  }

  Widget password() {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
      ),
    );
  }

  Widget buttonForm() {
    return Row(
      children: <Widget>[
        elevated("Login"),
        const SizedBox(width: 10),
        elevated("Sign Up")
      ],
    );
  }

  Widget elevated(String name) {
    return ElevatedButton(
      onPressed: () {
        connect(name);
      },
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(200, 50),
        backgroundColor: Colors.cyan,
      ),
      child: Text(name, style: const TextStyle(color: Colors.white)),
    );
  }

  void connect(String name) {
    String username = usernameController.text;
    String password = passwordController.text;
    if (name == "Login") {
      context.read<MyChangeNotifier>().login(username, password, context);
    } else {
      if (checkisnotnull(username, password) == true) {
        context.read<MyChangeNotifier>().signUp(username, password, context);
      } else {
        context
            .read<MyChangeNotifier>()
            .showSnackBar('No empty value is allowed !!', context);
      }
    }
  }

  bool checkisnotnull(String username, String password) {
    if (username != "" && password != "") {
      return true;
    } else {
      return false;
    }
  }
}
