import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryProvider>();
    final categoryList = provider.categoryList;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        categoryList.isEmpty
            ? const SizedBox(
                width: 1,
              )
            : Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
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
                      return Container(
                        width: 100,
                        height: 30,
                        padding: const EdgeInsets.symmetric(vertical:5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: category.isClicked ? const Color(0xFF1B0130) : Theme.of(context).primaryColor ,
                              elevation: 3,
                            ),
                          onPressed: () {
                            if (category.categoryName != 'All') {
                              context
                                  .read<CategoryProvider>()
                                  .setCurrentCategory(category);
                              context.read<CategoryProvider>().toggleIsClicked(category);
                            } else {
                              context
                                  .read<CategoryProvider>()
                                  .setActiveCategoryFalse();

                              context.read<CategoryProvider>().toggleIsClicked(category);
                            }
                            
                          },
                          child: FittedBox(
                            child: Text(
                              category.categoryName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
