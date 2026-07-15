import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/home_category.dart';
import 'services_provider.dart';

part 'home_provider.g.dart';

@riverpod
Stream<List<HomeCategory>> popularServices(PopularServicesRef ref) {
  // We no longer use a separate 'popular_services' collection.
  // We delegate to allServicesProvider and filter for popular ones (ID starts with 'pop_').
  return ref.watch(allServicesProvider.stream).map(
        (services) => services.where((s) => s.id.startsWith('pop_')).toList(),
      );
}
