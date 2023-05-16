import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/reply.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({super.key, required this.reply});

  final Reply reply;

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.select<UserProvider, User?>(
    //   (provider) => provider.user,
    // );
    final user = context.select<UserProvider, User?>((provider) {
      for (int i = 0; i < provider.userList.length; i++) {
        if (provider.userList.elementAt(i).userId == reply.userId) {
          return provider.userList.elementAt(i);
        }
      }
      return null;
    });
    return Container(
      decoration: BoxDecoration(border: Border(left: BorderSide(width: 2, color: user?.role == 'admin'
                                    ? Colors.blue : Theme.of(context).primaryColor))),
      child: Row(
        children: [
          // currentUser.userId == topic.userId
          //     ? Expanded(
          //         flex: 2,
          //         child: Checkbox(
          //           value: topic.helpStatus,
          //           onChanged: (value) {
          //             context.read<TopicProvider>().toggleHelpstatus(topic);
    
          //             // final snackBar = SnackBar(
          //             //   content: Text(topic.helpStatus
          //             //       ? 'Task completed'
          //             //       : 'Task marked incomplete'),
          //             //   backgroundColor: (Colors.black),
          //             // );
          //             // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //           },
          //         ),
          //       )
          //     : const SizedBox(
          //         width: 50,
          //       ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              Icons.account_circle_outlined,
              size: 50,
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: reply.username,
                      style: TextStyle(
                        fontSize: 14,
                        color: user?.role == 'admin'
                                    ? Colors.blue: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: ' on ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: DateFormat('MM/dd/yyyy - HH:mm')
                              .format(DateTime.parse(reply.dateCreated)),
                          style: TextStyle(color: user?.role == 'admin'
                                    ? Colors.blue: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                  reply.content.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            reply.content,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 19, 19, 19)),
                          ),
                        )
                      : const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
