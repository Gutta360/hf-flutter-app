import 'package:flutter/material.dart';
import 'package:hffa/layout/layout.dart';
import 'package:hffa/main.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  LoginPage({required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool isLoggedIn = false; // Track login state

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // void _login({required globalData}) {
  //   if (_formKey.currentState!.validate()) {
  //     // Simulate login logic
  //     print('Logging in with $_email and $_password');
  //     globalData.setIsUserLoggedIn(true);
  //     setState(() {
  //       isLoggedIn = true;
  //     });

  //     // Notify the parent widget about the successful login
  //     widget.onLoginSuccess();
  //   }
  // }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LayoutWidget()),
      (Route<dynamic> route) => false,
    );
    // setState(() {
    //   isLoggedIn = false;
    //   _emailController.clear();
    //   _passwordController.clear();
    // });
    print('User logged out');
  }

  @override
  Widget build(BuildContext context) {
    final globalData = Provider.of<GlobalData>(context);
    print("**********222222********** ${globalData.isUserLoggedIn} ");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: isLoggedIn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You logged in Successfully!!!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 38),
                    ElevatedButton(
                      onPressed: () {
                        globalData.setIsUserLoggedIn(false);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutWidget()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        minimumSize: Size(120, 40),
                        textStyle: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: 38),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Logging in with $_email and $_password');
                            globalData.setIsUserLoggedIn(true);
                            setState(() {
                              isLoggedIn = true;
                            });
                            widget.onLoginSuccess();
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          minimumSize: Size(120, 40),
                          textStyle: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _forgotPassword() {
    print('Redirect to forgot password screen');
  }
}
