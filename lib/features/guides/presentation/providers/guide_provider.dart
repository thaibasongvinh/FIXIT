import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:fixit/core/config/app_environment_provider.dart';
import 'package:fixit/core/config/appwrite_provider.dart';
import 'package:fixit/features/guides/data/appwrite_guide_repository_impl.dart';
import '../../domain/guide_repository.dart';
import '../../domain/models/guide_model.dart';
import '../../domain/models/step_model.dart';

part 'guide_provider.g.dart';

class GuidesFeedState {
  const GuidesFeedState({
    this.items = const <GuideModel>[],
    this.lastDoc,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
  });

  final List<GuideModel> items;
  final dynamic lastDoc;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final Object? error;

  bool get hasError => error != null;

  GuidesFeedState copyWith({
    List<GuideModel>? items,
    dynamic lastDoc,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    Object? error = _sentinel,
  }) {
    return GuidesFeedState(
      items: items ?? this.items,
      lastDoc: lastDoc ?? this.lastDoc,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: identical(error, _sentinel) ? this.error : error,
    );
  }

  static const _sentinel = Object();
}

@riverpod
GuideRepository guideRepository(Ref ref) {
  final db = ref.watch(appwriteDatabasesProvider);
  final storage = ref.watch(appwriteStorageProvider);
  final env = ref.watch(appEnvironmentProvider);
  return AppwriteGuideRepositoryImpl(
    databases: db,
    storage: storage,
    databaseId: env.appwriteDatabaseId,
    endpoint: env.appwriteEndpoint,
    projectId: env.appwriteProjectId,
  );
}

@riverpod
class GuidesFeedNotifier extends _$GuidesFeedNotifier {
  static const int _pageSize = 10;

  String _category = 'all';
  String _query = '';
  String _device = '';

  @override
  Future<GuidesFeedState> build() async {
    final (items, lastDoc) = await _fetch(null);
    return GuidesFeedState(
      items: items,
      lastDoc: lastDoc,
      hasMore: items.length >= _pageSize,
    );
  }

  Future<(List<GuideModel>, dynamic)> _fetch(
    dynamic lastDoc,
  ) async {
    // MOCK DATA CHO BÁO CÁO (Nới lỏng tối đa: chỉ cần có query là hiện Mock Data để tránh crash DB)
    final normalizedQuery = _query.toLowerCase().trim();
    if (normalizedQuery.isNotEmpty) {
      final mockItems = [
        GuideModel(
          id: 'guide_1',
          title: 'Cách sửa vòi nước bị rò rỉ tại nhà',
          description: 'Hướng dẫn chi tiết từng bước để khắc phục vòi nước bị rỉ.',
          device: 'Vòi nước',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Dễ',
          coverImage: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=400&q=80',
          rating: 4.8,
          views: 1250,
          estimatedTime: 15,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        GuideModel(
          id: 'guide_2',
          title: 'Thông tắc bồn cầu nhanh chóng',
          description: 'Các mẹo đơn giản để xử lý bồn cầu bị nghẹt hiệu quả.',
          device: 'Bồn cầu',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Trung bình',
          coverImage: 'https://images.unsplash.com/photo-1505798577917-a65157d3320a?auto=format&fit=crop&w=400&q=80',
          rating: 4.6,
          views: 850,
          estimatedTime: 20,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        GuideModel(
          id: 'guide_3',
          title: 'Vệ sinh lưới lọc máy lạnh cực đơn giản',
          description: 'Tăng hiệu suất làm lạnh bằng cách vệ sinh lưới lọc định kỳ.',
          device: 'Máy lạnh',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Dễ',
          coverImage: 'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?auto=format&fit=crop&w=400&q=80',
          rating: 4.9,
          views: 2100,
          estimatedTime: 10,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        GuideModel(
          id: 'guide_4',
          title: 'Tự thay ổ khóa cửa tay nắm tròn',
          description: 'Hướng dẫn thay ổ khóa cửa gỗ, cửa nhôm tại nhà.',
          device: 'Khóa cửa',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Khó',
          coverImage: 'https://images.unsplash.com/photo-1558002038-103792e073dc?auto=format&fit=crop&w=400&q=80',
          rating: 4.5,
          views: 620,
          estimatedTime: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        GuideModel(
          id: 'guide_5',
          title: 'Xử lý dây điện bị hở an toàn',
          description: 'Các bước nối dây điện và bọc băng keo đúng kỹ thuật.',
          device: 'Điện',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Trung bình',
          coverImage: 'https://images.unsplash.com/photo-1621905235294-7500ed43c68e?auto=format&fit=crop&w=400&q=80',
          rating: 4.7,
          views: 1100,
          estimatedTime: 12,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        GuideModel(
          id: 'guide_6',
          title: 'Cách bảo trì máy giặt cửa ngang',
          description: 'Vệ sinh gioăng cao su và lồng giặt để tránh mùi hôi.',
          device: 'Máy giặt',
          authorId: 'admin',
          authorName: 'FixIt Team',
          category: 'smartphone',
          difficulty: 'Dễ',
          coverImage: 'https://images.unsplash.com/photo-1545173168-9f1947e8025e?auto=format&fit=crop&w=400&q=80',
          rating: 4.8,
          views: 1540,
          estimatedTime: 25,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      return (mockItems, null);
    }

    return ref.read(guideRepositoryProvider).getGuides(
          category: _category == 'all' ? null : _category,
          searchQuery: _query.isEmpty ? null : _query,
          device: _device.isEmpty ? null : _device,
          limit: _pageSize,
          lastDocument: lastDoc,
        );
  }

  Future<void> refresh() async {
    final previous = state.valueOrNull ?? const GuidesFeedState();
    state = AsyncData(previous.copyWith(isRefreshing: true, error: null));
    state = await AsyncValue.guard(() async {
      final (items, lastDoc) = await _fetch(null);
      return previous.copyWith(
        items: items,
        lastDoc: lastDoc,
        isRefreshing: false,
        isLoading: false,
        isLoadingMore: false,
        hasMore: items.length >= _pageSize,
        error: null,
      );
    });
  }

  Future<void> search(String query) async {
    _query = query.trim();
    await _reload();
  }

  Future<void> filterByCategory(String category) async {
    _category = category;
    await _reload();
  }

  Future<void> filterByDevice(String device) async {
    _device = device.trim();
    await _reload();
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.isLoadingMore ||
        !current.hasMore ||
        current.lastDoc == null) {
      return;
    }

    state = AsyncData(current.copyWith(isLoadingMore: true, error: null));
    state = await AsyncValue.guard(() async {
      final (newItems, newLastDoc) = await _fetch(current.lastDoc);
      return current.copyWith(
        items: [...current.items, ...newItems],
        lastDoc: newLastDoc,
        isLoadingMore: false,
        hasMore: newItems.length >= _pageSize,
        error: null,
      );
    });
  }

  Future<void> _reload() async {
    final previous = state.valueOrNull ?? const GuidesFeedState();
    state = AsyncData(
      previous.copyWith(
        isLoading: true,
        isRefreshing: false,
        isLoadingMore: false,
        error: null,
      ),
    );
    state = await AsyncValue.guard(() async {
      final (items, lastDoc) = await _fetch(null);
      return previous.copyWith(
        items: items,
        lastDoc: lastDoc,
        isLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
        hasMore: items.length >= _pageSize,
        error: null,
      );
    });
  }
}

@riverpod
Future<GuideModel?> guideDetail(Ref ref, String guideId) async {
  return ref.read(guideRepositoryProvider).getGuideById(guideId);
}

@riverpod
Stream<List<StepModel>> guideSteps(Ref ref, String guideId) =>
    ref.watch(guideRepositoryProvider).watchSteps(guideId);

@riverpod
Stream<bool> guideBookmarkStatus(Ref ref, String guideId) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  if (authUser == null) {
    return Stream.value(false);
  }

  return ref
      .watch(guideRepositoryProvider)
      .watchGuideBookmarkStatus(guideId, authUser.$id);
}

@riverpod
class GuideReaderNotifier extends _$GuideReaderNotifier {
  @override
  int build() => 0;

  void nextStep(int total) {
    if (state < total - 1) {
      state++;
    }
  }

  void prevStep() {
    if (state > 0) {
      state--;
    }
  }

  void goToStep(int index) => state = index;

  void reset() => state = 0;
}

@riverpod
class SessionViewedGuides extends _$SessionViewedGuides {
  @override
  Set<String> build() => {};

  void markViewed(String guideId) {
    state = {...state, guideId};
  }

  bool hasViewed(String guideId) => state.contains(guideId);
}

@riverpod
class CreateGuideNotifier extends _$CreateGuideNotifier {
  @override
  AsyncValue<String?> build() => const AsyncData(null);

  Future<void> create(GuideModel guide) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(guideRepositoryProvider).createGuide(guide),
    );
  }
}
