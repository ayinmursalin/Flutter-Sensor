import 'package:flutter/material.dart';
import 'package:flutter_sensor/data/local/db/db_helper.dart';
import 'package:flutter_sensor/ui/main/dashboard_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static const route = '/auth/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey();
  final usernameEditing = TextEditingController();
  final passwordEditing = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
                child: Image.asset('assets/images/img_synapsis_logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 64),
                child: TextField(
                  controller: usernameEditing,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Username',
                    hintText: 'Username',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: TextField(
                  controller: passwordEditing,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Password',
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              Container(
                width: 160,
                margin: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: _onLogin,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Login'),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_right_alt_rounded)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    var username = usernameEditing.text;
    var password = passwordEditing.text;

    var userDao = await DbHelper.getUserDao();

    userDao.userList(username).then((userList) {
      if (userList.isEmpty) {
        Fluttertoast.showToast(msg: 'User is not exists');

        return;
      }

      if (userList.first.password != password) {
        Fluttertoast.showToast(msg: 'Password didn\'t match');

        return;
      }

      Navigator.pushReplacementNamed(context, HomePage.route);
    });
  }
}
