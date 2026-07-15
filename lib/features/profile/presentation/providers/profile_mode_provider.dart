import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_mode_provider.g.dart';

enum ProfileMode { buying, selling }

@riverpod
class ProfileModeNotifier extends _$ProfileModeNotifier {
  @override
  ProfileMode build() => ProfileMode.buying;

  void setMode(ProfileMode mode) {
    state = mode;
  }

  void toggleMode() {
    state = state == ProfileMode.buying ? ProfileMode.selling : ProfileMode.buying;
  }
}
