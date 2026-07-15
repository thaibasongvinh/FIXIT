import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/step_model.dart';
import '../providers/guide_provider.dart';
import '../widgets/guide_rating_sheet.dart';
import '../widgets/guide_video_player.dart';

class GuideReaderScreen extends ConsumerStatefulWidget {
  final String guideId;
  final String guideTitle;
  const GuideReaderScreen({
    super.key,
    required this.guideId,
    required this.guideTitle,
  });

  @override
  ConsumerState<GuideReaderScreen> createState() => _ReaderState();
}

class _ReaderState extends ConsumerState<GuideReaderScreen> {
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    // Reset bước đọc khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(guideReaderNotifierProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(guideStepsProvider(widget.guideId));
    final currentIdx = ref.watch(guideReaderNotifierProvider);
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final theme = Theme.of(context);

    return stepsAsync.when(
      loading: () =>
          const Scaffold(backgroundColor: Color(0xFF0F172A), body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(backgroundColor: const Color(0xFF0F172A), appBar: AppBar(), body: Center(child: Text('$e'))),
      data: (steps) {
        if (steps.isEmpty) {
          return Scaffold(
              backgroundColor: const Color(0xFF0F172A),
              appBar: AppBar(title: Text(widget.guideTitle)),
              body: const Center(child: Text('Chưa có bước nào', style: TextStyle(color: Colors.white))));
        }

        final total = steps.length;

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A), // Dark Navy
          body: SafeArea(
            child: Column(children: [
              // Top bar
              _ReaderTopBar(
                title: widget.guideTitle,
                current: currentIdx + 1,
                total: total,
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIdx + 1) / total,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: theme.colorScheme.primary,
                    minHeight: 6,
                  ),
                ),
              ),
              const Gap(12),

              // Step content
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  onPageChanged: (i) => ref
                      .read(guideReaderNotifierProvider.notifier)
                      .goToStep(i),
                  itemCount: total,
                  itemBuilder: (_, i) =>
                      _StepPageView(step: steps[i], index: i, total: total),
                ),
              ),

              // Bottom navigation
              _ReaderBottomNav(
                currentIdx: currentIdx,
                total: total,
                onPrev: () {
                  _pageCtrl.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuart);
                  ref.read(guideReaderNotifierProvider.notifier).prevStep();
                },
                onNext: () {
                  if (currentIdx == total - 1) {
                    _showCompleteDialog(context, authUser?.$id);
                    return;
                  }
                  _pageCtrl.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuart);
                  ref
                      .read(guideReaderNotifierProvider.notifier)
                      .nextStep(total);
                },
              ),
            ]),
          ),
        );
      },
    );
  }

  void _showCompleteDialog(BuildContext context, String? userId) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('🎉 Hoàn thành!'),
              content: const Text('''Bạn đã hoàn thành tất cả các bước.
Thiết bị đã được sửa chữa thành công?'''),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Xong'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui long dang nhap de danh gia'),
                        ),
                      );
                      return;
                    }
                    await showGuideRatingSheet(
                      context: context,
                      ref: ref,
                      guideId: widget.guideId,
                      userId: userId,
                    );
                  },
                  child: const Text('Đánh giá hướng dẫn'),
                ),
              ],
            ));
  }
}

// Trang hiển thị 1 bước
class _StepPageView extends StatelessWidget {
  final StepModel step;
  final int index, total;
  const _StepPageView(
      {required this.step, required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'BƯỚC ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.white54),
                        const Gap(4),
                        Text(
                          '${step.duration} Phút',
                          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(16),
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          
          const Gap(24),

          // Images
          if (step.imageUrls.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: PageView.builder(
                  itemCount: step.imageUrls.length,
                  itemBuilder: (_, i) => CachedNetworkImage(
                    imageUrl: step.imageUrls[i],
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                ),
              ),
            ),
            if (step.imageUrls.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    step.imageUrls.length,
                    (idx) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: idx == 0 ? theme.colorScheme.primary : Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
            const Gap(24),
          ],

          // Content
          Container(
            padding: const EdgeInsets.all(4),
            child: MarkdownBody(
              data: step.content,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                    fontSize: 17, height: 1.6, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w400),
              ),
            ),
          ),

          if (step.videoUrl.isNotEmpty) ...[
            const Gap(32),
            const Row(
              children: [
                Icon(Icons.play_circle_fill_rounded, color: Colors.redAccent, size: 24),
                Gap(8),
                Text(
                  'Video hướng dẫn',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ],
            ),
            const Gap(16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GuideVideoPlayer(url: step.videoUrl),
            ),
          ],

          // Warning
          if (step.warningNote.isNotEmpty) ...[
            const Gap(32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.report_problem_rounded, color: Colors.amber, size: 24),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LƯU Ý QUAN TRỌNG',
                          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
                        ),
                        const Gap(4),
                        Text(
                          step.warningNote,
                          style: TextStyle(color: Colors.amber.shade200, fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const Gap(100), // Khoảng trống cho navigation
        ],
      ),
    );
  }
}

class _ReaderTopBar extends StatelessWidget {
  final String title;
  final int current, total;
  const _ReaderTopBar(
      {required this.title, required this.current, required this.total});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Gap(4),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$current / $total',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]),
      );
}

class _ReaderBottomNav extends StatelessWidget {
  final int currentIdx, total;
  final VoidCallback onPrev, onNext;
  const _ReaderBottomNav(
      {required this.currentIdx,
      required this.total,
      required this.onPrev,
      required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(children: [
        // Prev
        if (currentIdx > 0)
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton.filled(
              onPressed: onPrev,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                minimumSize: const Size(56, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            ),
          ),
        // Next / Finish
        Expanded(
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentIdx == total - 1 ? 'HOÀN THÀNH' : 'BƯỚC TIẾP THEO',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1),
                ),
                const Gap(8),
                Icon(
                    currentIdx == total - 1
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 18),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
