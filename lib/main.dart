import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:helpdesk_app/widgets/add_topic_dialog.dart';
import 'package:helpdesk_app/widgets/custom_category_list.dart';
import 'package:helpdesk_app/widgets/custom_textfield.dart';
import 'package:helpdesk_app/widgets/custom_topic_list.dart';
import 'package:helpdesk_app/widgets/topic_details.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'widgets/add_category_dialog.dart';
import 'widgets/custom_button.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TopicProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
          primaryColor: const Color.fromARGB(255, 119, 7, 255),
        ),
        debugShowCheckedModeBanner: false,
        home: const TopicDetails(),
        routes: {
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    User user = User(username: '', password: '', firstName: '', lastName: '');
    bool validLogin(String username, String password) {
      for (int i = 0; i < provider.userList.length; i++) {
        if (username == provider.userList[i].username &&
            password == provider.userList[i].password) {
          user = provider.userList[i];
          return true;
        }
      }
      return false;
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              height: 500,
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
                  const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 36,
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
                    onPress: () {
                      String snackBarText = 'Login Successful.';
                      if (_passwordController.text.isEmpty ||
                          _usernameController.text.isEmpty) {
                        snackBarText = 'One of the fields is empty';
                      }
                      if (_passwordController.text.isEmpty &&
                          _usernameController.text.isEmpty) {
                        snackBarText = 'Both fields are empty.';
                      }
                      if (validLogin(_usernameController.text,
                              _passwordController.text) ==
                          false) {
                        snackBarText = 'Invalid username or password.';
                      }

                      final snackBar = SnackBar(
                        content: Text(snackBarText),
                        backgroundColor: (Colors.black),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      if (validLogin(
                          _usernameController.text, _passwordController.text)) {
                        context.read<UserProvider>().setCurrentUser(user);
                        Navigator.pushNamed(context, '/home');
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
    );
  }
}

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
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Container(
              height: 500,
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
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 36,
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
                      final user = User(
                        username: _usernameController.text,
                        password: _passwordController.text,
                        firstName: _fNameController.text,
                        lastName: _lNameController.text,
                      );
                      context.read<UserProvider>().add(user);
                      Navigator.of(context).pop();
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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 10),
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: CategoryListWidget(),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: TopicListWidget(),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.black,
        //   onPressed: () {
        //     displayAddDialog(context);
        //   },
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButton: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              icon: Icons.note_add,
              iconColor: Colors.white,
              title: "Add Topic",
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.blue,
              onPress: () {
                displayAddTopicDialog(context);
              },
            ),
            Bubble(
              icon: Icons.category,
              iconColor: Colors.white,
              title: "Add Category",
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.blue,
              onPress: () {
                displayAddCategoryDialog(context);
              },
            ),
          ],
          animation: _animation,
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),
          iconColor: Colors.blue,
          iconData: Icons.ac_unit,
          backGroundColor: Colors.white,
        ));
  }
}

class TopicPostScreen extends StatefulWidget {
  const TopicPostScreen({super.key});

  @override
  State<TopicPostScreen> createState() => _TopicPostScreenState();
}

class _TopicPostScreenState extends State<TopicPostScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}