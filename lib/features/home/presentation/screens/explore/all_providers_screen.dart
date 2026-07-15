import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/features/marketplace/presentation/providers/technician_provider.dart';
import 'package:fixit/features/marketplace/presentation/widgets/technician_card.dart';
import '../../widgets/components/shimmer_loading.dart';

class AllProvidersScreen extends ConsumerWidget {
  const AllProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniciansAsync = ref.watch(techniciansNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, l10n, isDark),
              Expanded(
                child: techniciansAsync.when(
                  data: (techs) {
                    if (techs.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noResultsFound,
                          style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      physics: const BouncingScrollPhysics(),
                      itemCount: techs.length,
                      separatorBuilder: (_, __) => const Gap(16),
                      itemBuilder: (context, index) => TechnicianCard(
                        tech: techs[index],
                      ),
                    );
                  },
                  loading: () => _buildSkeletonList(),
                  error: (e, _) => Center(
                    child: Text(
                      'Error: $e',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1D1E), size: 16),
              onPressed: () => context.pop(),
            ),
          ),
          const Gap(16),
          Text(
            l10n.professionalTechnicians.toUpperCase(),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1D1E),
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) => const ProviderCardSkeleton(),
    );
  }
}
