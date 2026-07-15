import 'package:fixit/shared/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:fixit/core/services/image_service.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fixit/features/auth/presentation/widgets/figma_auth_widgets.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/home/presentation/providers/home_provider.dart';
import 'package:fixit/l10n/app_localizations.dart';
import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/logout_dialog.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/shared/utils/vietnam_address_provider.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import 'package:fixit/shared/utils/image_utils.dart';
import 'package:fixit/core/config/dio_provider.dart';
import 'package:fixit/core/utils/service_translation_helper.dart';

class TechnicianOnboardingScreen extends ConsumerStatefulWidget {
  const TechnicianOnboardingScreen({super.key});

  @override
  ConsumerState<TechnicianOnboardingScreen> createState() =>
      _TechnicianOnboardingScreenState();
}

class _TechnicianOnboardingScreenState extends ConsumerState<TechnicianOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSubSteps = 8;

  // Controllers
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController(text: '08:00');
  final TextEditingController _endTimeController = TextEditingController(text: '18:00');
  final TextEditingController _serviceAreaController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accNumberController = TextEditingController();
  final TextEditingController _accHolderController = TextEditingController();
  final TextEditingController _bankPhoneController = TextEditingController();
  final TextEditingController _industryTypeController = TextEditingController();
  final TextEditingController _fixRateController = TextEditingController();
  final TextEditingController _identityNumberController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController(text: '1');
  final TextEditingController _businessAddressController = TextEditingController();
  String? _selectedSchedule;

  final List<String> _selectedProfessions = [];
  final List<String> _selectedServiceAreas = [];
  final List<String> _toolImagePaths = [];
  final List<String> _certImagePaths = [];
  final List<String> _selectedPaymentMethods = ['bankTransfer'];
  double _serviceRadius = 10.0;
  String? _frontIdPath;
  String? _backIdPath;
  Position? _currentPosition;

  Future<void> _handlePositionCaptured(Position pos) async {
    setState(() {
      _currentPosition = pos;
    });

    try {
      debugPrint("DEBUG: Bắt đầu nhận diện địa chỉ cho tọa độ: ${pos.latitude}, ${pos.longitude}");
      
      // 1. Giải mã địa lý ngược (Reverse Geocoding)
      final List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        debugPrint("DEBUG: Đã tìm thấy địa chỉ: ${place.toString()}");
        
        // 2. Cấu trúc địa chỉ thân thiện
        final List<String> addressParts = [];
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) addressParts.add(place.subAdministrativeArea!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);

        final String autoAddress = addressParts.join(', ');

        if (autoAddress.isNotEmpty) {
          setState(() {
            if (!_selectedServiceAreas.contains(autoAddress)) {
              _selectedServiceAreas.add(autoAddress);
            }
          });
          
          // Đã xóa AppSnackbar.showSuccess tại đây theo yêu cầu
        }
      } else {
        debugPrint("DEBUG: Không tìm thấy thông tin địa chỉ cho tọa độ này.");
      }
    } catch (e) {
      debugPrint("DEBUG: Lỗi Geocoding (Thường gặp trên máy ảo): $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedSchedule = 'allWeek';
  }

  @override
  void dispose() {
    _pageController.dispose();
    _professionController.dispose();
    _aboutMeController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _serviceAreaController.dispose();
    _bankNameController.dispose();
    _accNumberController.dispose();
    _accHolderController.dispose();
    _bankPhoneController.dispose();
    _industryTypeController.dispose();
    _fixRateController.dispose();
    _identityNumberController.dispose();
    super.dispose();
  }

  bool _isCheckingAccount = false;
  String? _bankLogoUrl;

  Future<void> _lookupBankAccount() async {
    final String accNum = _accNumberController.text.trim();
    final String bankName = _bankNameController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (accNum.isEmpty || bankName.isEmpty) return;

    setState(() {
      _isCheckingAccount = true;
      _bankLogoUrl = null;
    });

    try {
      final Map<String, Map<String, String>> bankData = {
        'Vietcombank': {'bin': '970436', 'logo': 'https://api.vietqr.io/img/VCB.png'},
        'BIDV': {'bin': '970418', 'logo': 'https://api.vietqr.io/img/BIDV.png'},
        'VietinBank': {'bin': '970415', 'logo': 'https://api.vietqr.io/img/ICB.png'},
        'Agribank': {'bin': '970405', 'logo': 'https://api.vietqr.io/img/VBA.png'},
        'MBBank': {'bin': '970422', 'logo': 'https://api.vietqr.io/img/MB.png'},
        'Techcombank': {'bin': '970407', 'logo': 'https://api.vietqr.io/img/TCB.png'},
        'VPBank': {'bin': '970432', 'logo': 'https://api.vietqr.io/img/VPB.png'},
        'ACB': {'bin': '970416', 'logo': 'https://api.vietqr.io/img/ACB.png'},
        'TPBank': {'bin': '970423', 'logo': 'https://api.vietqr.io/img/TPB.png'},
        'VIB': {'bin': '970441', 'logo': 'https://api.vietqr.io/img/VIB.png'},
        'Sacombank': {'bin': '970403', 'logo': 'https://api.vietqr.io/img/STB.png'},
        'HDBank': {'bin': '970437', 'logo': 'https://api.vietqr.io/img/HDB.png'},
        'Eximbank': {'bin': '970431', 'logo': 'https://api.vietqr.io/img/EIB.png'},
        'MSB': {'bin': '970426', 'logo': 'https://api.vietqr.io/img/MSB.png'},
        'SeABank': {'bin': '970440', 'logo': 'https://api.vietqr.io/img/SEA.png'},
        'OCB': {'bin': '970448', 'logo': 'https://api.vietqr.io/img/OCB.png'},
      };

      final data = bankData[bankName];
      if (data == null) {
        setState(() => _isCheckingAccount = false);
        return;
      }

      final dio = ref.read(dioProvider); // Sử dụng Dio Provider đã cấu hình bảo mật
      
      final response = await dio.post(
        'https://api.vietqr.io/v2/lookup',
        data: {
          'bin': data['bin'],
          'accountNumber': accNum,
        },
      );

      if (response.data['code'] == '00') {
        final String accountName = response.data['data']['accountName'];
        setState(() {
          _accHolderController.text = accountName;
          _bankLogoUrl = data['logo'];
        });
        if (mounted) AppSnackbar.showSuccess(context, l10n.verifiedAccount);
      } else {
        final desc = response.data['desc'] ?? l10n.errorUnknown;
        if (mounted) AppSnackbar.showError(context, desc);
      }
    } catch (e) {
      String errorMsg = l10n.errorNetwork;
      if (mounted) AppSnackbar.showError(context, errorMsg);
    } finally {
      setState(() => _isCheckingAccount = false);
    }
  }

  Future<void> _showAreaPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    // GỢI Ý SỐ 3: Smart Address Autocomplete
    final String? result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SmartAddressPicker(l10n: l10n),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        if (!_selectedServiceAreas.contains(result)) {
          _selectedServiceAreas.add(result);
        }
      });
      return;
    }

    // Nếu không tìm thấy kết quả từ Smart Search, chạy luồng 3 bước truyền thống (Dự phòng)
    String? city;
    String? district;
    String? ward;
    int currentStep = 0;

    while (currentStep < 3 && currentStep >= 0) {
      if (!mounted) return;
      if (currentStep == 0) {
        city = await _showFuturisticPicker(
          context: context,
          title: l10n.selectCity,
          items: VietnamAddressProvider.provinces,
          showSearch: true,
          showBack: false,
        );
        if (city == null) return; 
        currentStep++;
      } else if (currentStep == 1) {
        district = await _showFuturisticPicker(
          context: context,
          title: l10n.selectDistrict,
          items: VietnamAddressProvider.getDistricts(city!),
          showSearch: true,
          showBack: true,
        );
        if (district == null) return;
        if (district == "__BACK__") {
          currentStep--;
        } else {
          currentStep++;
        }
      } else if (currentStep == 2) {
        ward = await _showFuturisticPicker(
          context: context,
          title: l10n.selectWard,
          items: VietnamAddressProvider.getWards(city!, district!),
          showSearch: true,
          showBack: true,
        );
        if (ward == null) return;
        if (ward == "__BACK__") {
          currentStep--;
        } else {
          currentStep++;
        }
      }
    }

    if (city != null && district != null && ward != null) {
      setState(() {
        _selectedServiceAreas.add("$ward, $district, $city");
      });
    }
  }

  Future<String?> _showFuturisticPicker({
    required BuildContext context,
    required String title,
    required List<String> items,
    bool showSearch = false,
    bool showBack = false,
  }) async {
    String internalSearch = '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.sizeOf(context).height * 0.8,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F2E).withOpacity(0.95) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              const Gap(12),
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2))),
              const Gap(12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (showBack)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context, "__BACK__"),
                          icon: Icon(Icons.arrow_back_ios_new_rounded, 
                            color: isDark ? Colors.white : Colors.blueGrey, 
                            size: 20
                          ),
                        ),
                      ),
                    Text(title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.blueGrey.shade900
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(12),
              if (showSearch)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (v) => setModalState(() => internalSearch = v),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm nhanh...',
                      hintStyle: TextStyle(color: isDark ? Colors.white.withOpacity(0.3) : Colors.black26),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: isDark ? Colors.white : Colors.blueGrey),
                      filled: true,
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              const Divider(color: Colors.white10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items
                      .where((i) => i
                          .toLowerCase()
                          .contains(internalSearch.toLowerCase()))
                      .length,
                  itemBuilder: (context, index) {
                    final filteredItems = items
                        .where((i) => i
                            .toLowerCase()
                            .contains(internalSearch.toLowerCase()))
                        .toList();
                    return ListTile(
                      title: Text(filteredItems[index],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.blueGrey.shade800)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: Colors.white24),
                      onTap: () => Navigator.pop(context, filteredItems[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: _isSubmitting,
                child: Column(
                  children: [
                    _buildHeader(isDark),
                    _buildProgressBar(),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _LocationIntroStep(
                            onNext: _nextPage, 
                            l10n: l10n, 
                            isDark: isDark,
                            onPositionCaptured: _handlePositionCaptured,
                          ),
                          _ServiceOfferStep(
                            onNext: _nextPage,
                            selectedProfs: _selectedProfessions,
                            onProfChanged: (list) => setState(() {
                              _selectedProfessions.clear();
                              _selectedProfessions.addAll(list);
                            }),
                            aboutCtrl: _aboutMeController,
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _WorkingHoursStep(
                            onNext: _nextPage,
                            startCtrl: _startTimeController,
                            endCtrl: _endTimeController,
                            serviceAreas: _selectedServiceAreas,
                            onAddArea: () => _showAreaPicker(context),
                            onRemoveArea: (idx) => setState(() => _selectedServiceAreas.removeAt(idx)),
                            radius: _serviceRadius,
                            onRadiusChanged: (v) => setState(() => _serviceRadius = v),
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _IdentityVerificationStep(
                            onNext: _nextPage, 
                            idCtrl: _identityNumberController, 
                            onFront: (p) => setState(() => _frontIdPath = p), 
                            onBack: (p) => setState(() => _backIdPath = p), 
                            front: _frontIdPath, 
                            back: _backIdPath, 
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _ToolCheckStep(
                            onNext: _nextPage,
                            toolPaths: _toolImagePaths,
                            certPaths: _certImagePaths,
                            onAddTool: (path) => setState(() => _toolImagePaths.add(path)),
                            onRemoveTool: (index) => setState(() => _toolImagePaths.removeAt(index)),
                            onAddCert: (path) => setState(() => _certImagePaths.add(path)),
                            onRemoveCert: (index) => setState(() => _certImagePaths.removeAt(index)),
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _PaymentMethodStep(
                            onNext: _nextPage,
                            selected: _selectedPaymentMethods,
                            onChanged: (method) => setState(() {
                              if (_selectedPaymentMethods.contains(method)) {
                                if (_selectedPaymentMethods.length > 1) {
                                  _selectedPaymentMethods.remove(method);
                                }
                              } else {
                                _selectedPaymentMethods.add(method);
                              }
                            }),
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _BankDetailsStep(
                            onNext: _nextPage,
                            bankCtrl: _bankNameController,
                            numCtrl: _accNumberController,
                            holdCtrl: _accHolderController,
                            phoneCtrl: _bankPhoneController,
                            isLoading: _isCheckingAccount,
                            bankLogoUrl: _bankLogoUrl,
                            onAccountNumChanged: (v) {
                              if (v.length >= 8) _lookupBankAccount();
                            },
                            onSelectBank: () async {
                              final List<String> viedtnamBanks = [
                                'Vietcombank', 'BIDV', 'VietinBank', 'Agribank', 'MBBank', 'Techcombank',
                                'VPBank', 'ACB', 'TPBank', 'VIB', 'Sacombank', 'HDBank', 'Eximbank',
                                'MSB', 'SeABank', 'OCB',
                              ];
                              final selected = await _showFuturisticPicker(
                                context: context,
                                title: l10n.selectBank,
                                items: viedtnamBanks,
                                showSearch: true,
                                showBack: false,
                              );
                              if (selected != null) {
                                setState(() => _bankNameController.text = selected);
                                _lookupBankAccount();
                              }
                            },
                            l10n: l10n,
                            isDark: isDark,
                          ),
                          _BillingDetailsStep(
                            onComplete: _finishOnboarding,
                            indusCtrl: _industryTypeController,
                            rateCtrl: _fixRateController,
                            expCtrl: _experienceController,
                            addressCtrl: _businessAddressController,
                            selectedSchedule: _selectedSchedule!,
                            onScheduleChanged: (v) => setState(() => _selectedSchedule = v),
                            isSubmitting: _isSubmitting,
                            l10n: l10n,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSubmitting)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.15),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.cyanAccent.withOpacity(0.3)),
                                ),
                              ),
                              const SizedBox(
                                width: 64,
                                height: 64,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                                ),
                              ),
                              Icon(Icons.security_rounded,
                                  color: Colors.cyanAccent.withOpacity(0.8),
                                  size: 32),
                            ],
                          ),
                          const Gap(32),
                          Text(
                            _submissionStatus.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                fontSize: 14,
                                shadows: [
                                  Shadow(
                                      color: Colors.cyanAccent, blurRadius: 15)
                                ]),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Text(
                              l10n.encryptingProfile,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Stack(
        children: [
          Container(
            height: 4, width: double.infinity,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(2)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 4,
            width: MediaQuery.of(context).size.width * ((_currentStep + 1) / _totalSubSteps),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.cyanAccent]),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 8)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: isDark ? Colors.white : Colors.blueGrey, size: 20),
            onPressed: () {
              HapticFeedback.selectionClick();
              if (_currentStep > 0) {
                _prevPage();
              } else {
                _showExitOnboardingDialog();
              }
            },
          ),
          Image.asset('assets/images/app_icon.png', height: 40),
          IconButton(
            icon: Icon(Icons.logout_rounded,
                color: isDark ? Colors.white70 : Colors.blueGrey, size: 22),
            onPressed: () {
              HapticFeedback.mediumImpact();
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showExitOnboardingDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color(0xFF1A1F2E).withOpacity(0.9) 
                  : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 32),
                ),
                const Gap(24),
                Text(
                  "Dừng đăng ký thợ?", 
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1A1F2E),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  "Thông tin bạn đã nhập sẽ không được lưu. Bạn có muốn quay lại chọn Khách hàng không?", 
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Đóng dialog

                          setState(() {
                            _isSubmitting = true;
                            _submissionStatus = "Đang hủy đăng ký...";
                          });

                          try {
                            // Reset role về none để Router cho phép ở lại trang RoleSelectionScreen
                            await ref.read(authNotifierProvider.notifier).updateRole(UserRole.none);
                            
                            if (context.mounted) {
                              context.go(AppRoutes.roleSelection);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              AppSnackbar.showError(context, "Lỗi: $e");
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isSubmitting = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.blueAccent.withOpacity(0.3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("XÁC NHẬN DỪNG", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                    ),
                    const Gap(12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Ở LẠI TIẾP TỤC", 
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey.shade400,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: () {
          Navigator.pop(context);
          ref.read(authNotifierProvider.notifier).signOut();
        },
      ),
    );
  }

  void _nextPage() {
    if (_currentStep < _totalSubSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic);
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic);
    }
  }

  bool _isSubmitting = false;
  String _submissionStatus = "";

  void _finishOnboarding() async {
    if (_isSubmitting) return;
    
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isSubmitting = true;
      _submissionStatus = l10n.encryptingProfile;
    });

    final notifier = ref.read(authNotifierProvider.notifier);
    
    try {
      // 1. Giai đoạn nén ảnh - TỐI ƯU: Nén song song để tăng tốc
      setState(() => _submissionStatus = l10n.optimizingImages);
      
      final results = await Future.wait([
        ImageUtils.compressImages(_toolImagePaths),
        ImageUtils.compressImages(_certImagePaths),
        _frontIdPath != null ? ImageUtils.compressImage(_frontIdPath!) : Future.value(null),
        _backIdPath != null ? ImageUtils.compressImage(_backIdPath!) : Future.value(null),
      ]);

      final compressedTools = results[0] as List<String>;
      final compressedCerts = results[1] as List<String>;
      final compressedFront = (results[2] as File?)?.path;
      final compressedBack = (results[3] as File?)?.path;

      // 2. Giai đoạn upload
      setState(() => _submissionStatus = l10n.submittingApplication);

      await notifier.submitTechnicianOnboarding(
        businessName: _industryTypeController.text,
        businessAddress: _businessAddressController.text.isNotEmpty 
            ? _businessAddressController.text 
            : (_selectedServiceAreas.isNotEmpty ? _selectedServiceAreas.first : ""),
        serviceType: _selectedProfessions.join(', '),
        experienceYears: int.tryParse(_experienceController.text) ?? 1,
        serviceArea: _selectedServiceAreas.join('; '),
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        hourlyRate: double.tryParse(_fixRateController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
        flatFee: 0.0,
        additionalInfo: _aboutMeController.text,
        localDocumentPaths: [...compressedTools, ...compressedCerts],
        identityNumber: _identityNumberController.text,
        identityCardFrontPath: compressedFront,
        identityCardBackPath: compressedBack,
        serviceRadius: _serviceRadius,
        workSchedule: _selectedSchedule,
        paymentMethods: _selectedPaymentMethods,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );
      
      if (mounted) {
        _showSuccessDialog(l10n);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, '${l10n.error}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSuccessDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: const Color(0xFF0D47A1).withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(Icons.check_circle_rounded,
                        size: 80, color: Colors.greenAccent),
                  ],
                ),
                const Gap(24),
                Text(
                  l10n.applicationSentSuccess,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                Text(
                  l10n.applicationSentDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                const Gap(40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.go(AppRoutes.pendingApproval);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: Text(l10n.finish.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SUB-STEPS WIDGETS ---

class _LocationIntroStep extends StatefulWidget {
  final VoidCallback onNext;
  final AppLocalizations l10n;
  final bool isDark;
  final Function(Position) onPositionCaptured;
  const _LocationIntroStep({required this.onNext, required this.l10n, required this.isDark, required this.onPositionCaptured});

  @override
  State<_LocationIntroStep> createState() => _LocationIntroStepState();
}

class _LocationIntroStepState extends State<_LocationIntroStep> {
  bool _isRequesting = false;
  bool _isSuccess = false;

  Future<void> _requestPermission(BuildContext context) async {
    if (_isRequesting || _isSuccess) return;
    setState(() => _isRequesting = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          AppSnackbar.showWarning(context, widget.l10n.gpsOff);
        }
        setState(() => _isRequesting = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF0D47A1),
              title: Text(widget.l10n.locationPermissionBlocked,
                  style: const TextStyle(color: Colors.white)),
              content: Text(widget.l10n.locationPermissionBlockedDesc,
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(widget.l10n.maybeLater,
                        style: const TextStyle(color: Colors.white38))),
                ElevatedButton(
                  onPressed: () => Geolocator.openAppSettings(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue),
                  child: Text(widget.l10n.openSettings),
                ),
              ],
            ),
          );
        }
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition();
        
        setState(() {
          _isSuccess = true;
          _isRequesting = false;
        });

        // Hiển thị hiệu ứng thành công trong 1 khoảng ngắn rồi mới chuyển trang
        await Future.delayed(const Duration(milliseconds: 800));
        
        if (mounted) {
          widget.onPositionCaptured(pos);
          widget.onNext();
        }
      } else {
        if (context.mounted) {
          AppSnackbar.showWarning(context, widget.l10n.needLocationPermission);
        }
      }
    } catch (e) {
      debugPrint("DEBUG: Lỗi khi xin quyền: $e");
    } finally {
      if (mounted && !_isSuccess) setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: widget.l10n.enableLocationDesc,
      isDark: widget.isDark,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: widget.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          'assets/animations/location_radar.json', // Bạn cần thêm file này vào assets
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _RadarAnimation(isDark: widget.isDark), // Fallback nếu chưa có file
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: _isSuccess 
                              ? Colors.greenAccent.withOpacity(0.1) 
                              : Colors.blueAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _isSuccess 
                                  ? Colors.greenAccent.withOpacity(0.2) 
                                  : Colors.blueAccent.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 50,
                            )
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _isSuccess ? Icons.check_circle_rounded : Icons.explore_rounded,
                            key: ValueKey(_isSuccess),
                            size: 80, 
                            color: _isSuccess ? Colors.greenAccent : Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(32),
                  Text(widget.l10n.fastConnection,
                      style: TextStyle(
                          color: widget.isDark ? Colors.white70 : Colors.blueGrey.shade800,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          fontSize: 14)),
                  const Gap(8),
                  Text(widget.l10n.autoSearchRange,
                      style: TextStyle(
                          color: widget.isDark ? Colors.white.withOpacity(0.3) : Colors.blueGrey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const Gap(40),
          _FuturisticButton(
            text: _isSuccess 
                ? "ĐÃ KẾT NỐI THÀNH CÔNG"
                : (_isRequesting ? "ĐANG TÌM VỊ TRÍ HIỆN TẠI" : widget.l10n.allowMapAccess),
            onTap: () {
              if (_isSuccess) return;
              HapticFeedback.mediumImpact();
              _requestPermission(context);
            },
            isDark: widget.isDark,
          ),
          const Gap(12),
          TextButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              AppSnackbar.showWarning(context, widget.l10n.locationCanBeAddedLater);
              widget.onNext();
            },
            child: Text(widget.l10n.maybeLater, style: TextStyle(color: widget.isDark ? Colors.white38 : Colors.blueGrey.shade300)),
          ),
        ],
      ),
    );
  }
}

class _RadarAnimation extends StatefulWidget {
  final bool isDark;
  const _RadarAnimation({required this.isDark});
  @override
  State<_RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<_RadarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildCircle(1.0 - _controller.value),
            _buildCircle(0.7 - _controller.value),
            _buildCircle(0.4 - _controller.value),
          ],
        );
      },
    );
  }

  Widget _buildCircle(double value) {
    if (value < 0) value += 1.0;
    return Container(
      width: 200 * value,
      height: 200 * value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: (widget.isDark ? Colors.blueAccent : Colors.cyan).withOpacity(value * 0.2)),
      ),
    );
  }
}

class _ServiceOfferStep extends ConsumerWidget {
  final VoidCallback onNext;
  final List<String> selectedProfs;
  final Function(List<String>) onProfChanged;
  final TextEditingController aboutCtrl;
  final AppLocalizations l10n;
  final bool isDark;
  const _ServiceOfferStep({
    required this.onNext,
    required this.selectedProfs,
    required this.onProfChanged,
    required this.aboutCtrl,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularServicesAsync = ref.watch(popularServicesProvider);

    return _StepWrapper(
      title: l10n.serviceOffer,
      isDark: isDark,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LabelText(l10n.whatIsYourSpecialty, isDark: isDark),
                  popularServicesAsync.when(
                    data: (categories) => AnimationLimiter(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: categories.map((cat) {
                            final isSelected = selectedProfs.contains(cat.title);
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                final newList = List<String>.from(selectedProfs);
                                if (selectedProfs.contains(cat.title)) {
                                  newList.remove(cat.title);
                                } else {
                                  newList.add(cat.title);
                                }
                                onProfChanged(newList);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xFF2196F3),
                                            const Color(0xFF00BCD4).withOpacity(0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.3)
                                        : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    if (isSelected)
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelected) ...[
                                      const Icon(Icons.check_circle_rounded,
                                          color: Colors.white, size: 18),
                                      const Gap(8),
                                    ],
                                    Text(
                                      cat.title.translateService(context),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.blueGrey),
                                        fontWeight: isSelected
                                            ? FontWeight.w900
                                            : FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(color: Colors.cyanAccent),
                      ),
                    ),
                    error: (e, __) => Center(
                      child: Column(
                        children: [
                          Icon(Icons.cloud_off_rounded, color: Colors.white24, size: 48),
                          const Gap(12),
                          Text("Không thể tải danh sách dịch vụ", style: TextStyle(color: Colors.white54)),
                          TextButton(
                            onPressed: () => ref.invalidate(popularServicesProvider),
                            child: Text("THỬ LẠI", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(32),
                  _LabelText(l10n.aboutMe, isDark: isDark),
                  _FuturisticTextField(
                    controller: aboutCtrl,
                    hint: l10n.aboutMeHint,
                    maxLines: 5,
                    icon: Icons.history_edu_rounded,
                    isDark: isDark,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
          const Gap(20),
          _FuturisticButton(
            text: l10n.next,
            onTap: () {
              if (selectedProfs.isEmpty) {
                AppSnackbar.showWarning(context, l10n.enterSpecialty);
                return;
              }
              if (aboutCtrl.text.trim().isEmpty) {
                AppSnackbar.showWarning(context, l10n.aboutMeHint);
                return;
              }
              onNext();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _WorkingHoursStep extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController startCtrl;
  final TextEditingController endCtrl;
  final List<String> serviceAreas;
  final VoidCallback onAddArea;
  final Function(int) onRemoveArea;
  final double radius;
  final ValueChanged<double> onRadiusChanged;
  final AppLocalizations l10n;
  final bool isDark;

  const _WorkingHoursStep(
      {required this.onNext,
      required this.startCtrl,
      required this.endCtrl,
      required this.serviceAreas,
      required this.onAddArea,
      required this.onRemoveArea,
      required this.radius,
      required this.onRadiusChanged,
      required this.l10n,
      required this.isDark});

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: isDark ? const Color(0xFF0D47A1) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      if (isStart) {
        startCtrl.text = formattedTime;
      } else {
        endCtrl.text = formattedTime;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.workingHoursAndRange,
      isDark: isDark,
      child: AnimationLimiter(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: startCtrl,
                        builder: (context, value, _) {
                          return _TimeCard(
                            label: l10n.from,
                            time: value.text,
                            onTap: () => _selectTime(context, true),
                            isDark: isDark,
                          );
                        }
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: endCtrl,
                        builder: (context, value, _) {
                          return _TimeCard(
                            label: l10n.to,
                            time: value.text,
                            onTap: () => _selectTime(context, false),
                            isDark: isDark,
                          );
                        }
                      ),
                    ),
                  ],
                ),
                const Gap(48),
                _LabelText(l10n.serviceRadius, isDark: isDark),
                const Gap(8),
                LayoutBuilder(builder: (context, constraints) {
                  // Cấu hình kích thước nhãn và khoảng đệm
                  const double labelWidth = 84.0;
                  // Padding thực tế của track Slider Material thường là 24 (mỗi bên)
                  const double sliderTrackPadding = 24.0; 
                  
                  // Chiều rộng khả dụng cho thumb di chuyển
                  final double trackWidth = constraints.maxWidth - (sliderTrackPadding * 2);
                  
                  // Tỷ lệ (0.0 -> 1.0)
                  final double ratio = (radius - 1) / (50 - 1);
                  
                  // Tọa độ X của tâm thumb
                  final double thumbCenterX = sliderTrackPadding + (ratio * trackWidth);

                  // Tính vị trí left của nhãn và giới hạn trong khung nhìn
                  final double leftPos = (thumbCenterX - (labelWidth / 2))
                      .clamp(0.0, constraints.maxWidth - labelWidth);

                  return Column(
                    children: [
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 100),
                              left: leftPos,
                              child: Container(
                                width: labelWidth,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Colors.blueAccent,
                                    Colors.cyanAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(120),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ],
                                ),
                                child: Text(
                                  "${radius.toInt()} km",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 8,
                          activeTrackColor: Colors.blueAccent,
                          inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
                          thumbColor: isDark ? Colors.white : Colors.blueAccent,
                          overlayColor: Colors.blueAccent.withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12),
                          trackShape: const RoundedRectSliderTrackShape(),
                        ),
                        child: Slider(
                          value: radius,
                          min: 1,
                          max: 50,
                          onChanged: onRadiusChanged,
                        ),
                      ),
                    ],
                  );
                }),
                const Gap(40),
                _LabelText(l10n.serviceArea, isDark: isDark),
                const Gap(8),
                if (serviceAreas.isEmpty)
                  _EmptyAreaCard(onTap: onAddArea, l10n: l10n, isDark: isDark)
                else
                  Column(
                    children: [
                      ...serviceAreas.asMap().entries.map((entry) => _AreaTile(
                            address: entry.value,
                            onDelete: () => onRemoveArea(entry.key),
                            isDark: isDark,
                          )),
                      const Gap(12),
                      _AddMoreButton(onTap: onAddArea, l10n: l10n, isDark: isDark),
                    ],
                  ),
                const Gap(40),
                _FuturisticButton(
                  text: l10n.next,
                  onTap: () {
                    if (serviceAreas.isEmpty) {
                      AppSnackbar.showWarning(context, l10n.tapToAddArea);
                      return;
                    }
                    onNext();
                  },
                  isDark: isDark,
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AreaTile extends StatelessWidget {
  final String address;
  final VoidCallback onDelete;
  final bool isDark;
  const _AreaTile({required this.address, required this.onDelete, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: Colors.blueAccent, size: 20),
          const Gap(16),
          Expanded(
            child: Text(
              address,
              style: TextStyle(color: isDark ? Colors.white : Colors.blueGrey.shade800, fontSize: 14, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.close_rounded, color: isDark ? Colors.white38 : Colors.blueGrey.shade300, size: 20),
          ),
        ],
      ),
    );
  }
}

class _EmptyAreaCard extends StatelessWidget {
  final VoidCallback onTap;
  final AppLocalizations l10n;
  final bool isDark;
  const _EmptyAreaCard({required this.onTap, required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Icon(Icons.add_location_alt_rounded, color: Colors.blueAccent.withOpacity(0.5), size: 32),
            const Gap(12),
            Text(l10n.noAreaSelected, style: TextStyle(color: isDark ? Colors.white38 : Colors.blueGrey.shade300, fontWeight: FontWeight.w600)),
            const Gap(4),
            Text(l10n.tapToAddArea, style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _AddMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  final AppLocalizations l10n;
  final bool isDark;
  const _AddMoreButton({required this.onTap, required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: Colors.blueAccent, size: 18),
            const Gap(8),
            Text(l10n.addMoreArea, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;
  final bool isDark;

  const _TimeCard({required this.label, required this.time, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelText(label, isDark: isDark),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
              boxShadow: [
                if (isDark)
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 1)
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.access_time_filled_rounded,
                      color: Colors.cyanAccent, size: 20),
                ),
                const Gap(16),
                Text(
                  time,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.blueGrey.shade900,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IdentityVerificationStep extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController idCtrl;
  final Function(String) onFront;
  final Function(String) onBack;
  final String? front;
  final String? back;
  final AppLocalizations l10n;
  final bool isDark;

  const _IdentityVerificationStep(
      {required this.onNext,
      required this.idCtrl,
      required this.onFront,
      required this.onBack,
      this.front,
      this.back,
      required this.l10n,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.identityVerification,
      isDark: isDark,
      child: AnimationLimiter(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _LabelText(l10n.idNumber, isDark: isDark),
                _FuturisticTextField(
                  controller: idCtrl,
                  hint: l10n.idNumberHint,
                  icon: Icons.contact_emergency_rounded,
                  keyboardType: TextInputType.number,
                  isDark: isDark,
                ),
                const Gap(32),
                _LabelText(l10n.frontIdCard, isDark: isDark),
                const Gap(12),
                _IdentityBox(
                    path: front,
                    onTap: () => _pickWithSimulation(context, onFront, l10n.frontIdCard),
                    isDark: isDark),
                const Gap(24),
                _LabelText(l10n.backIdCard, isDark: isDark),
                const Gap(12),
                _IdentityBox(
                    path: back,
                    onTap: () => _pickWithSimulation(context, onBack, l10n.backIdCard),
                    isDark: isDark),
                const Gap(40),
                _FuturisticButton(
                  text: l10n.next,
                  onTap: () {
                    final idText = idCtrl.text.trim();
                    if (idText.length != 12 || double.tryParse(idText) == null) {
                      AppSnackbar.showWarning(context, l10n.idNumberHint);
                      return;
                    }
                    if (front == null || back == null) {
                      AppSnackbar.showWarning(context, l10n.backIdCard);
                      return;
                    }
                    onNext();
                  },
                  isDark: isDark,
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickWithSimulation(
      BuildContext context, Function(String) onPicked, String label) async {
    final picker = ImagePicker();
    XFile? img;
    
    try {
      img = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    } catch (e) {
      // Fallback cho máy ảo không có camera
      img = await picker.pickImage(source: ImageSource.gallery);
    }
    
    if (img == null) return;
    final l10n = AppLocalizations.of(context)!;

    // Kiểm tra chất lượng và nén ảnh trước khi quét AI
    final compressed = await ImageService.compressAndValidate(File(img.path));
    if (compressed == null) {
      if (context.mounted) AppSnackbar.showError(context, "Ảnh quá mờ hoặc chất lượng thấp. Vui lòng chụp rõ nét hơn.");
      return;
    }

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: const Color(0xFF1A1F2E).withOpacity(0.95),
            shape:
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.cyanAccent),
                  const Gap(24),
                  Text(l10n.scanningId(label),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const Gap(8),
                  Text(l10n.aiVerifying,
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        final inputImage = InputImage.fromFilePath(img.path);
        final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        
        String fullText = recognizedText.text.toUpperCase();
        await textRecognizer.close();

        if (context.mounted) Navigator.pop(context);

        bool isRequestingFront = label == l10n.frontIdCard;

        // Keywords cho mặt trước (đầy đủ hơn)
        bool hasFrontKeywords = fullText.contains("CỘNG HÒA") || fullText.contains("CONG HOA") ||
                                fullText.contains("HỌ VÀ TÊN") || fullText.contains("HO VA TEN") ||
                                fullText.contains("CĂN CƯỚC") || fullText.contains("CAN CUOC") ||
                                fullText.contains("GIỚI TÍNH") || fullText.contains("GIOI TINH");
        
        // Keywords cho mặt sau (Nâng cấp độ nhạy: thêm vân tay, mã MRZ, cục trưởng)
        bool hasBackKeywords = fullText.contains("ĐẶC ĐIỂM") || fullText.contains("DAC DIEM") ||
                               fullText.contains("NHẬN DẠNG") || fullText.contains("NHAN DANG") ||
                               fullText.contains("NGÓN TRỎ") || fullText.contains("NGON TRO") ||
                               fullText.contains("VÂN TAY") || fullText.contains("VAN TAY") ||
                               fullText.contains("CỤC TRƯỞNG") || fullText.contains("CUC TRUONG") ||
                               fullText.contains("P<VNM") || fullText.contains("IDVNM") ||
                               fullText.contains("<<<<");

        if (isRequestingFront) {
          if (!hasFrontKeywords) {
            if (context.mounted) AppSnackbar.showError(context, "Đây không phải mặt trước CCCD hợp lệ.");
            return;
          }
        } else {
          // Đang yêu cầu mặt sau
          if (!hasBackKeywords) {
            if (context.mounted) AppSnackbar.showError(context, "Đây không phải mặt sau CCCD hợp lệ.");
            return;
          }
        }

        onPicked(img.path);
        if (context.mounted) {
          AppSnackbar.showSuccess(context, l10n.validIdConfirmed(label));
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          AppSnackbar.showError(context, "${l10n.error}: $e");
        }
      }
    }
  }
}

class _ToolCheckStep extends StatelessWidget {
  final VoidCallback onNext;
  final List<String> toolPaths;
  final List<String> certPaths;
  final Function(String) onAddTool;
  final Function(int) onRemoveTool;
  final Function(String) onAddCert;
  final Function(int) onRemoveCert;
  final AppLocalizations l10n;
  final bool isDark;

  const _ToolCheckStep({
    required this.onNext,
    required this.toolPaths,
    required this.certPaths,
    required this.onAddTool,
    required this.onRemoveTool,
    required this.onAddCert,
    required this.onRemoveCert,
    required this.l10n,
    required this.isDark,
  });

  Future<void> _pickImage(BuildContext context, Function(String) onPicked) async {
    final picker = ImagePicker();
    XFile? img;
    
    try {
      img = await picker.pickImage(source: ImageSource.camera);
    } catch (e) {
      img = await picker.pickImage(source: ImageSource.gallery);
    }

    if (img == null) return;

    final compressed = await ImageService.compressAndValidate(File(img.path));
    if (compressed != null) {
      onPicked(compressed.path);
    } else {
      if (context.mounted) AppSnackbar.showError(context, "Ảnh không đạt chất lượng. Vui lòng chụp lại.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.toolsAndEquipment,
      isDark: isDark,
      child: AnimationLimiter(
        child: SingleChildScrollView(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                _ToolPickerCard(
                  title: l10n.addToolSet,
                  subtitle: l10n.toolSetDesc,
                  paths: toolPaths,
                  onAdd: () => _pickImage(context, onAddTool),
                  onRemove: onRemoveTool,
                  isDark: isDark,
                ),
                const Gap(24),
                _ToolPickerCard(
                  title: l10n.professionalCert,
                  subtitle: l10n.certDesc,
                  paths: certPaths,
                  onAdd: () => _pickImage(context, onAddCert),
                  onRemove: onRemoveCert,
                  isDark: isDark,
                ),
                const Gap(40),
                _FuturisticButton(
                  text: l10n.next,
                  onTap: () {
                    if (toolPaths.isEmpty) {
                      AppSnackbar.showWarning(context, l10n.toolSetDesc);
                      return;
                    }
                    onNext();
                  },
                  isDark: isDark,
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolPickerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> paths;
  final VoidCallback onAdd;
  final Function(int) onRemove;
  final bool isDark;

  const _ToolPickerCard({
    required this.title,
    required this.subtitle,
    required this.paths,
    required this.onAdd,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.construction_rounded,
                    color: Colors.cyanAccent, size: 22),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.blueGrey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark ? Colors.white.withOpacity(0.4) : Colors.blueGrey.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _SmallCircleButton(onTap: onAdd, icon: Icons.add_a_photo_rounded),
            ],
          ),
          if (paths.isNotEmpty) ...[
            const Gap(20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: paths.asMap().entries.map((entry) {
                final index = entry.key;
                final path = entry.value;
                return _ImageThumbnail(
                  path: path,
                  onRemove: () => onRemove(index),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _SmallCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _SmallCircleButton({required this.onTap, required this.icon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.cyanAccent, Colors.blueAccent]),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final String path;
  final VoidCallback onRemove;
  const _ImageThumbnail({required this.path, required this.onRemove});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodStep extends StatelessWidget {
  final VoidCallback onNext;
  final List<String> selected;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;
  final bool isDark;
  const _PaymentMethodStep({required this.onNext, required this.selected, required this.onChanged, required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.paymentMethod,
      isDark: isDark,
      child: Column(
        children: [
          _PaymentTile(
            name: l10n.bankTransfer, 
            icon: Icons.account_balance_rounded, 
            selected: selected.contains('bankTransfer'), 
            onTap: () => onChanged('bankTransfer'), 
            isDark: isDark
          ),
          const Gap(16),
          _PaymentTile(
            name: l10n.momoZalo, 
            icon: Icons.account_balance_wallet_rounded, 
            selected: selected.contains('wallet'), 
            onTap: () => onChanged('wallet'), 
            isDark: isDark
          ),
          const Gap(16),
          _PaymentTile(
            name: l10n.cash, 
            icon: Icons.payments_rounded, 
            selected: selected.contains('cash'), 
            onTap: () => onChanged('cash'), 
            isDark: isDark
          ),
          const Spacer(),
          _FuturisticButton(
            text: l10n.next,
            onTap: () {
              if (selected.isEmpty) {
                AppSnackbar.showWarning(context, l10n.paymentMethod);
                return;
              }
              onNext();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _BankDetailsStep extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController bankCtrl;
  final TextEditingController numCtrl;
  final TextEditingController holdCtrl;
  final TextEditingController phoneCtrl;
  final VoidCallback onSelectBank;
  final Function(String) onAccountNumChanged;
  final bool isLoading;
  final String? bankLogoUrl;
  final AppLocalizations l10n;
  final bool isDark;

  const _BankDetailsStep({
    required this.onNext,
    required this.bankCtrl,
    required this.numCtrl,
    required this.holdCtrl,
    required this.phoneCtrl,
    required this.onSelectBank,
    required this.onAccountNumChanged,
    required this.isLoading,
    this.bankLogoUrl,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.accountInfo,
      isDark: isDark,
      child: Column(
        children: [
          GestureDetector(
            onTap: onSelectBank,
            child: AbsorbPointer(
              child: _FuturisticTextField(
                  controller: bankCtrl,
                  hint: l10n.selectBank,
                  icon: Icons.account_balance_rounded,
                  isDark: isDark),
            ),
          ),
          const Gap(16),
          _FuturisticTextField(
            controller: numCtrl,
            hint: l10n.accountNumberHint,
            icon: Icons.numbers_rounded,
            keyboardType: TextInputType.number,
            onChanged: onAccountNumChanged,
            isDark: isDark,
          ),
          const Gap(24),
          if (isLoading)
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(color: Colors.cyanAccent),
                  const Gap(12),
                  Text(l10n.verifyingInfo, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            )
          else if (holdCtrl.text.isNotEmpty)
            _VerifiedAccountCard(
              bankName: bankCtrl.text,
              accountName: holdCtrl.text,
              accountNumber: numCtrl.text,
              logoUrl: bankLogoUrl,
              l10n: l10n,
              isDark: isDark,
            )
          else if (bankCtrl.text.isNotEmpty && numCtrl.text.length >= 8)
            TextButton.icon(
              onPressed: () => onAccountNumChanged(numCtrl.text),
              icon: const Icon(Icons.refresh_rounded, color: Colors.cyanAccent),
              label: Text(l10n.retryVerification, style: const TextStyle(color: Colors.cyanAccent)),
            ),

          const Spacer(),
          _FuturisticButton(
            text: l10n.next,
            onTap: () {
              if (bankCtrl.text.isEmpty || numCtrl.text.isEmpty) {
                AppSnackbar.showWarning(context, l10n.accountNumberHint);
                return;
              }
              onNext();
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _VerifiedAccountCard extends StatelessWidget {
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String? logoUrl;
  final AppLocalizations l10n;
  final bool isDark;

  const _VerifiedAccountCard({
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    this.logoUrl,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (logoUrl != null)
                Image.network(logoUrl!, width: 40, height: 40, fit: BoxFit.contain)
              else
                const Icon(Icons.account_balance_rounded, color: Colors.cyanAccent, size: 40),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bankName.toUpperCase(),
                        style: TextStyle(color: isDark ? Colors.white : Colors.blueGrey.shade900, fontWeight: FontWeight.w900)),
                    Text(accountNumber, style: const TextStyle(color: Colors.cyanAccent)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            ],
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.accountHolder, style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text(accountName, style: TextStyle(color: isDark ? Colors.white : Colors.blueGrey.shade900, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingDetailsStep extends StatelessWidget {
  final VoidCallback onComplete;
  final TextEditingController indusCtrl;
  final TextEditingController rateCtrl;
  final TextEditingController expCtrl;
  final TextEditingController addressCtrl;
  final String selectedSchedule;
  final ValueChanged<String> onScheduleChanged;
  final bool isSubmitting;
  final AppLocalizations l10n;
  final bool isDark;

  const _BillingDetailsStep({
    required this.onComplete,
    required this.indusCtrl,
    required this.rateCtrl,
    required this.expCtrl,
    required this.addressCtrl,
    required this.selectedSchedule,
    required this.onScheduleChanged,
    required this.isSubmitting,
    required this.l10n,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return _StepWrapper(
      title: l10n.billingDetails,
      isDark: isDark,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LabelText(l10n.industryType, isDark: isDark),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FuturisticTextField(
                          controller: indusCtrl,
                          hint: l10n.vdElectrician,
                          icon: Icons.electrical_services_rounded,
                          isDark: isDark),
                      _HelperText(l10n.enterSpecialty),
                    ],
                  ),
                ),
                const Gap(12),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final List<String> years = List.generate(20, (i) => "${i + 1} ${l10n.years}");
                          final selected = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => _SimplePicker(title: l10n.yearsExperience, items: years, isDark: isDark),
                          );
                          if (selected != null) {
                            expCtrl.text = selected.replaceAll(RegExp(r'[^0-9]'), '');
                          }
                        },
                        child: AbsorbPointer(
                          child: _FuturisticTextField(
                              controller: expCtrl,
                              hint: "KN",
                              icon: Icons.work_history_rounded,
                              isDark: isDark),
                        ),
                      ),
                      _HelperText(l10n.seniority),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            _LabelText("${l10n.hourlyRate} (VND/giờ)", isDark: isDark),
            _FuturisticTextField(
                controller: rateCtrl,
                hint: "Ví dụ: 150.000",
                icon: Icons.monetization_on_rounded,
                keyboardType: TextInputType.number,
                isDark: isDark),
            _HelperText("Số tiền khách hàng sẽ trả cho 1 giờ làm việc"),
            const Gap(12),
            _FuturisticTextField(
                controller: addressCtrl,
                hint: l10n.businessAddressHint,
                icon: Icons.storefront_rounded,
                isDark: isDark),
            _HelperText(l10n.nearCustomersDesc),
            const Gap(24),
            _LabelText(l10n.workSchedule, isDark: isDark),
            _ScheduleSelector(
              selected: selectedSchedule,
              onChanged: onScheduleChanged,
              l10n: l10n,
              isDark: isDark,
            ),
            const Gap(40),
            _FuturisticButton(
              text: isSubmitting ? "ĐANG GỬI HỒ SƠ..." : l10n.submit,
              onTap: isSubmitting ? () {} : () {
                if (indusCtrl.text.isEmpty || rateCtrl.text.isEmpty) {
                  AppSnackbar.showWarning(context, l10n.pleaseEnterRequiredFields);
                  return;
                }
                onComplete();
              },
              isDark: isDark,
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class _ScheduleSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;
  final bool isDark;
  const _ScheduleSelector({required this.selected, required this.onChanged, required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final schedules = {
      'allWeek': 'Cả tuần (T2 - CN)',
      'officeHours': 'Giờ hành chính (T2 - T6)',
      'weekendsOnly': 'Chỉ cuối tuần (T7, CN)',
    };
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: schedules.entries.map((e) {
        final isSelected = selected == e.key;
        return GestureDetector(
          onTap: () => onChanged(e.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.2)
                  : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isSelected ? Colors.blueAccent : (isDark ? Colors.white10 : Colors.black12)),
            ),
            child: Text(e.value,
                style: TextStyle(
                    color: isSelected ? (isDark ? Colors.white : Colors.blueAccent) : (isDark ? Colors.white60 : Colors.blueGrey),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }
}

// --- REUSABLE FUTURISTIC COMPONENTS ---

class _StepWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  const _StepWrapper({required this.title, required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Text(title,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.blueGrey.shade900,
                  height: 1.1,
                  letterSpacing: -0.5)),
          const Gap(40),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _FuturisticTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isDark;
  const _FuturisticTextField({required this.controller, required this.hint, this.icon, this.maxLines = 1, this.keyboardType, this.onChanged, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: FigmaAuthTextField(
        controller: controller,
        hint: hint,
        icon: icon ?? Icons.edit,
        darkTheme: isDark,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

class _FuturisticButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDark;
  const _FuturisticButton({required this.text, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
          foregroundColor: isDark ? const Color(0xFF0D47A1) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: isDark ? 0 : 8,
        ),
        child: Text(text.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }
}

class _IdentityBox extends StatelessWidget {
  final String? path;
  final VoidCallback onTap;
  final bool isDark;
  const _IdentityBox({this.path, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: path != null 
                ? Colors.green.withOpacity(0.5) 
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
            width: 1.5,
          ),
        ),
        child: path == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_a_photo_rounded,
                        size: 32, color: Colors.cyanAccent),
                  ),
                  const Gap(16),
                  const Text("CHỤP ẢNH CCCD",
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w900,
                          fontSize: 14)),
                ],
              )
            : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(path!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;
  const _PaymentTile({required this.name, required this.icon, required this.selected, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent.withOpacity(0.15) : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.blueAccent : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)), width: 2),
        ),
        child: Row(children: [
          Icon(icon, color: selected ? Colors.blueAccent : (isDark ? Colors.white54 : Colors.blueGrey)),
          const Gap(16),
          Text(name, style: TextStyle(color: selected ? (isDark ? Colors.white : Colors.blueAccent) : (isDark ? Colors.white60 : Colors.blueGrey), fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Icon(selected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: selected ? Colors.blueAccent : (isDark ? Colors.white24 : Colors.black12)),
        ]),
      ),
    );
  }
}

class _HelperText extends StatelessWidget {
  final String text;
  const _HelperText(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(text, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.w500)),
    );
  }
}

class _SimplePicker extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isDark;
  const _SimplePicker({required this.title, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D47A1) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2))),
          const Gap(24),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.blueGrey.shade900)),
          const Gap(12),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index], textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white70 : Colors.blueGrey.shade800, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context, items[index]),
              ),
            ),
          ),
          const Gap(24),
        ],
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;
  final bool isDark;
  const _LabelText(this.text, {required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: TextStyle(color: isDark ? Colors.white.withOpacity(0.4) : Colors.blueGrey.shade400, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
    );
  }
}

class _SmartAddressPicker extends StatefulWidget {
  final AppLocalizations l10n;
  const _SmartAddressPicker({required this.l10n});

  @override
  State<_SmartAddressPicker> createState() => _SmartAddressPickerState();
}

class _SmartAddressPickerState extends State<_SmartAddressPicker> {
  String _query = '';
  List<String> _results = [];

  void _onSearch(String val) {
    setState(() {
      _query = val;
      _results = VietnamAddressProvider.searchGlobal(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E).withOpacity(0.95) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          const Gap(12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2))),
          const Gap(20),
          Text(widget.l10n.serviceArea, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isDark ? Colors.white : Colors.blueGrey.shade900)),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              autofocus: true,
              onChanged: _onSearch,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: "Gõ để tìm (VD: Bến Nghé, Quận 1...)",
                hintStyle: TextStyle(color: isDark ? Colors.white.withOpacity(0.3) : Colors.black26),
                prefixIcon: Icon(Icons.search_rounded, color: isDark ? Colors.white : Colors.blueGrey),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
          ),
          const Gap(12),
          const Divider(color: Colors.white10),
          Expanded(
            child: _results.isEmpty && _query.length >= 2
                ? Center(child: Text("Không tìm thấy kết quả", style: TextStyle(color: isDark ? Colors.white38 : Colors.blueGrey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _results.isEmpty ? 1 : _results.length,
                    itemBuilder: (context, index) {
                      if (_results.isEmpty) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.map_rounded, color: Colors.blueAccent, size: 20),
                          ),
                          title: Text("Chọn theo danh sách truyền thống", style: TextStyle(color: isDark ? Colors.white : Colors.blueGrey.shade800, fontWeight: FontWeight.bold)),
                          subtitle: const Text("Tỉnh -> Quận -> Phường"),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () => Navigator.pop(context, ""),
                        );
                      }
                      return ListTile(
                        leading: const Icon(Icons.location_on_rounded, color: Colors.blueAccent, size: 20),
                        title: Text(_results[index], style: TextStyle(color: isDark ? Colors.white : Colors.blueGrey.shade800, fontSize: 15, fontWeight: FontWeight.w600)),
                        onTap: () => Navigator.pop(context, _results[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

