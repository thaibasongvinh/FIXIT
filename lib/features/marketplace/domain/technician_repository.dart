import 'models/technician_model.dart';

abstract class TechnicianRepository {
  Future<List<TechnicianModel>> getTechnicians({
    String? skill,
    bool? isAvailable,
    int limit = 20,
  });
  Future<TechnicianModel?> getTechnicianById(String uid);
  Future<List<TechnicianModel>> searchTechnicians(String query);
  Future<void> updateAvailability(String uid, bool available);
  Future<void> updateLocation(String uid, double lat, double lng);
}
