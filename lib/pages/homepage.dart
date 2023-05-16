import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:helpdesk_app/providers/user_provider.dart';
import 'package:helpdesk_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/user.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_topic_dialog.dart';
import '../widgets/custom_category_list.dart';
import '../widgets/topic_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
      int bottomNavIndex = 0;
  // late Animation<double> _animation;
  // late AnimationController _animationController;
  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  // late Animation<double> fabAnimation;
  // late Animation<double> borderRadiusAnimation;
  // late CurvedAnimation fabCurve;
  // late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;

  // @override
  // void initState() {
  //   super.initState();

  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 260),
  //   );

  //   final curvedAnimation =
  //       CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
  //   _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

  //   _fabAnimationController = AnimationController(
  //     duration: Duration(milliseconds: 500),
  //     vsync: this,
  //   );
  //   _borderRadiusAnimationController = AnimationController(
  //     duration: Duration(milliseconds: 500),
  //     vsync: this,
  //   );
  //   fabCurve = CurvedAnimation(
  //     parent: _fabAnimationController,
  //     curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  //   );
  //   borderRadiusCurve = CurvedAnimation(
  //     parent: _borderRadiusAnimationController,
  //     curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  //   );

  //   fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
  //   borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
  //     borderRadiusCurve,
  //   );

  //   _hideBottomBarAnimationController = AnimationController(
  //     duration: Duration(milliseconds: 200),
  //     vsync: this,
  //   );

  //   Future.delayed(
  //     Duration(seconds: 1),
  //     () => _fabAnimationController.forward(),
  //   );
  //   Future.delayed(
  //     Duration(seconds: 1),
  //     () => _borderRadiusAnimationController.forward(),
  //   );
  // }

  // @override
  // // void initState() {
  // //
  // // }

  @override
  Widget build(BuildContext context) {
    final text = ['Home', 'Account'];
    final currentUser = context.select<UserProvider, User?>(
      (provider) => provider.user,
    );
    context.watch<TopicProvider>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1B0130),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor:const Color(0xFF1B0130),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Row(
                  children: [
                    Image.asset('images/logo-no-background-white.png', width: 240,),
                    const Spacer(),
                    // CustomButton(title: "LOGOUT", fColor: Colors.white, bColor: const Color(0xFF1B0130), onPress: (() => {Navigator.pop(context)})),
                  ],
                ),
              ),
              pinned: true,
              expandedHeight: 235,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  margin: const EdgeInsets.only(top: 75.0),
                  child: CustomHeader(user: currentUser),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: bottomNavIndex == 0 ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 15, right: 15, bottom: 10),
                      child: SizedBox(
                        height: 38,
                        width: double.infinity,
                        child: CategoryListWidget(),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                          color: Color(0xFF1B0130),
                        ),
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: const TopicListWidget(isAccount: false,),
                      ),
                    ),
                  ],
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 15, right: 15, bottom: 10),
                      child: SizedBox(
                        height: 38,
                        width: double.infinity,
                        child: Text(
                              'Your Topics',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900, fontSize: 26),
                            ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                          color: Color(0xFF1B0130),
                        ),
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child:  const TopicListWidget(isAccount: true,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          height: 60,
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            const color = Colors.white;

            return
                Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: isActive ? const Color(0xFF1B0130) : Colors.white,
                ),
                const SizedBox(height: 4),
                PhysicalModel(
                  color: isActive ? const Color(0xFF1B0130) : Colors.transparent,
                  shadowColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      text[index],
                      maxLines: 1,
                      style: const TextStyle(color: color),
                    ),
                  ),
                )
              ],
            );
          },
          backgroundGradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ]),
          splashColor: Colors.white,
          splashSpeedInMilliseconds: 300,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          gapLocation: GapLocation.center,
          notchMargin: 5,
          notchSmoothness: NotchSmoothness.defaultEdge,
          activeIndex: bottomNavIndex,
          onTap: (index) => setState(() => bottomNavIndex = index),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
          ),
          child: SizedBox(
            width: 60,
            height: 60,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.white.withOpacity(0.2),
                child: GestureDetector(
                  onTap: currentUser!.is_superuser
                      ? () => displayAddCategoryDialog(context)
                      : () => displayAddTopicDialog(context,),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B0130),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 0),
                            color: Theme.of(context).primaryColor,
                            blurRadius: 2,
                            spreadRadius: 2,
                          ),
                        ],
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Colors.blue,
                            ],
                          ),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),

          // floatingActionButton: FloatingActionBubble(
          //   items: <Bubble>[
          //     if (currentUser!.is_superuser == false)
          //     Bubble(
          //       icon: Icons.note_add,
          //       iconColor: Colors.white,
          //       title: "Add Topic",
          //       titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          //       bubbleColor: Colors.blue,
          //       onPress: () {
          //         displayAddTopicDialog(context);
          //       },
          //     ),
          //     if (currentUser.is_superuser)
          //       Bubble(
          //         icon: Icons.category,
          //         iconColor: Colors.white,
          //         title: "Add Category",
          //         titleStyle:
          //             const TextStyle(fontSize: 16, color: Colors.white),
          //         bubbleColor: Colors.blue,
          //         onPress: () {
          //           displayAddCategoryDialog(context);
          //         },
          //       ),
          //   ],
          //   animation: _animation,
          //   onPress: () => _animationController.isCompleted
          //       ? _animationController.reverse()
          //       : _animationController.forward(),
          //   iconColor: Colors.white,
          //   iconData: Icons.add,
          //   backGroundColor:Theme.of(context).primaryColor,
          // )
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomHeader extends StatelessWidget {
  CustomHeader({
    super.key,
    required this.user
  });

  User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 150,
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.only(
              left: 20,
              right: 10,
              bottom: 24 + 20,
            ),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1B0130),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Welcome ',
                          style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,
                               fontSize: 20),
                        ),
                        FittedBox(
                          child: SizedBox(
                            height: 55,
                            child: Text(
                              '${user!.lastName}, ${user!.firstName}',
                              style: TextStyle(
                                  color: user?.role == 'admin' ? Colors.blue : Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900, fontSize: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(flex: 4, child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(title: "LOGOUT", fColor: Colors.white, bColor: Theme.of(context).primaryColor, onPress: (() => {Navigator.pop(context)})),
                  ],
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 20, right: 20,),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 30,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        context.read<TopicProvider>().searchTopics(value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // surffix isn't working properly  with SVG
                        // thats why we use row
                        // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                      ),
                    ),
                  ),
                  const Icon(Icons.search_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// var currentList = context.watch<TopicProvider>().topicList;
//                         final suggestions = currentList.where((topic) {
//                           final topicTitle = topic.topicName;
//                           return topicTitle.contains(value);
//                         }).toList();
//                         context.read<TopicProvider>().;