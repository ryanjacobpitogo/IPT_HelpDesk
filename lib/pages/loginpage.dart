import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool tresponse = false;

  Future<User> _login() async {
    final url = Uri.parse('${Env.urlPrefix}/login/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text
        }));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final user = User.fromJson(jsonBody);
      Future.delayed(Duration.zero).then((value) =>
          SnackBarService.showSnackBar(content: "Login Successful."));
      return user;
    } else {
      if (_passwordController.text.isEmpty &&
          _usernameController.text.isEmpty) {
        snackBarText = 'All of the fields is empty';
        Future.delayed(Duration.zero).then(
            (value) => SnackBarService.showSnackBar(content: snackBarText));
      }
      else if (_passwordController.text.isEmpty ||
          _usernameController.text.isEmpty) {
        snackBarText = 'One of the fields is empty';
        Future.delayed(Duration.zero).then(
            (value) => SnackBarService.showSnackBar(content: snackBarText));
      } else {
        Future.delayed(Duration.zero).then((value) =>
            SnackBarService.showSnackBar(
                content: "Invalid username or password"));
      }
      throw Exception('Failed to login');
    }
  }

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
                        'LOGIN',
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
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        title: 'LOG IN',
                        fColor: Colors.white,
                        bColor: const Color.fromARGB(255, 119, 7, 255),
                        onPress: () async {
                          User user = await _login();
                          if (context.mounted) {
                            context.read<UserProvider>().setUser(user);
                            context.read<UserProvider>().fetchUserList();
                            context.read<CategoryProvider>().fetchCategoryList();
                            context.read<TopicProvider>().fetchTopicList();
                            context.read<CommentProvider>().fetchCommentList();
                            context.read<ReplyProvider>().fetchReplyList();
                            Navigator.pushNamed(context, '/home');
                  
                            // // if (context.mounted) {
                  
                            //   if (user.isActive == true) {
                            //     // context.read<UserProvider>().setUser(user);
                            //     // Navigator.pushNamed(context, '/home');
                            //   }
                            // }
                            // if (validLogin(
                            //     _usernameController.text, _passwordController.text)) {
                            //   context.read<UserProvider>().setCurrentUser(user);
                            //   Navigator.pushNamed(context, '/home');
                          }
                        },
                      ),
                      CustomButton(
                        title: 'REGISTER',
                        fColor: Colors.white,
                        bColor: const Color.fromARGB(255, 119, 7, 255),
                        onPress: () {
                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                      CustomButton(
                        title: ' LOGIN THROUGH FACEBOOK',
                        bColor: Colors.blue,
                        fColor: Colors.white,
                        onPress: () {},
                      ),
                      CustomButton(
                        title: ' CONTINUE WITH GOOGLE',
                        bColor: Colors.white,
                        fColor: Colors.black,
                        onPress: () {},
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
