import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_provider.g.dart';

@riverpod
class DrawerState extends _$DrawerState {
  @override
  bool build() => false;

  void setOpen(bool isOpen) {
    state = isOpen;
  }
}
