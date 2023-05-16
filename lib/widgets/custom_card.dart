import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:helpdesk_app/models/topic.dart';
import 'package:helpdesk_app/widgets/add_topic_dialog.dart';
import 'package:helpdesk_app/pages/detailspage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;

class TopicCardWidget extends StatelessWidget {
  const TopicCardWidget({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: TopicCard(topic: topic),
    );
  }
}

class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );
    final username = context.select<UserProvider, String>((provider) {
      for (int i = 0; i < provider.userList.length; i++) {
        if (provider.userList.elementAt(i).userId == topic.userId) {
          return provider.userList.elementAt(i).username;
        }
      }
      return '';
    });
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
            blurRadius: 2,
            spreadRadius: 2
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          enabled: currentUser!.userId == topic.userId ? true : false,
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  displayUpdateTopicDialog(context, topic);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                icon: Icons.edit,
                label: 'Edit',
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  context.read<TopicProvider>().remove(topic);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: GestureDetector(
            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => EditTopicPage(topic: topic),
            //   ),
            // ),
            onTap: () {
              context.read<TopicProvider>().setTopic(topic);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopicDetails(username: username,)),
              );
            },
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 100),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: PhysicalModel(
                          color: topic.helpStatus
                          ? Theme.of(context).primaryColor
                          : const Color.fromARGB(255, 200, 199, 199),
                          child: StatusBox(topic: topic)),
                      ),
                      // : const SizedBox(),
                      const Expanded(
                        flex: 3,
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: 50,
                        ),
                      ),
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
                      TopicDetailsRow(
                          topic: topic,
                          currentUser: currentUser,
                          username: username)
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

class TopicDetailsRow extends StatelessWidget {
  const TopicDetailsRow({
    super.key,
    required this.topic,
    required this.currentUser,
    required this.username,
  });

  final Topic topic;
  final User currentUser;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.question_answer,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Flexible(
                      child: Text(
                        topic.topicName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const Spacer(),
                currentUser.userId == topic.userId ? Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        if (currentUser.userId == topic.userId) {
                          context.read<TopicProvider>().toggleHelpstatus(topic);
                          context.read<TopicProvider>().fetchTopicList();
                        }
                      },
                      child: topic.helpStatus
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                          : const Icon(Icons.check),
                    ),
                  ),
                ) : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                badges.Badge(
                  badgeContent: Text(
                    '${topic.numberOfComments}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  badgeStyle: badges.BadgeStyle(
                      badgeColor: Theme.of(context).primaryColor),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.comment,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Text(
            //   "by $username on ${DateFormat('MM-dd-yyyy HH:mm').format(topic.dateCreated)}",
            //   style: TextStyle(
            //       fontWeight: FontWeight.w600,
            //       fontSize: 18,
            //       color: Theme.of(context).primaryColor),
            // ),
            RichText(
              text: TextSpan(
                text: 'by ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: username,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  const TextSpan(
                    text: ' on ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('MM/dd/yyyy - HH:mm')
                        .format(DateTime.parse(topic.dateCreated)),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            topic.content.isNotEmpty
                ? Text(
                    overflow: TextOverflow.ellipsis,
                    topic.content,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 19, 19, 19)),
                  )
                : const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  const StatusBox({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return Expanded(
          flex: 1,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              
              decoration: BoxDecoration(
                  color: topic.helpStatus
                      ? Theme.of(context).primaryColor
                      : const Color.fromARGB(255, 200, 199, 199)),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: topic.helpStatus ? 'SOLVED' : 'UNSOLVED',
                    style: TextStyle(
                      color: topic.helpStatus ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
