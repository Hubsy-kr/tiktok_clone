import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

import '../../constants/gaps.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _username = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _username = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    // 위젯을 날렸을때 dispose하지 않으면 앱이 충돌남(메모리에 계속 남음)
    _emailController.dispose();

    // 생명주기에 따라 다른것들을 모두 정리하고 마지막에 super.dispose 호출. 설득력있어보이는 코드.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign up',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "What is your email?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _emailController,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                hintText: 'Email',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            Gaps.v28,
            FormButton(
              disabled: _username.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
