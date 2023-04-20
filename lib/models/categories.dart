import 'package:uuid/uuid.dart';

class Category {
  final String categoryId;
  String? adminId;
  String categoryName;

  Category({
    required this.categoryName,
    this.adminId,
  }) : categoryId = const Uuid().v4();

  @override
  bool operator ==(covariant Category other) => categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}
