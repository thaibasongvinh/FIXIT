import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../providers/filter_provider.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> with TickerProviderStateMixin {
  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(searchFilterProvider);
    const primaryColor = Color(0xFF0054A5);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Color(0xFF333333), size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: const Text(
          'Advanced Filters',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(searchFilterProvider.notifier).state = FilterState(),
            child: const Text('Reset', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700)),
          ),
          const Gap(12),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                _buildStaggeredSection(0, _buildSectionLabel('Service Category')),
                const Gap(16),
                _buildStaggeredSection(
                  1,
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFuturisticChip('ALL', filter.serviceCategory == 'ALL', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(serviceCategory: 'ALL'))),
                      _buildFuturisticChip('Repair', filter.serviceCategory == 'Repair', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(serviceCategory: 'Repair'))),
                      _buildFuturisticChip('Wiring', filter.serviceCategory == 'Wiring', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(serviceCategory: 'Wiring'))),
                      _buildFuturisticChip('Cleaning', filter.serviceCategory == 'Cleaning', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(serviceCategory: 'Cleaning'))),
                    ],
                  ),
                ),
                const Gap(32),
                _buildStaggeredSection(2, _buildSectionLabel('Availability')),
                const Gap(16),
                _buildStaggeredSection(
                  3,
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernToggle(
                          Icons.bolt_rounded,
                          'Urgent', 
                          filter.isUrgent,
                          () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(isUrgent: !s.isUrgent)),
                        ),
                      ),
                      const Gap(12),
                      const Expanded(child: SizedBox()), // Spacer
                    ],
                  ),
                ),
                const Gap(32),
                _buildStaggeredSection(4, _buildSectionLabel('Rating Scale')),
                const Gap(20),
                _buildStaggeredSection(5, _buildRangeSlider(
                  RangeValues(filter.minRating, filter.maxRating), 1, 5, '★', 
                  (v) => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(minRating: v.start, maxRating: v.end))
                )),
                const Gap(32),
                _buildStaggeredSection(6, _buildSectionLabel('Price Range (USD)')),
                const Gap(20),
                _buildStaggeredSection(7, _buildRangeSlider(
                  RangeValues(filter.minPrice, filter.maxPrice), 0, 1000, r'$',
                  (v) => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(minPrice: v.start, maxPrice: v.end))
                )),
                const Gap(32),
                _buildStaggeredSection(8, _buildSectionLabel('Expertise Level')),
                const Gap(16),
                _buildStaggeredSection(
                  9,
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFuturisticChip('ALL', filter.experienceLevel == 'ALL', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(experienceLevel: 'ALL'))),
                      _buildFuturisticChip('Entry', filter.experienceLevel == 'Entry', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(experienceLevel: 'Entry'))),
                      _buildFuturisticChip('5+ Years', filter.experienceLevel == '5', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(experienceLevel: '5'))),
                      _buildFuturisticChip('Pro', filter.experienceLevel == 'Pro', 
                        () => ref.read(searchFilterProvider.notifier).update((s) => s.copyWith(experienceLevel: 'Pro'))),
                    ],
                  ),
                ),
                const Gap(120),
              ],
            ),
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withValues(alpha: 0), Colors.white, Colors.white],
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryColor, Color(0xFF003D7A)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Apply Filters',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                      Gap(12),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggeredSection(int index, Widget child) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        final start = 0.08 * index;
        final end = (start + 0.4).clamp(0.0, 1.0);
        final animation = CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildFuturisticChip(String label, bool isSelected, VoidCallback onTap) {
    const primaryColor = Color(0xFF0054A5);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE8E8E8),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF555555),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildModernToggle(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    const primaryColor = Color(0xFF0054A5);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE8E8E8),
            width: 1.8,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primaryColor : const Color(0xFFBDBDBD), size: 24),
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : const Color(0xFF555555),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSlider(RangeValues values, double min, double max, String unit, ValueChanged<RangeValues> onChanged) {
    const primaryColor = Color(0xFF0054A5);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildValueBadge('${values.start.round()} $unit'),
            _buildValueBadge('${values.end.round()} $unit'),
          ],
        ),
        const Gap(8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: primaryColor,
            inactiveTrackColor: const Color(0xFFE8E8E8),
            thumbColor: Colors.white,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 12,
              elevation: 4,
            ),
            overlayColor: primaryColor.withValues(alpha: 0.1),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildValueBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF0054A5), fontWeight: FontWeight.w800, fontSize: 13),
      ),
    );
  }
}
