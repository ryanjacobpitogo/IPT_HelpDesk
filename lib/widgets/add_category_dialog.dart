import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/categories.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../providers/user_provider.dart';

Future<dynamic> displayAddCategoryDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AddCategoryDialog();
    },
  );
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController _categoryNameController;

  @override
  void initState() {
    _categoryNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _categoryNameController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uProvider = Provider.of<UserProvider>(context);
    final currentUser = uProvider.user;

    return AlertDialog(
      title: Text(
        'Add new category',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 1,
            controller: _categoryNameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Category Name',
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                final categoryName = _categoryNameController.text;
                final categoryId = const Uuid().v4();
                if (categoryName.isNotEmpty) {
                  final category = Category(
                    categoryId: categoryId,
                    adminId: currentUser!.userId,
                    categoryName: categoryName,
                    isClicked: false,
                  );
                  Map<String, String> headers = {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                  };
                  String url = '${Env.urlPrefix}/category/add';
                   http.post(Uri.parse(url),
                          headers: headers, body: jsonEncode(category.toJson()));
                  context.read<CategoryProvider>().fetchCategoryList();
                  SnackBarService.showSnackBar(content: 'Category \'$categoryName\' created');
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