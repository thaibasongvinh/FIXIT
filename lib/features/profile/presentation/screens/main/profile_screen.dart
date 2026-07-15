import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/models/user_model.dart';
import '../../widgets/profile_widgets.dart';
import 'buying_mode_profile.dart';
import 'selling_mode_profile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(currentUserProvider);
            await ref.read(currentUserProvider.future);
          },
          child: SafeArea(
            child: userAsync.when(
              loading: () => const ProfileShimmer(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.error(e.toString()),
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(currentUserProvider),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: Text(l10n.tryAgain,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              data: (user) {
                final authUser = ref.read(authStateProvider).valueOrNull;
                final authName = (authUser?.name.isNotEmpty ?? false)
                    ? authUser!.name
                    : 'FixIt User';
                final authEmail =
                    (authUser?.email.isNotEmpty ?? false) ? authUser!.email : '';
                final authPhone =
                    (authUser?.phone.isNotEmpty ?? false) ? authUser!.phone : '';

                debugPrint(
                    'ProfileScreen: DATA FROM DB - User: ${user?.uid}, DOB: "${user?.dob}", Addresses: ${user?.addresses}');

                if (user != null) {
                  // Fallback name, email, and phone from Auth if empty in DB
                  final effectiveUser = user.copyWith(
                    name: user.name.isEmpty ? authName : user.name,
                    email: user.email.isEmpty ? authEmail : user.email,
                    phone: user.phone.isEmpty ? authPhone : user.phone,
                    dob: user.dob,
                    addresses: user.addresses,
                  );

                  return effectiveUser.role == UserRole.technician
                      ? SellingModeProfile(user: effectiveUser)
                      : BuyingModeProfile(user: effectiveUser);
                }

                // Chỉ khi user từ DB thực sự null (đang tạo hoặc lỗi sync), mới dùng Auth làm fallback
                final fallbackUser = UserModel(
                  uid: authUser?.$id ?? '',
                  name: authName,
                  email: authEmail.isNotEmpty
                      ? authEmail
                      : (authPhone.isNotEmpty ? authPhone : 'Please login'),
                  phone: authPhone,
                  avatar: '',
                  dob: '',
                  addresses: const [],
                  role: UserRole.customer,
                );

                return BuyingModeProfile(user: fallbackUser);
              },
            ),
          ),
        ),
      ),
    );
  }
}
