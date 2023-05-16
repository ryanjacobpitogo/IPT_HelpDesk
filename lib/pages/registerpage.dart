import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/user.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _fNameController = TextEditingController();
  late final TextEditingController _lNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  height: 600,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/logo-no-background.png', width: 240,),
                      const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 26,
                          color: Color.fromARGB(255, 119, 7, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _fNameController,
                        label: 'First Name',
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _lNameController,
                        label: 'Last Name',
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        title: 'REGISTER',
                        fColor: Colors.white,
                        bColor: const Color.fromARGB(255, 119, 7, 255),
                        onPress: () {
                          if (_passwordController.text.isEmpty &&
                              _usernameController.text.isEmpty  &&
                              _fNameController.text.isEmpty &&
                              _lNameController.text.isEmpty) {
                            snackBarText = 'All of the fields is empty';
                          } else if (_passwordController.text.isEmpty ||
                              _usernameController.text.isEmpty  ||
                              _fNameController.text.isEmpty ||
                              _lNameController.text.isEmpty) {
                            snackBarText = 'One of the fields is empty';
                          }
                          else{
                            snackBarText = 'User registered';             
                          }
                          Future.delayed(Duration.zero).then((value) =>
                                SnackBarService.showSnackBar(
                                    content: snackBarText));
                          if (_passwordController.text.isNotEmpty &&
                              _usernameController.text.isNotEmpty &&
                              _fNameController.text.isNotEmpty &&
                              _lNameController.text.isNotEmpty) {
                            String id = const Uuid().v4();
                            final user = User(
                              userId: id,
                              username: _usernameController.text,
                              password: _passwordController.text,
                              firstName: _fNameController.text,
                              lastName: _lNameController.text,
                              is_active: true,
                              is_staff: false,
                              is_superuser: false,
                            );
                            Map<String, String> headers = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json',
                            };
                    
                            String url = '${Env.urlPrefix}/register/';
                    
                            http.post(Uri.parse(url),
                                headers: headers, body: jsonEncode(user.toJson()));
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      CustomButton(
                        title: 'BACK TO LOGIN',
                        fColor: Colors.white,
                        bColor: const Color.fromARGB(255, 119, 7, 255),
                        onPress: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
