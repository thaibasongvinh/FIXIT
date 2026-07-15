import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/guide_provider.dart';
import '../widgets/guide_card.dart';

class GuidesScreen extends ConsumerStatefulWidget {
  const GuidesScreen({super.key});

  @override
  ConsumerState<GuidesScreen> createState() => _GuidesState();
}

class _GuidesState extends ConsumerState<GuidesScreen> {
  final _search = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(guidesFeedNotifierProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(guidesFeedNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF9F7F2),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 30, bottom: 16),
              title: Text(
                'THE GUIDES',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 24,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 4,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextField(
                controller: _search,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search the collection...',
                  hintStyle: TextStyle(fontWeight: FontWeight.w100, fontSize: 13, letterSpacing: 2),
                  prefixIcon: Icon(Icons.search, size: 18),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
          ),
          feedAsync.when(
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (error, _) => SliverToBoxAdapter(child: Center(child: Text('Load error: $error'))),
            data: (feed) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      if (index == feed.items.length) return const SizedBox(height: 150);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: GuideCard(guide: feed.items[index]),
                      );
                    },
                    childCount: feed.items.length + 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
