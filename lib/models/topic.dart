
class Topic {
  final String topicId;
  String categoryId;
  String userId;
  String topicName;
  bool helpStatus;
  String content;
  String dateCreated;
  int numberOfComments;

  Topic({
    required this.topicId,
    required this.categoryId,
    required this.userId,
    required this.topicName,
    this.content = '',
    this.helpStatus = false,
    this.numberOfComments = 0,
    required this.dateCreated,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      categoryId: json['categoryId'],
      userId: json['userId'],
      topicName: json['topicName'],
      content: json['content'],
      helpStatus: json['helpStatus'],
      dateCreated: json['dateCreated'],
      numberOfComments: json['numberOfComments'],
    );
  }

  Map<String, dynamic> toJson() => {
        'topicId': topicId,
        'categoryId': categoryId,
        'userId': userId,
        'topicName': topicName,
        'content': content,
        'helpStatus': helpStatus,
        'dateCreated': dateCreated.toString(),
        'numberOfComments': numberOfComments,
      };

  @override
  bool operator ==(covariant Topic other) => topicId == other.topicId;

  @override
  int get hashCode => topicId.hashCode;
}
