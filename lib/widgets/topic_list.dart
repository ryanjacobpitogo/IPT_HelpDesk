import 'package:flutter/material.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'custom_card.dart';

class TopicListWidget extends StatelessWidget {
  const TopicListWidget({super.key, required this.isAccount});

  final bool isAccount;

  @override
  Widget build(BuildContext context) {
    final cProvider = context.watch<CategoryProvider>();
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );
    final provider = context.watch<TopicProvider>();
    final topicList = isAccount ? provider.topicList
            .where((e) => currentUser?.userId == e.userId)
            .toList()
            : (provider.filteredTopics.isEmpty ?  (cProvider.activeCategory
        ? provider.topicList
            .where((e) => cProvider.currentCategory.categoryId == e.categoryId && cProvider.currentCategory.categoryName != 'All')
            .toList()
        : provider.topicList) : provider.filteredTopics);

    return topicList.isEmpty
        ? const Center(
            child: Text(
              'NO ENTRIES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => Container(height: 8),
            itemCount: topicList.length,
            itemBuilder: (context, index) {
              final topic = topicList[index];
              return TopicCardWidget(topic: topic);
            },
          );
  }
}
