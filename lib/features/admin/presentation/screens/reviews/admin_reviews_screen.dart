import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';

class AdminReviewsScreen extends ConsumerWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(adminReviewsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF010A1A) : const Color(0xFFF5F7FA);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1C1E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('CUSTOMER FEEDBACK', 
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (isDark)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0D47A1), Color(0xFF010A1A), Color(0xFF000000)],
                ),
              ),
            ),
          SafeArea(
            child: reviewsAsync.when(
              data: (reviews) => reviews.isEmpty 
                ? _buildEmptyState(textColor)
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) => _buildReviewCard(context, ref, reviews[index], isDark, textColor),
                  ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, WidgetRef ref, Map<String, dynamic> review, bool isDark, Color textColor) {
    final double rating = (review['rating'] ?? 0).toDouble();
    final DateTime date = review['createdAt'] != null ? DateTime.parse(review['createdAt']) : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(5, (i) => Icon(
                  Icons.star_rounded, 
                  color: i < rating ? Colors.orangeAccent : Colors.white10,
                  size: 18,
                )),
              ),
              Text(DateFormat('MMM dd, yyyy').format(date), style: TextStyle(color: textColor.withValues(alpha: 0.2), fontSize: 11)),
            ],
          ),
          const Gap(12),
          Text(review['content'] ?? review['comment'] ?? 'No comment provided', style: TextStyle(color: textColor, fontSize: 14, height: 1.5)),
          const Gap(16),
          Row(
            children: [
              const Icon(Icons.handyman_outlined, size: 14, color: Colors.blueAccent),
              const Gap(8),
              Text('For: ${review['technicianName'] ?? 'Unknown Tech'}', style: TextStyle(color: textColor.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                onPressed: () => _handleDelete(ref, review['\$id']),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleDelete(WidgetRef ref, String id) {
    ref.read(adminReviewsProvider.notifier).deleteReview(id);
  }

  Widget _buildEmptyState(Color textColor) => Center(child: Text('No reviews found', style: TextStyle(color: textColor.withValues(alpha: 0.2))));
}
