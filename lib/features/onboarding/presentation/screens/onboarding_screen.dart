import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fixit/core/config/locale_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';

import 'package:fixit/shared/widgets/app_bar/auth_top_actions.dart';
import '../../domain/models/onboarding_model.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  double _currentPage = 0;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _controller.addListener(() {
      final newPage = _controller.page ?? 0;
      if (newPage.round() != _currentPage.round()) {
        HapticFeedback.lightImpact();
      }
      setState(() {
        _currentPage = newPage;
      });
    });
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${packageInfo.version}';
      });
    }
  }

  List<OnboardingItem> _getItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      OnboardingItem(
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
        imagePath: 'assets/images/onboarding1.png',
        backgroundColor: Theme.of(context).primaryColor,
        buttonText: l10n.getStarted,
        order: 0,
      ),
      OnboardingItem(
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
        imagePath: 'assets/images/onboarding2.png',
        backgroundColor: Theme.of(context).primaryColor,
        buttonText: l10n.next,
        order: 1,
      ),
      OnboardingItem(
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
        imagePath: 'assets/images/onboarding3.png',
        backgroundColor: Theme.of(context).primaryColor,
        buttonText: l10n.launchApp,
        order: 2,
      ),
    ];
  }

  Future<void> _complete() async {
    await ref.read(onboardingNotifierProvider.notifier).complete();
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems(context);
    final locale = ref.watch(localeNotifierProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Các luồng sáng chạy ngầm tạo chiều sâu
            _GlowOrbs(pageOffset: _currentPage),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                    child: Row(
                      children: [
                        _ModernIndicators(
                          total: items.length, 
                          current: _currentPage,
                          activeColor: isDark ? Colors.white : primaryColor,
                        ),
                        Expanded(
                          child: AuthTopActions(
                            showSkip: true,
                            onSkip: () {
                              HapticFeedback.selectionClick();
                              _complete();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        physics: const BouncingScrollPhysics(),
                      ),
                      child: PageView.builder(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          double relativePosition = index - _currentPage;
                          return _ParallaxPage(
                            item: items[index],
                            position: relativePosition,
                          );
                        },
                      ),
                    ),
                  ),

                  // Content Section với Glassmorphism thích ứng
                  _GlassContent(
                    isDark: isDark,
                    item: items[_currentPage.round().clamp(0, items.length - 1)],
                    onNext: () {
                      HapticFeedback.mediumImpact();
                      if (_currentPage < items.length - 1) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutQuart,
                        );
                      } else {
                        _complete();
                      }
                    },
                  ),

                  // App Version Signature
                  if (_appVersion.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _appVersion,
                        style: TextStyle(
                          color: isDark ? Colors.white24 : Colors.black12,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParallaxPage extends StatelessWidget {
  final OnboardingItem item;
  final double position;

  const _ParallaxPage({required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Transform.translate(
        offset: Offset(position * 100, 0), // Giảm độ trượt để mượt hơn
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain, // Dùng contain để không bị cắt đầu
              alignment: Alignment.bottomCenter, // Căn xuống dưới để phần đầu có nhiều khoảng trống nhất
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassContent extends StatelessWidget {
  final OnboardingItem item;
  final VoidCallback onNext;
  final bool isDark;

  const _GlassContent({
    required this.item,
    required this.onNext,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              item.title,
              key: ValueKey(item.title),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.blueGrey.shade900,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              item.description,
              key: ValueKey(item.description),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white.withOpacity(0.7) : Colors.blueGrey.shade700,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isDark ? 0 : 4,
                shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              child: Text(
                item.buttonText.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernIndicators extends StatelessWidget {
  final int total;
  final double current;
  final Color activeColor;

  const _ModernIndicators({
    required this.total, 
    required this.current,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        double delta = (index - current).abs();
        double width = (1 - delta).clamp(0, 1) * 20 + 8;
        return Container(
          margin: const EdgeInsets.only(right: 6),
          height: 6,
          width: width,
          decoration: BoxDecoration(
            color: index == current.round() ? activeColor : activeColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _GlowOrbs extends StatelessWidget {
  final double pageOffset;
  const _GlowOrbs({required this.pageOffset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          top: 100 - (pageOffset * 50),
          right: -100 + (pageOffset * 100),
          child: _Orb(size: 300, color: Colors.blueAccent.withOpacity(0.2)),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          bottom: 200 + (pageOffset * 50),
          left: -50 - (pageOffset * 50),
          child: _Orb(size: 200, color: Colors.lightBlue.withOpacity(0.1)),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 20)],
      ),
    );
  }
}
