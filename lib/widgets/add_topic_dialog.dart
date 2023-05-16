import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/topic.dart';
import '../providers/user_provider.dart';

Future<dynamic> displayAddTopicDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddTopicDialog(option: 'add',);
    },
  );
}

Future<dynamic> displayUpdateTopicDialog(BuildContext context, Topic topic) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddTopicDialog(option: 'update', topic: topic,);
    },
  );
}

// ignore: must_be_immutable
class AddTopicDialog extends StatefulWidget {
  AddTopicDialog({super.key, required this.option, this.topic});
  final String option;
  Topic? topic;

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicContentController = TextEditingController();
  final TextEditingController _topicCategoryController =
      TextEditingController();

  @override
  // void initState() {
  //   _topicNameController = TextEditingController();
  //   _topicContentController = TextEditingController();
  //   _topicCategoryController = TextEditingController();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _topicNameController = TextEditingController();
  //   _topicContentController = TextEditingController();
  //   _topicCategoryController = TextEditingController();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context);
    final cProvider = Provider.of<CategoryProvider>(context);
    final currentUser = uProvider.user;

    void addTopic() {
      final topicName = _topicNameController.text;
      final topicContent = _topicContentController.text;
      String categoryId = '';

      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (_topicCategoryController.text ==
            cProvider.categoryList[i].categoryName) {
          categoryId = cProvider.categoryList[i].categoryId;
        }
      }
      if (topicName.isNotEmpty) {
        final topicId = const Uuid().v4();
        final userId = currentUser!.userId;
        final topic = Topic(
            topicId: topicId,
            categoryId: categoryId,
            topicName: topicName,
            userId: userId,
            content: topicContent,
            helpStatus: false,
            numberOfComments: 0,
            dateCreated: DateTime.now().toString());
        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };

        String url = '${Env.urlPrefix}/topic/add';
        http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(topic.toJson()));
        context.read<TopicProvider>().fetchTopicList();
        Navigator.of(context).pop();
      }
    }

    void updateTopic() {
      final topicName = _topicNameController.text;
      final topicContent = _topicContentController.text;
      String categoryId = '';

      for (int i = 0; i < cProvider.categoryList.length; i++) {
        if (_topicCategoryController.text ==
            cProvider.categoryList[i].categoryName) {
          categoryId = cProvider.categoryList[i].categoryId;
        }
      }
      if (topicName.isNotEmpty) {
        final userId = currentUser!.userId;
        final topic = Topic(
            topicId: widget.topic!.topicId,
            categoryId: categoryId,
            topicName: topicName,
            userId: userId,
            content: topicContent,
            helpStatus: false,
            numberOfComments: 0,
            dateCreated: DateTime.now().toString());
        context.read<TopicProvider>().update(topic);
        context.read<TopicProvider>().fetchTopicList();
        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: Text(
        widget.option == 'add' ?
        'Add new topic' : 'Update ${'"'}${widget.topic!.topicName}${'"'}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 109, 22, 164),
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            controller: _topicNameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Topic Title',
            ),
          ),
          TextField(
            maxLines: 1,
            controller: _topicCategoryController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Category',
            ),
          ),
          TextField(
            maxLines: 3,
            controller: _topicContentController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Problem Description',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color.fromARGB(255, 109, 22, 164),
              ),
              onPressed: widget.option == 'add' ? addTopic : updateTopic,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
