import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../models/categories.dart';
import '../models/comment.dart';
import '../models/reply.dart';
import '../models/topic.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

// class UserProvider extends ChangeNotifier {
//   final List<User> _userList = [
//     User(username: "admin", password: "admin", firstName: "admin", lastName: "admin", role: "admin", isActive: true, isStaff: true, isSuperuser: true),
//     User(username: "user", password: "user", firstName: "user", lastName: "user", isActive: true, isStaff: true, isSuperuser: true)
//   ];
//   late User  _currentUser;
//   User get currentUser => _currentUser;
//   List<User> get userList => _userList.where((e) => e.role == 'user').toList();
//   List<User> get adminList =>
//       _userList.where((e) => e.role == 'admin').toList();

//   void add(User user) {
//     _userList.add(user);
//     notifyListeners();
//   }

//   User setCurrentUser(User user) {
//     _currentUser = user;
//     notifyListeners();
//     return _currentUser;
//   }

//   void remove(User user) {
//     _userList.remove(user);
//     notifyListeners();
//   }
// }

class UserProvider extends ChangeNotifier {
  final List<User> _userList = [];
  List<User> get userList => _userList;
  User? _user;

  Future<void> fetchUserList() async {
    final url = Uri.parse('${Env.urlPrefix}/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _userList.clear();
      for (var userData in data) {
        final user = User.fromJson(userData);
        _userList.add(user);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch user list');
    }
  }

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

class CategoryProvider extends ChangeNotifier {
  final List<Category> _categoryList = [
    Category(categoryName: 'All', categoryId: 'categoryId', isClicked: true),
  ];
  bool activeCategory = false;
  late Category _currentCategory;
  Category get currentCategory => _currentCategory;
  List<Category> get categoryList => _categoryList;

  Future<void> fetchCategoryList() async {
    final url = Uri.parse('${Env.urlPrefix}/categories');
    final response = await http.get(url);
    final tcategory = Category(
        categoryName: 'All', categoryId: 'categoryId', isClicked: true);

    if (response.statusCode == 200) {
      _categoryList.clear();
      _categoryList.add(tcategory);
      toggleIsClicked(tcategory);
      final List<dynamic> data = json.decode(response.body);
      for (var categoryData in data) {
        final category = Category.fromJson(categoryData);
        _categoryList.add(category);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch category list');
    }
  }

  void setCurrentCategory(Category category) {
    _currentCategory = category;
    // toggleIsClicked(category);
    activeCategory = true;
    notifyListeners();
  }

  void setActiveCategoryFalse() {
    activeCategory = false;
    // categoryList.where((element) => element.,);
    notifyListeners();
  }

  void remove(Category category) {
    _categoryList.remove(category);
    notifyListeners();
  }

  Future<void> toggleIsClicked(Category category) async {
    category.isClicked = true;
    // final url =
    //     Uri.parse('${Env.urlPrefix}/categories/${category.categoryId}/');
    // final response = await http.put(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(category.toJson()),
    // );

    _categoryList
        .where((element) => element.categoryId != category.categoryId)
        .forEach((element) => element.isClicked = false);

    // if (response.statusCode == 200) {
    //   notifyListeners();
    // } else {
    //   throw Exception('Failed to toggle isClicked');
    // }
  }
}

class TopicProvider extends ChangeNotifier {
  final List<Topic> _topicList = [];
  Topic? _topic;
  Topic? get topic => _topic;
  bool activeComment = false;
  List<Topic> get topicList => _topicList;
  List<Topic> filteredTopics = [];

  void setTopic(Topic topic) {
    _topic = topic;
    notifyListeners();
  }

  Future<void> updateTopicCommentsCount(
      String topicId, BuildContext context) async {
    final url =
        Uri.parse('http://${Env.urlPrefix}/update-topic-comments-count/');
    final response = await http.post(
      url,
      body: {'topic_id': topicId.toString()},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 && responseData['success']) {
      notifyListeners();
    } else {
      // Handle error.
    }
  }

  Future<void> fetchTopicList() async {
    final url = Uri.parse('${Env.urlPrefix}/topics');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _topicList.clear();
      for (var topicData in data) {
        final topic = Topic.fromJson(topicData);
        _topicList.add(topic);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch topic list');
    }
  }

  Future<void> toggleHelpstatus(Topic topic) async {
    topic.helpStatus = !topic.helpStatus;
    final url = Uri.parse('${Env.urlPrefix}/topics/${topic.topicId}/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(topic.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to toggle help status');
    }
  }

  Future<void> updateNumberOfComments(Topic topic, String option) async {
    if (option == 'add') {
      topic.numberOfComments = topic.numberOfComments + 1;
    }
    if (option == 'decrease') {
      topic.numberOfComments = topic.numberOfComments - 1;
    }
    final url = Uri.parse('${Env.urlPrefix}/topics/${topic.topicId}/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(topic.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to update number of comments');
    }
  }

  Future<void> update(Topic topic) async {
    final url = Uri.parse('${Env.urlPrefix}/topics/${topic.topicId}/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(topic.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to toggle help status');
    }
  }

  // void setTopicList(List<Topic> list){
  //   _topicList = list;
  // }

  Future<void> remove(Topic topic) async {
    _topicList.remove(topic);

    final url = Uri.parse('${Env.urlPrefix}/topics/${topic.topicId}/');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(topic.toJson()),
    );

    if (response.statusCode == 204) {
      notifyListeners();
    } else {
      throw Exception('Failed to delete');
    }
    notifyListeners();
  }

  void searchTopics(String keyword) {
    filteredTopics = _topicList
        .where((topic) =>
            topic.topicName.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    notifyListeners();
  }
}

class CommentProvider extends ChangeNotifier {
  final List<Comment> _commentList = [];
  List<Comment> get commentList => _commentList;

  Future<void> fetchCommentList() async {
    final url = Uri.parse('${Env.urlPrefix}/comments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _commentList.clear();
      for (var commentData in data) {
        final comment = Comment.fromJson(commentData);
        _commentList.add(comment);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch comment list');
    }
  }

  Future<void> toggleShowReply(Comment comment) async {
    comment.showReply = !comment.showReply;
    final url = Uri.parse('${Env.urlPrefix}/comments/${comment.commentId}/');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed to toggle show reply');
    }
  }

  Future<void> remove(Comment comment) async {
    _commentList.remove(comment);

    final url = Uri.parse('${Env.urlPrefix}/comments/${comment.commentId}/');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(comment.toJson()),
    );

    if (response.statusCode == 204) {
      notifyListeners();
    } else {
      throw Exception('Failed to delete');
    }
    notifyListeners();
  }

  void add(Comment comment) {
    _commentList.add(comment);
    notifyListeners();
  }


  bool toggleReplies(Comment comment) {
    comment.showReply = !comment.showReply;
    notifyListeners();
    return comment.showReply;
  }

  // void remove(Comment comment) {
  //   _commentList.remove(comment);
  //   notifyListeners();
  // }
}

class ReplyProvider extends ChangeNotifier {
  final List<Reply> _replyList = [];
  List<Reply> get replyList => _replyList;

  void add(Reply comment) {
    _replyList.add(comment);
    notifyListeners();
  }

  Future<void> fetchReplyList() async {
    final url = Uri.parse('${Env.urlPrefix}/replies');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _replyList.clear();
      for (var replyData in data) {
        final reply = Reply.fromJson(replyData);
        _replyList.add(reply);
      }
      notifyListeners();
    } else {
      throw Exception('Failed to fetch comment list');
    }
  }

  Future<void> remove(Reply reply) async {
    _replyList.remove(reply);

    final url = Uri.parse('${Env.urlPrefix}/replies/${reply.replyId}/');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reply.toJson()),
    );

    if (response.statusCode == 204) {
      notifyListeners();
    } else {
      throw Exception('Failed to delete');
    }
    notifyListeners();
  }
}
