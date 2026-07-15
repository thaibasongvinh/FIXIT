import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:fixit/core/router/app_router.dart';
import 'package:fixit/shared/models/user_model.dart';
import 'package:fixit/features/auth/presentation/providers/auth_provider.dart';
import 'package:fixit/features/profile/presentation/widgets/components/menu/unsaved_changes_dialog.dart';
import 'package:fixit/shared/utils/snackbar_utils.dart';
import 'package:fixit/shared/utils/vietnam_address_provider.dart';
import '../../widgets/components/avatar/profile_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final List<String> _addresses; 
  late final TextEditingController _phoneController;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  
  File? _imageFile;
  final _picker = ImagePicker();

  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Bhutan', 'code': '+975', 'flag': '🇧🇹'},
    {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳'},
    {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Cyprus', 'code': '+357', 'flag': '🇨🇾'},
    {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Kyrgyzstan', 'code': '+996', 'flag': '🇰🇬'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
    {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
    {'name': 'Mongolia', 'code': '+976', 'flag': '🇲🇳'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Nepal', 'code': '+977', 'flag': '🇳🇵'},
    {'name': 'North Korea', 'code': '+850', 'flag': '🇰🇵'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Palestine', 'code': '+970', 'flag': '🇵🇸'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Syria', 'code': '+963', 'flag': '🇸🇾'},
    {'name': 'Taiwan', 'code': '+886', 'flag': '🇹🇼'},
    {'name': 'Tajikistan', 'code': '+992', 'flag': '🇹🇯'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Timor-Leste', 'code': '+670', 'flag': '🇹🇱'},
    {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Turkmenistan', 'code': '+993', 'flag': '🇹🇲'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Uzbekistan', 'code': '+998', 'flag': '🇺🇿'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
    {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪'},
  ];
  Map<String, String> _selectedCountry = {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'};
  bool _isCountryPickerOpen = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    debugPrint('EditProfileScreen: Initializing with User: ${widget.user.uid}');
    debugPrint('EditProfileScreen: User DOB from parameter: "${widget.user.dob}"');
    debugPrint('EditProfileScreen: User Addresses from parameter: ${widget.user.addresses}');

    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _dobController = TextEditingController(text: widget.user.dob);
    _addresses = List.from(widget.user.addresses);
    
    // Xử lý số điện thoại: Tách mã vùng nếu có
    String phone = widget.user.phone;
    for (var c in _countries) {
      if (phone.startsWith(c['code']!)) {
        _selectedCountry = c;
        phone = phone.substring(c['code']!.length).trim();
        break;
      }
    }
    _phoneController = TextEditingController(text: phone);
    
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  bool get _hasUnsavedChanges {
    final currentFullPhone = _phoneController.text.trim().isEmpty 
        ? '' 
        : '${_selectedCountry['code']} ${_phoneController.text.trim()}'.trim();
    
    return _nameController.text.trim() != widget.user.name ||
           currentFullPhone != widget.user.phone.trim() ||
           _dobController.text != widget.user.dob ||
           _addresses.length != widget.user.addresses.length ||
           _imageFile != null;
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => UnsavedChangesDialog(
        onSave: () => Navigator.pop(context, 'save'),
        onDiscard: () => Navigator.pop(context, 'discard'),
      ),
    );

    if (result == 'save') {
      await _saveProfile();
      return false; // _saveProfile will handle navigation
    }
    return result == 'discard';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 11, 28),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0054A5),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1D1E),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF0054A5)),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _addNewAddress() async {
    final String? selectedCity = await _showFuturisticPicker(
      title: 'Select City/Province',
      items: VietnamAddressProvider.provinces,
      showSearch: true,
    );
    if (selectedCity == null) return;

    final String? selectedDistrict = await _showFuturisticPicker(
      title: 'Select District/County',
      items: VietnamAddressProvider.getDistricts(selectedCity),
      showSearch: true,
    );
    if (selectedDistrict == null) return;

    final String? selectedWard = await _showFuturisticPicker(
      title: 'Select Ward/Commune',
      items: VietnamAddressProvider.getWards(selectedCity, selectedDistrict),
      showSearch: true,
    );
    if (selectedWard == null) return;

    final TextEditingController detailController = TextEditingController();
    final String? detailAddress = await showDialog<String>(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Specific Address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const Gap(20),
                TextField(
                  controller: detailController,
                  decoration: InputDecoration(
                    hintText: 'House number, street name...',
                    filled: true,
                    fillColor: const Color(0xFFF0F5FF),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, detailController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0054A5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (detailAddress != null && detailAddress.isNotEmpty) {
      setState(() {
        _addresses.add('$detailAddress, $selectedWard, $selectedDistrict, $selectedCity, Vietnam');
      });
    }
  }

  Future<String?> _showFuturisticPicker({required String title, required List<String> items, bool showSearch = false}) async {
    String internalSearch = '';
    return showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.sizeOf(context).height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const Gap(12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const Gap(24),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1D1E))),
              const Gap(12),
              if (showSearch)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (v) => setModalState(() => internalSearch = v),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0054A5)),
                      filled: true,
                      fillColor: const Color(0xFFF0F5FF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.where((i) => i.toLowerCase().contains(internalSearch.toLowerCase())).length,
                  itemBuilder: (context, index) {
                    final filteredItems = items.where((i) => i.toLowerCase().contains(internalSearch.toLowerCase())).toList();
                    return ListTile(
                      title: Text(filteredItems[index], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF0054A5)),
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

  Future<void> _saveProfile() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    try {
      final name = _nameController.text.trim();
      final phoneBody = _phoneController.text.trim();
      final fullPhone = phoneBody.isEmpty ? '' : '${_selectedCountry['code']} $phoneBody';
      final isPhoneChanged = fullPhone.trim() != widget.user.phone.trim();
      
      debugPrint('EditProfileScreen: Saving Profile...');
      debugPrint('EditProfileScreen: Name: "$name"');
      debugPrint('EditProfileScreen: DOB: "${_dobController.text}"');
      debugPrint('EditProfileScreen: Addresses count: ${_addresses.length}');
      debugPrint('EditProfileScreen: Addresses: $_addresses');

      await ref.read(authNotifierProvider.notifier).updateProfile(
            name: name,
            phone: fullPhone,
            avatar: widget.user.avatar,
            avatarFile: _imageFile,
            dob: _dobController.text,
            addresses: _addresses,
          );

      if (!mounted) return;
      
      // Thông báo thành công
      AppSnackbar.showSuccess(context, 'Profile updated successfully!');

      if (isPhoneChanged && phoneBody.isNotEmpty) {
        context.pushReplacement(AppRoutes.phoneVerification, extra: widget.user.role);
      } else {
        // Sử dụng go() thay vì pop() để đảm về trang Profile và tránh loop navigation
        context.go(AppRoutes.profile);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update profile: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    // Sync with fresh data if it arrives while screen is open (e.g. Realtime update)
    ref.listen(currentUserProvider, (previous, next) {
      final freshUser = next.valueOrNull;
      if (freshUser != null) {
        bool changed = false;
        if (_dobController.text.isEmpty && freshUser.dob.isNotEmpty) {
          _dobController.text = freshUser.dob;
          changed = true;
        }
        if (_addresses.isEmpty && freshUser.addresses.isNotEmpty) {
          _addresses.clear();
          _addresses.addAll(freshUser.addresses);
          changed = true;
        }
        if (changed) setState(() {});
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final router = GoRouter.of(context);
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          router.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1E), size: 20),
            onPressed: () async {
              final router = GoRouter.of(context);
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                router.pop();
              }
            },
          ),
          title: Row(
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const Gap(8),
              if (ref.watch(authStateProvider).valueOrNull?.emailVerification ?? false)
                Image.asset('assets/images/Verification.png', width: 22, height: 22),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: _imageFile != null 
                                  ? Hero(
                                      tag: 'profile_avatar_preview',
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover),
                                          border: Border.all(color: const Color(0xFFE0E9FF), width: 2),
                                        ),
                                      ),
                                    )
                                  : ProfileAvatar(
                                      user: widget.user.copyWith(name: _nameController.text), 
                                      size: 120
                                    ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF0054A5), Color(0xFF007BFF)],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF0054A5).withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(40),
                        _buildModernField(
                          'Name', 
                          _nameController, 
                          icon: Icons.person_outline_rounded,
                          onChanged: (val) => setState(() {}),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const Gap(20),
                        _buildEmailField(),
                        const Gap(20),
                        _buildModernField(
                          'Date of Birth', 
                          _dobController, 
                          icon: Icons.calendar_today_rounded, 
                          isDropdown: true, 
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: _selectDate,
                          readOnly: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                        const Gap(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('ADDRESSES'),
                            IconButton(
                              onPressed: _addNewAddress,
                              icon: const Icon(Icons.add_location_alt_rounded, color: Color(0xFF0054A5)),
                              tooltip: 'Add new address',
                            ),
                          ],
                        ),
                        const Gap(8),
                        if (_addresses.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F5FF).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE0E9FF), width: 1),
                            ),
                            child: const Center(
                              child: Text('No address added yet', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _addresses.length,
                            itemBuilder: (context, index) {
                              return _buildAddressTile(_addresses[index], index);
                            },
                          ),
                        const Gap(20),
                        _buildPhoneField('Phone number', _phoneController),
                        const Gap(48),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0054A5), Color(0xFF007BFF)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0054A5).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: state.isLoading ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: state.isLoading 
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                                  : const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                            ),
                          ),
                        ),
                        const Gap(40),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isCountryPickerOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => setState(() => _isCountryPickerOpen = false),
                    child: Container(
                      color: Colors.black26,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: TextField(
                                  onChanged: (v) => setState(() => _searchQuery = v),
                                  decoration: InputDecoration(
                                    hintText: 'Search country...',
                                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0054A5)),
                                    filled: true,
                                    fillColor: const Color(0xFFF0F5FF),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _countries.where((c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).length,
                                  itemBuilder: (context, index) {
                                    final filteredList = _countries.where((c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                                    final country = filteredList[index];
                                    return ListTile(
                                      leading: Text(country['flag']!, style: const TextStyle(fontSize: 26)),
                                      title: Text(country['name']!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                                      trailing: Text(country['code']!, style: const TextStyle(color: Color(0xFF0054A5), fontWeight: FontWeight.w800, fontSize: 15)),
                                      onTap: () {
                                        setState(() {
                                          _selectedCountry = country;
                                          _isCountryPickerOpen = false;
                                          _searchQuery = '';
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF0054A5).withValues(alpha: 0.8),
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildAddressTile(String address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E9FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0054A5).withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Color(0xFF0054A5), size: 24),
          const Gap(16),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(color: Color(0xFF1A1D1E), fontSize: 15, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _addresses.removeAt(index)),
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400], size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildModernField(
    String label, 
    TextEditingController controller, {
    required IconData icon, 
    bool enabled = true, 
    bool isDropdown = false, 
    IconData? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF1A1D1E).withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E9FF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0054A5).withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            validator: validator,
            style: const TextStyle(color: Color(0xFF1A1D1E), fontSize: 16, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF0054A5), size: 22),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF1A1D1E).withValues(alpha: 0.4), size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: InputBorder.none,
              errorStyle: const TextStyle(height: 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    final authUser = ref.watch(authStateProvider).valueOrNull;
    final isVerified = authUser?.emailVerification ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            color: const Color(0xFF1A1D1E).withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E9FF), width: 1.5),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.email_outlined, color: Color(0xFF0054A5), size: 22),
              ),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  enabled: false,
                  style: TextStyle(color: const Color(0xFF1A1D1E).withValues(alpha: 0.5), fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (isVerified)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Image.asset('assets/images/Verification.png', width: 24, height: 24),
                )
              else
                TextButton(
                  onPressed: () => context.push(AppRoutes.verifyEmail),
                  child: const Text(
                    'Verify Now',
                    style: TextStyle(color: Color(0xFF0054A5), fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF1A1D1E).withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E9FF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0054A5).withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const Gap(16),
              GestureDetector(
                onTap: () => setState(() => _isCountryPickerOpen = true),
                child: Row(
                  children: [
                    Text(_selectedCountry['flag']!, style: const TextStyle(fontSize: 24)),
                    const Gap(4),
                    Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF1A1D1E).withValues(alpha: 0.4)),
                  ],
                ),
              ),
              const Gap(8),
              Container(
                height: 24,
                width: 1,
                color: const Color(0xFFE0E9FF),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => setState(() {}),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _PhoneFormatter(onInvalid: () {
                      AppSnackbar.showWarning(context, 'Vui lòng nhập số điện thoại hợp lệ (không bắt đầu bằng số 0)');
                    }),
                  ],
                  validator: (val) {
                    if (val != null && val.isNotEmpty && val.replaceAll(' ', '').length < 9) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                  style: const TextStyle(color: Color(0xFF1A1D1E), fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    border: InputBorder.none,
                    prefixText: '${_selectedCountry['code']} ',
                    prefixStyle: const TextStyle(color: Color(0xFF1A1D1E), fontSize: 16, fontWeight: FontWeight.w700),
                    errorStyle: const TextStyle(height: 0),
                  ),
                ),
              ),
              if (controller.text.trim().isNotEmpty && 
                  '${_selectedCountry['code']} ${controller.text.trim()}'.trim() != widget.user.phone.trim())
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ref.watch(authNotifierProvider).isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : TextButton(
                        onPressed: () async {
                          final fullPhone = '${_selectedCountry['code']}${controller.text.replaceAll(' ', '')}';
                          try {
                            final challenge = await ref.read(authNotifierProvider.notifier).startPhoneVerification(
                                  phoneNumber: fullPhone,
                                );
                            if (mounted) {
                              context.push(
                                AppRoutes.verifyPhone,
                                extra: {
                                  'phoneNumber': fullPhone,
                                  'verificationId': challenge.verificationId,
                                },
                              );
                            }
                          } catch (e) {
                            if (mounted) AppSnackbar.showError(context, 'Error: $e');
                          }
                        },
                        child: const Text('Verify', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ),
                )
              else if (widget.user.hasVerifiedPhone && '${_selectedCountry['code']} ${controller.text.trim()}'.trim() == widget.user.phone.trim())
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Image.asset('assets/images/Verification.png', width: 24, height: 24),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  final VoidCallback onInvalid;
  _PhoneFormatter({required this.onInvalid});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // 1. Loại bỏ số 0 ở đầu và thông báo
    if (text.startsWith('0')) {
      onInvalid();
      return TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
        composing: oldValue.composing,
      );
    }

    // 2. Chỉ giữ lại số
    text = text.replaceAll(RegExp(r'\D'), '');

    // 3. Giới hạn độ dài (ví dụ 10 số sau khi đã bỏ số 0 đầu)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // 4. Thêm dấu cách sau mỗi 3 số
    StringBuffer newText = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 3 == 0) {
        newText.write(' ');
      }
      newText.write(text[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
