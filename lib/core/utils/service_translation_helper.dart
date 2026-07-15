import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

extension ServiceTranslationExtension on String {
  /// Dịch nội dung từ Database sang ngôn ngữ hiện tại của App.
  /// Hỗ trợ cả Key chuẩn hóa (ưu tiên) và Mapping thủ công (dự phòng).
  String translateService(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return this;

    // 1. KIỂM TRA KEY CHUẨN HÓA (Dành cho việc nhập Key trên DB)
    final Map<String, String> keyMap = {
      // Banners
      'banner_quality_work_title': l10n.banner_quality_work_title,
      'banner_quality_work_desc': l10n.banner_quality_work_desc,
      'banner_fast_repair_title': l10n.banner_fast_repair_title,
      'banner_fast_repair_desc': l10n.banner_fast_repair_desc,
      
      // Main Services (Categories)
      'svc_plumbers': l10n.svc_plumbers,
      'svc_electric_work': l10n.svc_electric_work,
      'svc_solars': l10n.svc_solars,
      'svc_ac_ventilation': l10n.svc_ac_ventilation,
      'svc_car_washer': l10n.svc_car_washer,
      'svc_laundry': l10n.svc_laundry,
      'svc_paintings': l10n.svc_paintings,
      'svc_floorings': l10n.svc_floorings,
      'svc_cameras': l10n.svc_cameras,
      'svc_locksmiths': l10n.svc_locksmiths,
      'svc_cleaning': l10n.svc_cleaning,
      'svc_security': l10n.svc_security,
      'svc_mover': l10n.svc_mover,
      'svc_carpenter': l10n.svc_carpenter,

      // Sub Services (Dịch vụ con)
      'sub_car_wash': l10n.sub_car_wash,
      'sub_car_waxing': l10n.sub_car_waxing,
      'sub_oil_change': l10n.sub_oil_change,
      'sub_car_battery': l10n.sub_car_battery,
      'sub_interior_cleaning': l10n.sub_interior_cleaning,
      'sub_tire_repair': l10n.sub_tire_repair,
      'sub_wiring_install': l10n.sub_wiring_install,
      'sub_electrical_repairs': l10n.sub_electrical_repairs,
      'sub_lighting_install': l10n.sub_lighting_install,
      'sub_fixture_install': l10n.sub_fixture_install,
      'sub_house_cleaning': l10n.sub_house_cleaning,
      'sub_office_cleaning': l10n.sub_office_cleaning,
      'sub_deep_cleaning': l10n.sub_deep_cleaning,
      'sub_kitchen_cleaning': l10n.sub_kitchen_cleaning,
      'sub_ac_repairing': l10n.sub_ac_repairing,
      'sub_ac_installation': l10n.sub_ac_installation,
      'sub_ac_uninstallation': l10n.sub_ac_uninstallation,
      'sub_ac_service': l10n.sub_ac_service,
      'sub_pipe_leakage': l10n.sub_pipe_leakage,
      'sub_tap_repair': l10n.sub_tap_repair,
      'sub_toilet_repair': l10n.sub_toilet_repair,
      'sub_drain_cleaning': l10n.sub_drain_cleaning,
      'sub_plumber': l10n.sub_plumber,
      'sub_pipe_wrench': l10n.sub_pipe_wrench,
      'sub_water_tap': l10n.sub_water_tap,
      'sub_plier': l10n.sub_plier,
      'sub_multimeter': l10n.sub_multimeter,
      'sub_electricity_meter': l10n.sub_electricity_meter,
      'sub_drill': l10n.sub_drill,
      'sub_solar_panel': l10n.sub_solar_panel,
      'sub_cctv_install': l10n.sub_cctv_install,
      'sub_alarm_system': l10n.sub_alarm_system,
      'sub_lock_repair': l10n.sub_lock_repair,
      'sub_biometric_access': l10n.sub_biometric_access,
      'sub_house_moving': l10n.sub_house_moving,
      'sub_office_moving': l10n.sub_office_moving,
      'sub_furniture_moving': l10n.sub_furniture_moving,
      'sub_local_moving': l10n.sub_local_moving,
      'sub_furniture_repair': l10n.sub_furniture_repair,
      'sub_door_installation': l10n.sub_door_installation,
      'sub_cabinet_repair': l10n.sub_cabinet_repair,
      'sub_wood_polishing': l10n.sub_wood_polishing,
      'sub_house_painting': l10n.sub_house_painting,
      'sub_exterior_painting': l10n.sub_exterior_painting,
      'sub_interior_painting': l10n.sub_interior_painting,
      'sub_wall_stenciling': l10n.sub_wall_stenciling,
    };

    if (keyMap.containsKey(this)) return keyMap[this]!;

    // 2. MAPPING THỦ CÔNG (Dự phòng cho DB cũ là Tiếng Anh thô)
    final String normalized = toLowerCase().trim();
    final Map<String, String> legacyMap = {
      'plumbers': l10n.svc_plumbers,
      'electric work': l10n.svc_electric_work,
      'car washer': l10n.svc_car_washer,
      'car wash': l10n.sub_car_wash,
      'oil change': l10n.sub_oil_change,
      'quality work': l10n.banner_quality_work_title,
      'fast repair': l10n.banner_fast_repair_title,
      'expert support': l10n.expertSupport,
    };

    return legacyMap[normalized] ?? this;
  }
}
