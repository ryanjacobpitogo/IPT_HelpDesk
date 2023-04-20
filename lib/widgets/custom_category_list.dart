import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final categoryList = provider.categoryList;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.read<CategoryProvider>().setActiveCategoryFalse();
            },
            child: Container(
              width: 100,
              height: 30,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'All',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          categoryList.isEmpty
              ? const SizedBox(
                  width: 1,
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      // padding: const EdgeInsets.all(16),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 15,
                      ),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categoryList[index];
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<CategoryProvider>()
                                .setCurrentCategory(category);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              category.categoryName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
