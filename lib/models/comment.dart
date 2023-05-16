// ignore: unused_import
import 'package:uuid/uuid.dart';

class Comment {
  final String commentId;
  String topicId;
  String userId;
  String username;
  bool isMostHelpful;
  bool showReply;
  String content;
  String dateCreated;
  int replyCount;

  Comment({
    required this.commentId,
    required this.topicId,
    required this.userId,
    this.username = '',
    this.content = '',
    this.isMostHelpful = false,
    this.showReply = false,
    this.replyCount = 0,
    required this.dateCreated,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      topicId: json['topicId'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      isMostHelpful: json['isMostHelpful'],
      showReply: json['showReply'],
      dateCreated: json['dateCreated'],
      replyCount: json['replyCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'topicId': topicId,
        'userId': userId,
        'username': username,
        'content': content,
        'isMostHelpful': isMostHelpful,
        'showReply': showReply,
        'dateCreated': dateCreated.toString(),
        'replyCount': replyCount,
      };

  @override
  bool operator ==(covariant Comment other) => commentId == other.commentId;

  @override
  int get hashCode => commentId.hashCode;
}
