import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/guide_provider.dart';

Future<void> showGuideRatingSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String guideId,
  required String userId,
}) async {
  final repository = ref.read(guideRepositoryProvider);
  final existingRating = await repository.getUserRating(guideId, userId);
  if (!context.mounted) return;
  final reviewController = TextEditingController();
  var selectedRating = existingRating ?? 5.0;
  var submitting = false;

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đánh giá hướng dẫn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chọn số sao phù hợp với trải nghiệm của bạn.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    final active = selectedRating >= starValue;
                    return IconButton(
                      onPressed: submitting
                          ? null
                          : () => setState(() {
                                selectedRating = starValue.toDouble();
                              }),
                      iconSize: 32,
                      icon: Icon(
                        active ? Icons.star_rounded : Icons.star_border_rounded,
                        color: active ? Colors.amber : Colors.grey,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reviewController,
                  minLines: 2,
                  maxLines: 4,
                  enabled: !submitting,
                  decoration: const InputDecoration(
                    labelText: 'Nhận xét (không bắt buộc)',
                    hintText: 'Ví dụ: Hướng dẫn dễ làm theo, ảnh rõ ràng...',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: submitting
                        ? null
                        : () async {
                            setState(() => submitting = true);
                            try {
                              await repository.rateGuide(
                                guideId: guideId,
                                userId: userId,
                                rating: selectedRating,
                                review: reviewController.text,
                              );
                              ref.invalidate(guideDetailProvider(guideId));
                              ref.invalidate(guidesFeedNotifierProvider);
                              if (sheetContext.mounted) {
                                Navigator.of(sheetContext).pop();
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã gửi đánh giá thành công'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Không thể gửi đánh giá: $e'),
                                  ),
                                );
                              }
                            } finally {
                              if (sheetContext.mounted) {
                                setState(() => submitting = false);
                              }
                            }
                          },
                    icon: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.rate_review_outlined),
                    label: Text(submitting ? 'Đang gửi...' : 'Gửi đánh giá'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
