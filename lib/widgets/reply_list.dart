import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:helpdesk_app/widgets/reply_card.dart';
import 'package:provider/provider.dart';

import '../models/comment.dart';

class ReplyListWidget extends StatelessWidget {
  const ReplyListWidget({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReplyProvider>();
    final replyList = provider.replyList
        .where((reply) => reply.commentId == comment.commentId)
        .toList();

    return replyList.isEmpty
        ? Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'No replies',
                style: TextStyle(fontSize: 15),
              ),
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: replyList.length,
            itemBuilder: (context, index) {
              final reply = replyList[index];
              return ReplyCard(
                reply: reply,
              );
            },
          );
  }
}
