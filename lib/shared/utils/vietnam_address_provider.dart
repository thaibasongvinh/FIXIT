import 'dart:convert';
import 'package:flutter/services.dart';

class VietnamAddressProvider {
  static List<dynamic>? _data;

  /// Nạp dữ liệu từ JSON khi app khởi động
  static Future<void> loadData() async {
    if (_data != null) return;
    try {
      final String response = await rootBundle.loadString('assets/data/vietnam_provinces.json');
      _data = json.decode(response);
    } catch (e) {
      _data = [];
    }
  }

  static List<String> get provinces {
    if (_data == null) return [];
    // Lấy tên Tỉnh từ key "FullName"
    return _data!.map((item) => (item['FullName'] ?? '').toString()).where((e) => e.isNotEmpty).toList();
  }

  static List<String> getDistricts(String provinceName) {
    if (_data == null) return [];
    final province = _data!.firstWhere(
      (item) => item['FullName'] == provinceName,
      orElse: () => null,
    );
    
    // Trong kiểu JSON này, các đơn vị con thường nằm trực tiếp trong key "Wards" 
    // hoặc "Districts". Tôi sẽ ưu tiên lấy "Wards" như bạn yêu cầu.
    final children = (province?['Wards'] ?? province?['Districts'] ?? []) as List<dynamic>;
    
    if (children.isEmpty) return ['Khu vực trung tâm'];

    // Lấy FullName của đơn vị cấp 2
    return children.map((item) => (item['FullName'] ?? '').toString()).where((e) => e.isNotEmpty).toSet().toList();
  }

  static List<String> getWards(String provinceName, String districtName) {
    if (_data == null) return [];
    final province = _data!.firstWhere(
      (item) => item['FullName'] == provinceName,
      orElse: () => null,
    );
    
    if (province == null) return ['Phường/Xã trung tâm'];

    // Tìm trong danh sách con
    final children = (province['Wards'] ?? province['Districts'] ?? []) as List<dynamic>;
    
    final district = children.firstWhere(
      (item) => item['FullName'] == districtName,
      orElse: () => null,
    );

    // Nếu cấu trúc JSON của bạn có 3 cấp lồng nhau (Province -> Wards -> Wards)
    if (district != null && district['Wards'] != null) {
      final wards = district['Wards'] as List<dynamic>;
      return wards.map((item) => (item['FullName'] ?? '').toString()).toList();
    }

    // Nếu JSON chỉ có 2 cấp, ta trả về mặc định để không bị trống
    return ['Phường/Xã trung tâm'];
  }

  /// TÌM KIẾM THÔNG MINH (Suggestion #3)
  /// Tìm kiếm xuyên suốt Tỉnh, Quận, Phường và trả về danh sách đầy đủ
  static List<String> searchGlobal(String query) {
    if (_data == null || query.length < 2) return [];
    final String q = query.toLowerCase().trim();
    final List<String> results = [];

    for (var province in _data!) {
      final String pName = (province['FullName'] ?? '').toString();
      final districts = (province['Wards'] ?? province['Districts'] ?? []) as List<dynamic>;

      for (var district in districts) {
        final String dName = (district['FullName'] ?? '').toString();
        final wards = (district['Wards'] ?? []) as List<dynamic>;

        if (wards.isEmpty) {
          // Chỉ có 2 cấp
          if (pName.toLowerCase().contains(q) || dName.toLowerCase().contains(q)) {
            results.add("$dName, $pName");
          }
        } else {
          // Có 3 cấp
          for (var ward in wards) {
            final String wName = (ward['FullName'] ?? '').toString();
            if (wName.toLowerCase().contains(q) || 
                dName.toLowerCase().contains(q) || 
                pName.toLowerCase().contains(q)) {
              results.add("$wName, $dName, $pName");
            }
          }
        }
        if (results.length > 20) break; // Giới hạn để hiệu năng tốt
      }
      if (results.length > 20) break;
    }
    return results;
  }
}
