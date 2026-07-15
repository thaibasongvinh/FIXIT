import '../../../guides/domain/models/guide_model.dart';
import '../../../marketplace/domain/models/technician_model.dart';

class Phase5SearchResult {
  const Phase5SearchResult({
    required this.guides,
    required this.technicians,
    required this.source,
  });

  final List<GuideModel> guides;
  final List<TechnicianModel> technicians;
  final String source;

  bool get isEmpty => guides.isEmpty && technicians.isEmpty;

  factory Phase5SearchResult.empty() => const Phase5SearchResult(
        guides: [],
        technicians: [],
        source: 'empty',
      );
}
