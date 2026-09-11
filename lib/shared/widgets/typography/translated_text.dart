import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/locale_provider.dart';
import '../../../core/services/translation_provider.dart';

class TranslatedText extends ConsumerWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool useMarkdown;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.useMarkdown = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    final targetLang = locale.languageCode;

    // Use the correctly defined provider from translation_provider.dart
    final translationAsync =
        ref.watch(translatedTextProvider(text, targetLang));

    return translationAsync.when(
      data: (translated) => useMarkdown
          ? MarkdownBody(
              data: translated,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: style,
              ),
            )
          : Text(
              translated,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
      loading: () => useMarkdown
          ? MarkdownBody(
              data: text,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: (style ?? const TextStyle()).copyWith(
                  color: (style?.color ?? Colors.grey).withValues(alpha: 0.5),
                ),
              ),
            )
          : Text(
              text, // Show original while loading
              style: style?.copyWith(
                color: style?.color?.withValues(alpha: 0.5),
              ),
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
      error: (err, _) => useMarkdown
          ? MarkdownBody(
              data: text,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: style,
              ),
            )
          : Text(
              text, // Fallback to original on error
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            ),
    );
  }
}
