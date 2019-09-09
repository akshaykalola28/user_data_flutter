import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:user_data/addUser.dart';
import 'package:user_data/database.dart';
import 'package:user_data/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int count = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> userList;

  @override
  Widget build(BuildContext context) {
    debugPrint('1.');
    if (userList == null) {
      debugPrint('2.');
      userList = List<User>();
      updateUserList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: getUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          debugPrint('FAB Clicked');
          bool result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return AddUser();
          }));

          if (result == true) {
            updateUserList();
          }
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getUserList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        final key = userList[position].id.toString();
        return Dismissible(
          key: Key(key),
          onDismissed: (direction) {
            _deleteUser(userList[position].id);
            userList.removeAt(position);

            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("$key dismissed")));
            updateUserList();
          },
          child: Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(userList[position].id.toString()),
              ),
              title: Text(userList[position].firstName +
                  ' ' +
                  userList[position].lastName),
              subtitle: Text(userList[position].email),
              onTap: () {
                debugPrint('List Click');
              },
            ),
          ),
        );
      },
    );
  }

  void updateUserList() {
    Future<Database> dbFuture = databaseHelper.initDB();
    dbFuture.then((database) {
      Future<List<User>> userListFuture = databaseHelper.getUserList();
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.count = userList.length;
        });
      });
    });
  }

  void _deleteUser(int id) async {
    int result = await databaseHelper.deleteUser(id);
  }
}
