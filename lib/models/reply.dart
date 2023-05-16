
class Reply {
  final String replyId;
  String commentId;
  String userId;
  String username;
  String content;
  String dateCreated;

  Reply({
    required this.replyId,
    required this.commentId,
    required this.userId,
    this.username = '',
    this.content = '',
    required this.dateCreated,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      replyId: json['replyId'],
      commentId: json['commentId'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      dateCreated: json['dateCreated'],
    );
  }

  Map<String, dynamic> toJson() => {
        'replyId': replyId,
        'commentId': commentId,
        'userId': userId,
        'username': username,
        'content': content,
        'dateCreated': dateCreated.toString(),
      };
  

  @override
  bool operator ==(covariant Reply other) => replyId == other.replyId;

  @override
  int get hashCode => replyId.hashCode;
}