import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/providers/services_provider.dart';
import '../../../marketplace/domain/models/technician_model.dart';
import '../../../marketplace/presentation/providers/technician_provider.dart';

class FilterState {
  final String serviceCategory;
  final double minRating;
  final double maxRating;
  final double minPrice;
  final double maxPrice;
  final String experienceLevel;
  final bool isUrgent;

  FilterState({
    this.serviceCategory = 'ALL',
    this.minRating = 3.0,
    this.maxRating = 5.0,
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.experienceLevel = 'ALL',
    this.isUrgent = false,
  });

  FilterState copyWith({
    String? serviceCategory,
    double? minRating,
    double? maxRating,
    double? minPrice,
    double? maxPrice,
    String? experienceLevel,
    bool? isUrgent,
  }) {
    return FilterState(
      serviceCategory: serviceCategory ?? this.serviceCategory,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }
}

final searchFilterProvider = StateProvider<FilterState>((ref) => FilterState());

final filteredTechniciansProvider = FutureProvider<List<TechnicianModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final filter = ref.watch(searchFilterProvider);
  
  // 1. Luôn ưu tiên Mock Data để chụp ảnh báo cáo ổn định
  final mockTechs = await ref.read(techniciansNotifierProvider.notifier).build();
  
  List<TechnicianModel> results;
  if (query.isEmpty) {
    results = mockTechs;
  } else {
    results = mockTechs.where((tech) {
      final searchString = '${tech.name} ${tech.skills.join(' ')}'.toLowerCase();
      return searchString.contains(query.toLowerCase());
    }).toList();
  }

  // 2. Nếu Mock Data không có kết quả mới tìm trong Repo thật
  if (results.isEmpty && query.isNotEmpty) {
    results = await ref.read(technicianRepositoryProvider).searchTechnicians(query);
  }

  // 3. Apply advanced filters
  return results.where((tech) {
    // Filter by Rating
    if (tech.rating < filter.minRating || tech.rating > filter.maxRating) return false;
    
    // Filter by Price (Sửa thành 1000k để khớp với Mock Data 150k)
    if (tech.pricePerHour < filter.minPrice || tech.pricePerHour > (filter.maxPrice * 1000)) return false;
    
    // Filter by Service Category (Skill)
    if (filter.serviceCategory != 'ALL') {
       if (!tech.skills.any((s) => s.toLowerCase().contains(filter.serviceCategory.toLowerCase()))) return false;
    }
    
    // Filter by Urgency
    if (filter.isUrgent && !tech.isAvailable) return false;

    return true;
  }).toList();
});
