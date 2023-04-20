import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/topic.dart';
import '../providers/user_provider.dart';

Future<dynamic> displayAddTopicDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddTopicDialog();
    },
  );
}

class AddTopicDialog extends StatefulWidget {
  const AddTopicDialog({super.key});

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  late final TextEditingController _topicNameController;
  late final TextEditingController _topicContentController;
  late final TextEditingController _topicCategoryController;

  @override
  void initState() {
    _topicNameController = TextEditingController();
    _topicContentController = TextEditingController();
    _topicCategoryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _topicNameController = TextEditingController();
    _topicContentController = TextEditingController();
    _topicCategoryController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context);
    final cProvider = Provider.of<CategoryProvider>(context);
    final currentUser = uProvider.currentUser;

    return AlertDialog(
      title: const Text(
        'Add new topic',
        style: TextStyle(
          fontWeight: FontWeight.bold,
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
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                final topicName = _topicNameController.text;
                final topicContent = _topicContentController.text;
                String topicId = '';

                for (int i = 0; i < cProvider.categoryList.length; i++) {
                  if (_topicCategoryController.text ==
                      cProvider.categoryList[i].categoryName) {
                    topicId = cProvider.categoryList[i].categoryId;
                  }
                }

                if (topicName.isNotEmpty) {
                  final topic = Topic(
                      categoryId: topicId,
                      topicName: topicName,
                      userId: currentUser.userId,
                      content: topicContent,
                      dateCreated: DateTime.now());
                  context.read<TopicProvider>().add(topic);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}