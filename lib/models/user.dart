// ignore_for_file: non_constant_identifier_names


class User {
  final String userId;
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  String role;
  final bool is_active;
  final bool is_staff;
  final bool is_superuser;

  User(
      {required this.userId,
      required this.username,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.is_active,
      required this.is_staff,
      required this.is_superuser,
      this.role = 'user'});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      is_active: json['is_active'],
      is_staff: json['is_staff'],
      is_superuser: json['is_superuser'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'is_active': is_active,
        'is_staff': is_staff,
        'is_superuser': is_superuser,
      };

  // static Future<User> login(String username, String password) async {
  //   final url = Uri.parse('${Env.urlPrefix}/login/');
  //   final response = await http.post(
  //     url,
  //     body: {
  //       'username': username,
  //       'password': password,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final decodedResponse = json.decode(response.body);
  //     // final token = decodedResponse['token'];
  //     final accountJson = decodedResponse['account'];

  //     // Save the token to shared preferenc es for later use
  //     // ...

  //     return User.fromJson(accountJson);
  //   } else {
  //     throw Exception('Failed to login');
  //   }
  // }

  @override
  bool operator ==(covariant User other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
