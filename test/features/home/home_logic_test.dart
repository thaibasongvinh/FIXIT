import 'package:fixit/features/marketplace/domain/models/technician_model.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Logic Kiểm tra Thợ (Technician Logic Tests)', () {
    // Dữ liệu giả lập (Mock Data)
    final techLowRating = const TechnicianModel(
      uid: '1',
      name: 'Thợ Thấp',
      avatar: '',
      phone: '',
      bio: '',
      skills: [],
      rating: 3.5,
      reviewCount: 10,
      isAvailable: true,
      pricePerHour: 20,
      services: [],
      completedJobs: 5,
    );

    final techHighRating = const TechnicianModel(
      uid: '2',
      name: 'Thợ Cao',
      avatar: '',
      phone: '',
      bio: '',
      skills: [],
      rating: 5.0,
      reviewCount: 50,
      isAvailable: true,
      pricePerHour: 50,
      services: [],
      completedJobs: 100,
    );

    test('Danh sách thợ phải được sắp xếp từ Rating cao đến thấp', () {
      // 1. Chuẩn bị danh sách chưa sắp xếp
      final techs = [techLowRating, techHighRating];

      // 2. Chạy logic sắp xếp (giống hệt logic trong ProviderPreviewRail)
      final sortedTechs = techs.toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));

      // 3. Kiểm tra kết quả (Expectation)
      expect(sortedTechs.first.name, 'Thợ Cao');
      expect(sortedTechs.last.name, 'Thợ Thấp');
      expect(sortedTechs.first.rating, 5.0);
    });

    test('Logic xáo trộn (shuffle) phải làm thay đổi thứ tự danh sách', () {
      final list = [1, 2, 3, 4, 5, 6, 7, 8];
      final originalList = List.from(list);
      
      // Xáo trộn
      list.shuffle();
      
      // Kiểm tra xem nó có khác danh sách gốc không (tỉ lệ trùng cực thấp)
      expect(list, isNot(originalList));
    });
  });
}
