
class Category {
  final String categoryId;
  String? adminId;
  final String categoryName;
  bool isClicked;

  Category({
    required this.categoryName,
    required this.categoryId,
    this.isClicked = false,
    this.adminId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      adminId: json['adminId'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'adminId': adminId,
        'categoryName': categoryName,
      };

  @override
  bool operator ==(covariant Category other) => categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}
