import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/comment.dart';
import 'package:helpdesk_app/widgets/comment_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/topic.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../providers/user_provider.dart';

// ignore: must_be_immutable
class TopicDetails extends StatelessWidget {
  TopicDetails({super.key, required this.username});

  String username;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );
    final currentTopic = context.select<TopicProvider, Topic?>(
      (provider) => provider.topic,
    );
    context.watch<TopicProvider>();

    void addComment() {
      final commentId = const Uuid().v4();
      final comment = Comment(
          commentId: commentId,
          topicId: currentTopic!.topicId,
          userId: currentUser!.userId,
          username: currentUser.username,
          content: controller.text,
          dateCreated: DateTime.now().toString());

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      String url = '${Env.urlPrefix}/comment/add';
      http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(comment.toJson()));
      context.read<TopicProvider>().fetchTopicList();
      context.read<CommentProvider>().fetchCommentList();
    }

    void toggleHelpstatus() {
      if (currentUser!.userId == currentTopic!.userId) {
        context.read<TopicProvider>().toggleHelpstatus(currentTopic);
      }
    }

    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // backgroundColor: Color(0xFF1B0130),
        backgroundColor: currentTopic!.helpStatus
                    ? Theme.of(context).primaryColor : const Color.fromARGB(255, 200, 199, 199),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: currentTopic.helpStatus
                    ? Theme.of(context).primaryColor : const Color.fromARGB(255, 200, 199, 199),
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Row(
                  children: [
                    currentTopic.helpStatus ? Image.asset(
                      'images/logo-no-background-white.png',
                      width: 240,
                    ): Image.asset(
                      'images/logo-no-background-black.png',
                      width: 240,
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: (() => {Navigator.pop(context)}),
                        child: currentTopic.helpStatus ? const Icon(Icons.logout_outlined) : const Icon(Icons.logout_outlined, color: Colors.black,)),
                    // CustomButton(title: "LOGOUT", fColor: Colors.white, bColor: const Color(0xFF1B0130), onPress: ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: currentTopic.helpStatus
                                    ? Theme.of(context).primaryColor
                                    : const Color.fromARGB(255, 200, 199, 199),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    currentTopic.helpStatus ? 'SOLVED' : 'UNSOLVED',
                                    style: TextStyle(
                                        color: currentTopic.helpStatus
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(color: Colors.white),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Expanded(
                                                flex: 1,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Icon(
                                                    Icons.question_answer,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Expanded(
                                                flex: 9,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    currentTopic.topicName,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 22,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
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
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                const TextSpan(
                                                  text: ' on ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: DateFormat(
                                                          'MM/dd/yyyy - HH:mm')
                                                      .format(DateTime.parse(
                                                          currentTopic
                                                              .dateCreated)),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          currentTopic.content.isNotEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15.0, right: 15),
                                                  child: Text(
                                                    currentTopic.content,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 19, 19, 19)),
                                                  ),
                                                )
                                              : const SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: CommentListWidget(topic: currentTopic),
                            ),
                            // const Divider(
                            //   color: Color.fromARGB(255, 200, 199, 199),
                            //   thickness: 2,
                            // ),
                            Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12),
                                    child: TextField(
                                      textAlign: TextAlign.start,
                                      autofocus: false,
                                      controller: controller,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        labelText: "Comment",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TopicDetailButton(
                                          topic: currentTopic,
                                          text1: 'COMMENT',
                                          text2: 'COMMENT',
                                          changeColor: false,
                                          onTap: () {
                                            if (controller.text.isNotEmpty) {
                                              addComment();
                                            }
                                          },
                                        ),
                                      ),
                                      currentUser?.userId == currentTopic.userId ? Expanded(
                                        child: TopicDetailButton(
                                          topic: currentTopic,
                                          text1: 'MARK UNSOLVED',
                                          text2: 'MARK SOLVED',
                                          changeColor: true,
                                          onTap: toggleHelpstatus,
                                        ),
                                      ) : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopicDetailButton extends StatelessWidget {
  const TopicDetailButton({
    super.key,
    required this.topic,
    required this.text1,
    required this.text2,
    this.onTap,
    this.changeColor,
  });

  final Topic topic;
  final String text1;
  final String text2;
  // ignore: prefer_typing_uninitialized_variables
  final changeColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: changeColor
                ? (topic.helpStatus
                    ? Theme.of(context).primaryColor : const Color.fromARGB(255, 200, 199, 199)
                    )
                : Theme.of(context).primaryColor,
            elevation: 5),
        child: SizedBox(
          height: 30,
          width: double.infinity,
          child: Center(
            child: FittedBox(
              child: Text(
                topic.helpStatus ? text1 : text2,
                style: TextStyle(
                    color: changeColor
                        ? (topic.helpStatus ?  Colors.white : Colors.black )
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
