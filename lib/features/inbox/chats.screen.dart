import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../constants/sizes.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  static const String routeName = 'chats';
  static const String routeUrl = '/chats';

  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _items = [];
  final Duration _duration = const Duration(
    milliseconds: 300,
  );

  void _addItem() {
    _key.currentState?.insertItem(
      _items.length,
      duration: _duration,
    );

    _items.add(_items.length);
  }

  void _deleteItem(int index) {
    _key.currentState?.removeItem(
      index,
      (context, animation) => Container(
        color: Colors.red,
        child: SizeTransition(
          sizeFactor: animation,
          child: _makeTile(index),
        ),
      ),
      duration: _duration,
    );

    _items.removeAt(index);
  }

  void _onChatTap(int index) {
    // context.push('$index'); 경로를 직접 정하거나 아래와같이 할수있음
    context.pushNamed(ChatDetailScreen.routeName, params: {'chatId': '$index'});
  }

  Widget _makeTile(int index) {
    return ListTile(
      onTap: () => _onChatTap(index),
      onLongPress: () => _deleteItem(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/46519875?v=4'),
        child: Text('JS'),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Jinsu ($index)',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '2:16 PM',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: const Text(
        'Hi, bro',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct messages'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size10,
        ),
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child:
                SizeTransition(sizeFactor: animation, child: _makeTile(index)),
          );
        },
      ),
    );
  }
}
