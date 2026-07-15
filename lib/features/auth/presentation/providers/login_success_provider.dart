import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_success_provider.g.dart';

@riverpod
class LoginSuccessNotifier extends _$LoginSuccessNotifier {
  @override
  bool build() => false;

  void show() => state = true;
  void clear() => state = false;
}
