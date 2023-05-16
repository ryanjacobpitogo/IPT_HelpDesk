import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:helpdesk_app/widgets/comments_card.dart';
import 'package:provider/provider.dart';

import '../models/topic.dart';

class CommentListWidget extends StatelessWidget {
  const CommentListWidget({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommentProvider>();
    final commentList = provider.commentList.where((comment) => comment.topicId == topic.topicId).toList();

    return commentList.isEmpty
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              child:  Text(
                'NO COMMENTS',
                style: TextStyle(color: topic.helpStatus ? Colors.white : Colors.black,  fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : ListView.separated(
            // shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 15),
            itemCount: commentList.length,
            itemBuilder: (context, index) {
              final comment = commentList[index];
              return CommentCard(comment: comment);
            },
          );
  }
}
