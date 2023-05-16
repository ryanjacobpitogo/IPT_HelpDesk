import 'package:flutter/material.dart';
import 'package:helpdesk_app/pages/homepage.dart';
import 'package:helpdesk_app/pages/loginpage.dart';
import 'package:helpdesk_app/pages/registerpage.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Env {
  static String urlPrefix = "http://10.0.2.2:8000";
}

List<IconData> iconList = [
  Icons.home,
  Icons.account_box,
];

String snackBarText = 'Login Successful.';

class SnackBarService {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({required String content}) {
    final snackBar = SnackBar(
      content: Text(content),
      backgroundColor: Colors.blue,
      // Add Snackbar.Callback to handle events
      behavior: SnackBarBehavior.floating,
      onVisible: () {
        // Handle onShown event here
      },
    );

    scaffoldKey.currentState?.showSnackBar(snackBar);
  }
}


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => ReplyProvider()),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: SnackBarService.scaffoldKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
          primaryColor: const Color.fromARGB(255, 119, 7, 255),
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
        routes: {
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    ),
  );
}






// class TopicPostScreen extends StatefulWidget {
//   const TopicPostScreen({super.key});

//   @override
//   State<TopicPostScreen> createState() => _TopicPostScreenState();
// }

// class _TopicPostScreenState extends State<TopicPostScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
