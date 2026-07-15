import 'package:flutter/material.dart';

class CategoryFilter extends StatefulWidget {
  final void Function(String) onSelected;
  const CategoryFilter({super.key, required this.onSelected});
  @override
  State<CategoryFilter> createState() => _State();
}

class _State extends State<CategoryFilter> {
  String _selected = 'all';
  static const _cats = [
    ('all', 'Tất cả', Icons.apps),
    ('smartphone', '📱 Điện thoại', Icons.phone_android),
    ('laptop', '💻 Laptop', Icons.laptop),
    ('xe_may', '🏍️ Xe máy', Icons.two_wheeler),
    ('gia_dung', '🏠 Gia dụng', Icons.home),
    ('khac', '🔧 Khác', Icons.build),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (id, label, _) = _cats[i];
          final isSelected = _selected == id;
          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selected = id);
              widget.onSelected(id);
            },
            backgroundColor: cs.surface,
            selectedColor: cs.primaryContainer,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            side: BorderSide(
                color: isSelected
                    ? cs.primary
                    : cs.outline.withValues(alpha: 0.3)),
          );
        },
      ),
    );
  }
}
