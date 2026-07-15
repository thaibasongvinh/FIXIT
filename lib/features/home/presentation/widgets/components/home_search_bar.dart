import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/core/router/app_router.dart';
import '../../providers/services_provider.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterPressed;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onFilterPressed,
  });

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> with SingleTickerProviderStateMixin {
  bool _showClearButton = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  
  // Animation cho hint text xoay vòng
  late Timer _hintTimer;
  int _currentHintIndex = 0;
  final List<String> _hints = [
    'Search "AC Repair"..',
    'Search "Electrician"..',
    'Search "House Cleaning"..',
    'Search "Plumber"..',
    'Search "Fix it now"..',
  ];

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
    _onTextChanged();
    
    // Chạy hint animation
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isFocused && (widget.controller?.text.isEmpty ?? true)) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
        });
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    final show = widget.controller?.text.isNotEmpty ?? false;
    if (show != _showClearButton) {
      setState(() => _showClearButton = show);
    }
  }

  @override
  void dispose() {
    _hintTimer.cancel();
    widget.controller?.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: _isFocused ? 1.02 : 1.0, // Phóng to nhẹ khi nhấn vào
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 64,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101B2D) : Colors.white,
          borderRadius: BorderRadius.circular(20), // Tròn trịa hiện đại hơn
          boxShadow: [
            BoxShadow(
              color: _isFocused 
                  ? const Color(0xFF0054A5).withValues(alpha: isDark ? 0.3 : 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: _isFocused ? 30 : 25,
              offset: Offset(0, _isFocused ? 12 : 10),
            ),
          ],
          border: Border.all(
            color: _isFocused ? const Color(0xFF0054A5).withValues(alpha: 0.3) : (isDark ? Colors.white.withOpacity(0.05) : Colors.transparent),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            // Biểu tượng Search
            Icon(
              Icons.search_rounded,
              color: _isFocused ? const Color(0xFF0054A5) : (isDark ? Colors.white38 : const Color(0xFF5C5F62)),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Hint text xoay vòng
                  if (!_isFocused && (widget.controller?.text.isEmpty ?? true))
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.5),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _hints[_currentHintIndex],
                        key: ValueKey(_hints[_currentHintIndex]),
                        style: TextStyle(
                          color: isDark ? Colors.white24 : const Color(0xFFA6A6A6),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: const Color(0xFF0054A5),
                    onChanged: (val) {
                      ref.read(searchQueryProvider.notifier).state = val;
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : const Color(0xFF333333),
                    ),
                    decoration: const InputDecoration(
                      hintText: '',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            // Nút Xem Bản Đồ
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.technicianMap),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blueAccent.withValues(alpha: 0.1) : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    size: 22,
                    color: Color(0xFF0054A5),
                  ),
                ),
              ),
            ),
            // Nút Filter Nâng Cao
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => context.push('/search/filter'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF5F8FB), // Màu xanh nhạt tech
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: Color(0xFF0054A5), // Đồng nhất tone xanh
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
