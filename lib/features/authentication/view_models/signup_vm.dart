import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repo.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepository);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    // await _authRepository.signUp(form['email'], form['password']);
    // state =
    //     const AsyncValue.data(null); // 로딩상태를 없애. 아무것도 expose하고 있지 않으니까 null.

    state = await AsyncValue.guard(() async =>
        await _authRepository.signUp(form['email'], form['password']));
  }
}

final signUpForm = StateProvider((ref) => {});
final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
