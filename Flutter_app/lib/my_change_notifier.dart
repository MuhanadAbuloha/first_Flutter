import 'package:flutter/material.dart';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'admin_page.dart';
import 'user.dart';

class MyChangeNotifier extends ChangeNotifier {
  List<User> users = [];

//get all data

  Future<void> fetchData(BuildContext context) async {
    var url = Uri.parse('http://localhost:8081/api/users/allusers');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        List<dynamic> data = json.decode(response.body);
        List<User> userList = data.map((json) => User.fromJson(json)).toList();

        // Update the state with the fetched data

        users = userList;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        showSnackBar('Failed to load data', context);
      }
    } catch (e) {
      showSnackBar('$e', context);
    }
  }

  Future<void> login(
      String username, String password, BuildContext context) async {
    var url = Uri.parse('http://localhost:8081/api/users/login');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      showSnackBar('Login successful!', context);

      Map<String, dynamic> userData = jsonDecode(response.body);

      // Check if the user is an admin
      bool isAdmin = userData['admin'];
      checkAdmin(isAdmin, context);
    } else {
      // Login failed
      showSnackBar('Invalid username or password', context);
    }
  }

  void checkAdmin(bool isAdmin, BuildContext context) {
    if (isAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Future<void> signUp(
      String username, String password, BuildContext context) async {
    var url = Uri.parse('http://localhost:8081/api/users/signup');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'admin': false,
      }),
    );

    if (response.statusCode == 201) {
      // Signup successful
      showSnackBar('Sign Up successful!', context);
    } else if (response.statusCode == 404) {
      // Username already taken
      showSnackBar(
          'Username is already taken. Please choose another.', context);
    } else {
      // Signup failed
      showSnackBar('Sign Up failed. Please try again.', context);
    }
  }

  void saveUser(
      BuildContext context,
      User user,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController isAdminController) async {
    String isAdmin = isAdminController.text.toLowerCase();
    if (isAdmin == "true" || isAdmin == "false") {
      User newUser = User(
          id: user.id,
          username: usernameController.text,
          password: passwordController.text,
          isAdmin: isAdminController.text.toLowerCase() == "true");

      // Make a PUT request to update the user
      var url = Uri.parse('http://localhost:8081/api/users/${user.id}');
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': newUser.username,
          'password': newUser.password,
          'admin': newUser.isAdmin,
        }),
      );

      if (response.statusCode == 200) {
        showSnackBar('User information updated!', context);
        fetchData(context);
      } else if (response.statusCode == 404) {
        showSnackBar(
            'Username is already taken. Please choose another.', context);
      } else {
        showSnackBar('Update failed. Please try again.', context);
      }
    } else {
      showSnackBar(
          'Wrong input in isAdmin !! please insert true or false', context);
    }
  }

  bool checkadmin(String isAdmin) {
    if (isAdmin == "true" || isAdmin == "false") {
      return true;
    } else {
      return false;
    }
  }

  void deleteUser(User user, BuildContext context) async {
    // Make a DELETE request to delete the user
    var url = Uri.parse('http://localhost:8081/api/users/${user.id}');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      showSnackBar('User deleted!', context);
      fetchData(context);
    } else {
      showSnackBar('Failed to delete user', context);
    }
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
