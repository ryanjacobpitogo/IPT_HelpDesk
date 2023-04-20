import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/categories.dart';
import 'package:provider/provider.dart';

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
    final currentUser = uProvider.currentUser;

    return AlertDialog(
      title: const Text(
        'Add new category',
        style: TextStyle(
          fontWeight: FontWeight.bold,
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
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                final categoryName = _categoryNameController.text;

                if (categoryName.isNotEmpty) {
                  final category = Category(
                    adminId: currentUser.userId,
                    categoryName: categoryName,
                  );
                  context.read<CategoryProvider>().add(category);
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