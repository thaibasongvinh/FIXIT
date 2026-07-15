import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import '../../data/repositories/technician_repository_impl.dart';
import '../../domain/models/technician_model.dart';
import '../../domain/technician_repository.dart';

part 'technician_provider.g.dart';

@riverpod
TechnicianRepository technicianRepository(Ref ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final env = ref.watch(appEnvironmentProvider);
  return TechnicianRepositoryImpl(
    databases: db,
    databaseId: env.appwriteDatabaseId,
  );
}

enum TechnicianSort {
  nearby,
  rating,
  priceLow,
}

@riverpod
class TechniciansNotifier extends _$TechniciansNotifier {
  String _skill = 'all';
  double _minRating = 0;
  TechnicianSort _sort = TechnicianSort.nearby;
  Position? _position;

  @override
  Future<List<TechnicianModel>> build() => _fetch();

  Future<List<TechnicianModel>> _fetch() async {
    // MOCK DATA CHUẨN ĐỂ BẠN CHỤP ẢNH BÁO CÁO
    return [
      TechnicianModel(
        uid: 'tech_1',
        name: 'Nguyễn Văn Nam',
        phone: '0901234567',
        avatar: 'https://i.pravatar.cc/150?u=tech1', // Dùng URL thật để tránh lỗi asset
        skills: ['Sửa điện dân dụng', 'Máy lạnh'],
        rating: 4.9,
        isAvailable: true,
        isVerified: true,
        pricePerHour: 150000,
        bio: '10 năm kinh nghiệm sửa chữa điện lạnh, làm việc tận tâm.',
        latitude: 10.762622,
        longitude: 106.660172,
        color: '#E3F2FD',
      ),
      TechnicianModel(
        uid: 'tech_2',
        name: 'Trần Minh Tâm',
        phone: '0907654321',
        avatar: 'https://i.pravatar.cc/150?u=tech2',
        skills: ['Sửa ống nước', 'Plumber'],
        rating: 4.7,
        isAvailable: true,
        isVerified: true,
        pricePerHour: 120000,
        bio: 'Chuyên khắc phục sự cố rò rỉ nước, thông tắc bồn cầu.',
        latitude: 10.776889,
        longitude: 106.700806,
        color: '#F1F8E9',
      ),
      TechnicianModel(
        uid: 'tech_3',
        name: 'Lê Hoàng Long',
        phone: '0912345678',
        avatar: 'https://i.pravatar.cc/150?u=tech3',
        skills: ['Vệ sinh nhà cửa', 'Dọn dẹp'],
        rating: 4.8,
        isAvailable: true,
        isVerified: true,
        pricePerHour: 100000,
        bio: 'Dịch vụ vệ sinh công nghiệp chuyên nghiệp, uy tín.',
        latitude: 10.823099,
        longitude: 106.629654,
        color: '#FFFDE7',
      ),
    ];
  }

  /* // Giữ lại logic gốc để tham khảo hoặc khôi phục sau
  Future<List<TechnicianModel>> _fetchOriginal() async {
    try {
      final techs = await ref.watch(technicianRepositoryProvider).getTechnicians(
            skill: _skill == 'all' ? null : _skill,
            isAvailable: null, 
            limit: 50,
          );
      // ... rest of the code
    } catch (e) {
      return <TechnicianModel>[];
    }
  }
  */

  Future<Position?> _resolvePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // 1. Thử lấy vị trí cuối cùng được biết (Rất nhanh)
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;

      // 2. Nếu không có, lấy vị trí hiện tại với timeout ngắn (Tránh treo lâu)
      return await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 3),
      ).timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('Location request timed out'),
      );
    } catch (_) {
      return null;
    }
  }

  void _sortByDistanceOrRating(List<TechnicianModel> techs) {
    final pos = _position;
    if (pos == null) {
      techs.sort((a, b) => b.rating.compareTo(a.rating));
      return;
    }

    techs.sort((a, b) {
      if (a.latitude == null || a.longitude == null) return 1;
      if (b.latitude == null || b.longitude == null) return -1;

      final distA = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        a.latitude!,
        a.longitude!,
      );
      final distB = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        b.latitude!,
        b.longitude!,
      );
      return distA.compareTo(distB);
    });
  }

  Future<void> updateCurrentLocation() async {
    final pos = await _resolvePosition();
    if (pos != null) {
      _position = pos;
      
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null && user.role == UserRole.technician) {
        await ref.read(technicianRepositoryProvider).updateLocation(
          user.uid,
          pos.latitude,
          pos.longitude,
        );
      }
      
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _fetch());
    }
  }

  Future<void> filterBySkill(String skill) async {
    _skill = skill;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<void> setMinRating(double rating) async {
    _minRating = rating;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<void> sortBy(TechnicianSort sort) async {
    _sort = sort;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Ưu tiên tìm kiếm trong Mock Data để bạn chụp ảnh báo cáo
      final mockData = await _fetch();
      if (query.isEmpty) return mockData;

      final results = mockData.where((tech) {
        final searchString = '${tech.name} ${tech.skills.join(' ')}'.toLowerCase();
        return searchString.contains(query.toLowerCase());
      }).toList();

      if (results.isNotEmpty) return results;

      // Nếu không có trong Mock mới tìm trong DB thật
      final dbResults = await ref.read(technicianRepositoryProvider).searchTechnicians(query);
      return dbResults;
    });
  }

  Future<void> refresh() async {
    _position = null;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }
}

@riverpod
Future<TechnicianModel?> technicianDetail(Ref ref, String techId) async {
  // Ưu tiên trả về dữ liệu mẫu nếu ID bắt đầu bằng 'tech_'
  if (techId.startsWith('tech_')) {
    final mockTechs = await ref.read(techniciansNotifierProvider.notifier).build();
    try {
      return mockTechs.firstWhere((t) => t.uid == techId);
    } catch (_) {
      return null;
    }
  }
  
  return ref.watch(technicianRepositoryProvider).getTechnicianById(techId);
}
