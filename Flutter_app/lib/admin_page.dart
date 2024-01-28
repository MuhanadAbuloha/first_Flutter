import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'my_change_notifier.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data from API when the page is initialized
    context.read<MyChangeNotifier>().fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
        ),
        body: Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: containerTable()),
        ));
  }

  Container containerTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Set the color of the border
        borderRadius: BorderRadius.circular(10.0), // Set the border radius
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(
              10.0), //make the background color radius like border
          clipBehavior: Clip.antiAlias,
          child: datatable()),
    );
  }

  DataTable datatable() {
    return DataTable(
      headingRowColor: MaterialStateColor.resolveWith((states) {
        return Colors.cyan;
      }),
      dividerThickness: 2.0,
      columns: [
        //header coulms
        datacoulmn('ID'),
        datacoulmn('Username'),
        datacoulmn('Password'),
        datacoulmn('Admin'),
        datacoulmn('Actions')
      ],
      rows: context
          .read<MyChangeNotifier>()
          .users
          .map((user) => buildDataRow(user))
          .toList(),
    );
  }

  DataColumn datacoulmn(String text) {
    return DataColumn(
      label: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  DataRow buildDataRow(User user) {
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController passwordController =
        TextEditingController(text: user.password);
    TextEditingController isAdminController =
        TextEditingController(text: user.isAdmin.toString());

    return datarow(
        user, usernameController, passwordController, isAdminController);
  }

  DataRow datarow(
      User user,
      TextEditingController usernameController,
      TextEditingController passwordController,
      TextEditingController isAdminController) {
    return DataRow(cells: [
      DataCell(Text(user.id.toString())),
      DataCell(TextField(controller: usernameController)),
      DataCell(TextField(controller: passwordController)),
      DataCell(TextField(controller: isAdminController)),
      dataCell(
        user,
        usernameController,
        passwordController,
        isAdminController,
      ),
    ]);
  }

  DataCell dataCell(
    User user,
    TextEditingController usernameController,
    TextEditingController passwordController,
    TextEditingController isAdminController,
  ) {
    return DataCell(
      Row(
        children: [
          savebutton(
            user,
            usernameController,
            passwordController,
            isAdminController,
          ),
          const SizedBox(width: 8),
          deletebutton(user),
        ],
      ),
    );
  }

  ElevatedButton savebutton(
    User user,
    TextEditingController usernameController,
    TextEditingController passwordController,
    TextEditingController isAdminController,
  ) {
    return ElevatedButton(
      onPressed: () {
        context.read<MyChangeNotifier>().updateUser(
              context,
              user,
              usernameController,
              passwordController,
              isAdminController,
            );
      },
      child: buttonText("Save"),
    );
  }

  ElevatedButton deletebutton(User user) {
    return ElevatedButton(
      onPressed: () {
        context.read<MyChangeNotifier>().deleteUser(user, context);
      },
      child: buttonText("Delete"),
    );
  }

  Text buttonText(String text) {
    return Text(text);
  }
}
