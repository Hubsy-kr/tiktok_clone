import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/features/settings/setting_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_vm.dart';
import 'package:tiktok_clone/features/users/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/widgets/user_attract_info.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username, tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final TextEditingController _linkController = TextEditingController();
  bool isModifyMode = false;

  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _onLinkPressed() {
    setState(() {
      isModifyMode = true;
    });
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
    setState(() {
      isModifyMode = false;
    });
  }

  void _onPlusTap() async {
    await ref.read(usersProvider.notifier).onLinkUpdate(_linkController.text);

    setState(() {
      isModifyMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          data: (data) => GestureDetector(
            onTap: _onScaffoldTap,
            child: Scaffold(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              body: SafeArea(
                child: DefaultTabController(
                  initialIndex: widget.tab == 'posts' ? 0 : 1,
                  // TAB은 요게 필요함
                  length: 2,
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          title: Text(data.name),
                          centerTitle: true,
                          actions: [
                            IconButton(
                              onPressed: _onLinkPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.link,
                                size: Sizes.size20,
                              ),
                            ),
                            IconButton(
                              onPressed: _onGearPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.gear,
                                size: Sizes.size20,
                              ),
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Gaps.v20,
                              Avatar(
                                  name: data.name,
                                  uid: data.uid,
                                  hasAvatar: data.hasAvatar),
                              Gaps.v20,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '@${data.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Sizes.size18,
                                    ),
                                  ),
                                  Gaps.h5,
                                  FaIcon(
                                    FontAwesomeIcons.solidCircleCheck,
                                    size: Sizes.size16,
                                    color: Colors.blue.shade500,
                                  ),
                                ],
                              ),
                              Gaps.v24,
                              SizedBox(
                                height: Sizes.size48,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const UserAttractInfo(
                                      title: '97',
                                      subtitle: 'Following',
                                    ),
                                    VerticalDivider(
                                      width: Sizes.size32,
                                      thickness: Sizes.size1,
                                      color: Colors.grey.shade400,
                                      indent: Sizes.size14,
                                      endIndent: Sizes.size14,
                                    ),
                                    const UserAttractInfo(
                                      title: '10.5M',
                                      subtitle: 'Followers',
                                    ),
                                    VerticalDivider(
                                      width: Sizes.size32,
                                      thickness: Sizes.size1,
                                      color: Colors.grey.shade400,
                                      indent: Sizes.size14,
                                      endIndent: Sizes.size14,
                                    ),
                                    const UserAttractInfo(
                                      title: '149.3M',
                                      subtitle: 'Likes',
                                    ),
                                  ],
                                ),
                              ),
                              Gaps.v14,
                              FractionallySizedBox(
                                widthFactor: 0.33,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Sizes.size12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                        Sizes.size4,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Gaps.v14,
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.size32,
                                ),
                                child: Text(
                                  'All highlights and where to watch live matches on FIFA',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Gaps.v14,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.link,
                                    size: Sizes.size12,
                                  ),
                                  Gaps.h4,
                                  if (isModifyMode)
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: Sizes.size40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              Sizes.size96,
                                          child: TextField(
                                            controller: _linkController,
                                            expands: true,
                                            minLines: null,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintText: 'Modify link...',
                                              filled: true,
                                              fillColor: Colors.grey.shade300,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Sizes.size12,
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: Sizes.size16),
                                            ),
                                          ),
                                        ),
                                        Gaps.h12,
                                        GestureDetector(
                                          onTap: _onPlusTap,
                                          child: const FaIcon(
                                            FontAwesomeIcons.plus,
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      ref.watch(usersProvider).value!.link,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                              Gaps.v20,
                            ],
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: PersistentTabBar(),
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: Sizes.size2,
                            mainAxisSpacing: Sizes.size2,
                            childAspectRatio: 9 / 14,
                          ),
                          padding: EdgeInsets.zero,
                          itemCount: 20,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 9 / 14,
                                    child: FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder: 'assets/images/banana.jpg',
                                        image:
                                            'https://images.unsplash.com/photo-1648408685303-0aa75e78e0f7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=685&q=80'),
                                  ),
                                  const Positioned(
                                    top: 180,
                                    left: 3,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.play_arrow_outlined,
                                          color: Colors.white,
                                          size: Sizes.size20,
                                        ),
                                        Gaps.h3,
                                        Text(
                                          '4.1M',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Sizes.size14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Center(
                          child: Text(
                            '요건 페이지 투',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => Center(
              child: Text(
            error.toString(),
          )),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
  }
}
