import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensor/data/local/db/app_database.dart';
import 'package:flutter_sensor/ui/main/dashboard_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

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

  late AppDatabase appDatabase;

  var isShowPassword = false;

  @override
  void initState() {
    super.initState();

    appDatabase = Provider.of<AppDatabase>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 120),
                  child: Image.asset('assets/images/img_synapsis_logo.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 148),
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
                    obscureText: !isShowPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: 'Password',
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: !isShowPassword
                          ? IconButton(
                              onPressed: _onShowPassword,
                              icon: Icon(
                                Icons.visibility_rounded,
                                color: colorScheme.primary,
                              ),
                            )
                          : IconButton(
                              onPressed: _onHidePassword,
                              icon: Icon(
                                Icons.visibility_off,
                                color: colorScheme.primary,
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  width: 160,
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
                  child: OutlinedButton(
                    onPressed: _onLogin,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: colorScheme.primary,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 64,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.primary,
                        ),
                        onPressed: _onLoginWithFingerprint,
                        icon: const Icon(Icons.fingerprint, size: 48),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onShowPassword() {
    setState(() {
      isShowPassword = true;
    });
  }

  void _onHidePassword() {
    setState(() {
      isShowPassword = false;
    });
  }

  void _onLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();

    var username = usernameEditing.text.trim();
    var password = passwordEditing.text;

    appDatabase.userDao.userList(username).then((userList) {
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

  void _onLoginWithFingerprint() async {
    var localAuth = LocalAuthentication();

    var canCheckBiometrics = await localAuth.canCheckBiometrics;
    var canAuthenticate =
        canCheckBiometrics || await localAuth.isDeviceSupported();

    if (!canAuthenticate) {
      Fluttertoast.showToast(msg: 'Unable to use biometrics with this devices');
      return;
    }

    localAuth
        .authenticate(
      localizedReason: 'Login with fingerprint',
      options: const AuthenticationOptions(biometricOnly: true),
    )
        .then((isSuccess) {
      if (isSuccess) {
        Navigator.pushReplacementNamed(context, HomePage.route);
      } else {
        Fluttertoast.showToast(msg: 'Login cancelled');
      }
    }).catchError((e) {
      if (e is PlatformException) {
        if (e.code == auth_error.notAvailable) {
          Fluttertoast.showToast(msg: 'Biometrics not available');
        } else if (e.code == auth_error.notEnrolled) {
          Fluttertoast.showToast(msg: 'Please set biometric first');
        } else {
          Fluttertoast.showToast(msg: 'Error ${e.code}');
        }
      } else {
        Fluttertoast.showToast(msg: 'Unknown Error $e');
      }
    });
  }
}
