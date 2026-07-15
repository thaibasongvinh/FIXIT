import 'package:fixit/features/guides/domain/guide_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('guide metadata helpers', () {
    test('normalizeGuideText removes accents and punctuation', () {
      expect(
        normalizeGuideText('Thay màn hình iPhone 14!'),
        'thay man hinh iphone 14',
      );
    });

    test('buildGuideSlug combines title and device', () {
      expect(
        buildGuideSlug('Vệ sinh cổng sạc', 'Samsung Galaxy S23'),
        've-sinh-cong-sac-samsung-galaxy-s23',
      );
    });

    test('buildGuideSearchKeywords returns sorted unique keywords', () {
      final keywords = buildGuideSearchKeywords(
        title: 'Thay pin MacBook Air M1',
        description: 'Huong dan thay pin an toan',
        device: 'MacBook Air M1',
        category: 'laptop',
        tags: const ['macbook', 'pin'],
        toolsRequired: const ['tua vit torx'],
      );

      expect(keywords, containsAll(['macbook', 'pin', 'laptop', 'air']));
      expect(keywords, orderedEquals([...keywords]..sort()));
    });
  });
}
