import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/config/locale_provider.dart';
import '../../../../core/services/translation_provider.dart';
import '../../../../shared/widgets/typography/translated_text.dart';
import '../../domain/models/guide_model.dart';
import '../../domain/models/tool_model.dart';
import '../../domain/models/step_model.dart';
import '../providers/guide_provider.dart';

class GuideDetailScreen extends ConsumerStatefulWidget {
  final String guideId;
  const GuideDetailScreen({super.key, required this.guideId});

  @override
  ConsumerState<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends ConsumerState<GuideDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final guideAsync = ref.watch(guideDetailProvider(widget.guideId));
    final stepsAsync = ref.watch(guideStepsProvider(widget.guideId));

    return guideAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.red))),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (guide) {
        if (guide == null)
          return const Scaffold(body: Center(child: Text('Guide not found')));

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F2),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _NothingDetailAppBar(guide: guide),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _NothingSectionLabel(title: 'METADATA'),
                      const Gap(16),
                      _NothingMetadataRow(guide: guide),
                      const Gap(40),
                      const _NothingSectionLabel(title: 'DESCRIPTION'),
                      const Gap(16),
                      _NothingPanel(
                        child: TranslatedText(
                          guide.description,
                          useMarkdown: true,
                          style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Gap(40),
                      _NothingRequiredItems(
                          title: 'SYSTEM TOOLS', items: guide.requiredTools),
                      const Gap(40),
                      const _NothingSectionLabel(title: 'EXECUTION STEPS'),
                      const Gap(16),
                    ],
                  ),
                ),
              ),
              stepsAsync.when(
                data: (steps) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _NothingStepCard(step: steps[i]),
                    childCount: steps.length,
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.red))),
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
              ),
              const SliverGap(150),
            ],
          ),
        );
      },
    );
  }
}

class _NothingDetailAppBar extends StatelessWidget {
  final GuideModel guide;
  const _NothingDetailAppBar({required this.guide});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.red,
      expandedHeight: 240,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: TranslatedText(
          guide.title.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1),
        ),
        background:
            CachedNetworkImage(imageUrl: guide.coverImage, fit: BoxFit.cover),
      ),
    );
  }
}

class _NothingSectionLabel extends StatelessWidget {
  final String title;
  const _NothingSectionLabel({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: Colors.grey),
    );
  }
}

class _NothingMetadataRow extends StatelessWidget {
  final GuideModel guide;
  const _NothingMetadataRow({required this.guide});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NothingMetaItem(label: 'TIME', val: '${guide.estimatedTime}M'),
        _NothingMetaItem(
            label: 'DIFF',
            val: guide.difficultyLabel.split(' ').last.toUpperCase()),
        _NothingMetaItem(label: 'VER', val: '1.0.0'),
      ],
    );
  }
}

class _NothingMetaItem extends StatelessWidget {
  final String label, val;
  const _NothingMetaItem({required this.label, required this.val});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(val,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const Gap(4),
        Text(label,
            style: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w900, color: Colors.red)),
      ],
    );
  }
}

class _NothingPanel extends StatelessWidget {
  final Widget child;
  const _NothingPanel({required this.child});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: child,
    );
  }
}

class _NothingRequiredItems extends StatelessWidget {
  final String title;
  final List<ToolModel> items;
  const _NothingRequiredItems({required this.title, required this.items});
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NothingSectionLabel(title: title),
        const Gap(16),
        ...items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _NothingPanel(
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.red, size: 8),
                    const Gap(16),
                    Expanded(
                      child: TranslatedText(i.name.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1)),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _NothingStepCard extends StatelessWidget {
  final StepModel step;
  const _NothingStepCard({required this.step});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color:
                isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('0${step.order}',
                        style: const TextStyle(
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                            color: Colors.red)),
                    const Gap(16),
                    Expanded(
                        child: TranslatedText(step.title.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 1))),
                  ],
                ),
                const Gap(24),
                if (step.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: step.imageUrls.first,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover),
                  ),
                const Gap(24),
                _NothingStepContent(content: step.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NothingStepContent extends ConsumerWidget {
  final String content;
  const _NothingStepContent({required this.content});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    if (targetLang == 'en') {
      return _buildRichText(content);
    }

    final translationAsync =
        ref.watch(translatedTextProvider(content, targetLang));

    return translationAsync.when(
      data: (translated) => _buildRichText(translated),
      loading: () => Opacity(
        opacity: 0.5,
        child: _buildRichText(content),
      ),
      error: (_, __) => _buildRichText(content),
    );
  }

  Widget _buildRichText(String text) {
    final List<InlineSpan> spans = [];
    final regex = RegExp(r'\{(red|orange|yellow|green|blue|violet)\}');
    int lastMatchEnd = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      final color = _getColorFromName(match.group(1));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2)),
          ),
        ),
      );
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length)
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));

    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.grey,
            fontWeight: FontWeight.w400),
        children: spans,
      ),
    );
  }

  Color _getColorFromName(String? name) {
    switch (name) {
      case 'red':
        return const Color(0xFFFF0000);
      case 'orange':
        return const Color(0xFFFF8000);
      case 'yellow':
        return const Color(0xFFFFFF00);
      case 'green':
        return const Color(0xFF00FF00);
      case 'blue':
        return const Color(0xFF0000FF);
      case 'violet':
        return const Color(0xFFA020F0);
      default:
        return Colors.grey;
    }
  }
}
