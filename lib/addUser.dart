import 'package:flutter/material.dart';
import 'package:user_data/database.dart';
import 'package:user_data/user.dart';

class AddUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddUserState();
  }
}

class AddUserState extends State<AddUser> {
  User newUser = User('', '', '');

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: firstNameController,
              onChanged: (value) {
                debugPrint(
                    'Something changed in First Name Text Field ${firstNameController.text}');
                newUser.firstName = firstNameController.text;
              },
              decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: lastNameController,
                onChanged: (value) {
                  debugPrint('Something changed in Last Name Text Field');
                  newUser.lastName = lastNameController.text;
                },
                decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: emailController,
                onChanged: (value) {
                  newUser.email = emailController.text;
                },
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      child: Text('Save'),
                      onPressed: () {
                        setState(() {
                          debugPrint('Save Button Clicked');
                          _saveUser();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        setState(() {
                          debugPrint('Cancel Button Print');
                          Navigator.pop(context, true);
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //Save User to the Database
  void _saveUser() async {
    DatabaseHelper helper = DatabaseHelper();
    int result = await helper.insertUser(newUser);

    if (result != 0) {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'User is Successfully Added.');
    } else {
      _showAlertDialog('Status', 'User not Added.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(message),
            ));
  }
}
