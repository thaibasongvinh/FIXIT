import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/presentation/widgets/app_background.dart';
import '../providers/technician_provider.dart';
import '../../domain/models/technician_model.dart';

class CitySearchScreen extends ConsumerStatefulWidget {
  const CitySearchScreen({super.key});

  @override
  ConsumerState<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends ConsumerState<CitySearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  bool _hasLocationPermission = false;
  GoogleMapController? _mapController;
  final Map<String, BitmapDescriptor> _customIcons = {};

  static const _initialCam = CameraPosition(
    target: LatLng(10.776889, 106.700806), // Ho Chi Minh City
    zoom: 12,
  );

  final List<String> _recentSearches = [
    'Playa Tijera',
    'Costa del Solana',
    'Sierra Blanca',
    'Sierra Vista',
    'Bahía Hermosa',
    'Valle Dorado',
    'Solstice Bay',
    'Pacifica Bluffs',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
  }

  Future<void> _loadCustomIcons() async {
    const iconFiles = {
      'plumber': 'Plumber.png',
      'electrician': 'Electrician Providers.png',
      'painter': 'Painter Providers.png',
      'cleaner': 'Cleaner Providers.png',
      'locksmith': 'Locksmith Providers.png',
    };

    for (var entry in iconFiles.entries) {
      final icon = await _createCustomMarkerBitmap('assets/images/${entry.value}');
      if (mounted) {
        setState(() => _customIcons[entry.key] = icon);
      }
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(String assetPath) async {
    const int size = 120;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = const Color(0xFF2450A4);
    
    canvas.drawCircle(const Offset(60, 60), 55, paint);
    
    final Path path = Path()
      ..moveTo(45, 105)
      ..lineTo(75, 105)
      ..lineTo(60, 120)
      ..close();
    canvas.drawPath(path, paint);

    try {
      final data = await rootBundle.load(assetPath);
      final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(), 
        targetWidth: 80, // Use constant int
      );
      final frame = await codec.getNextFrame();
      
      canvas.save();
      final Path clipPath = Path()
        ..addOval(Rect.fromCircle(center: const Offset(60, 60), radius: 48));
      canvas.clipPath(clipPath);
      
      canvas.drawImage(frame.image, const Offset(20, 20), Paint());
      canvas.restore();
    } catch (e) {
      paint.color = Colors.white;
      canvas.drawCircle(const Offset(60, 60), 40, paint);
    }

    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(size, size);
    final byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => _LocationPermissionDialog(
        onAllowOnce: () => _handleAllowLocation(),
        onAllowWhileUsing: () => _handleAllowLocation(),
        onDeny: () => Navigator.pop(context),
      ),
    );
  }

  void _handleAllowLocation() {
    Navigator.pop(context);
    setState(() => _hasLocationPermission = true);

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(33.4484, -112.0740),
          zoom: 14,
        ),
      ),
    );
  }

  void _openProviders() {
    context.go('/marketplace/providers');
  }

  @override
  Widget build(BuildContext context) {
    final techsAsync = ref.watch(techniciansNotifierProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
              child: _CitySearchBar(
                controller: _controller,
                onTap: () => setState(() => _isSearching = true),
                onSubmitted: (v) {
                  setState(() => _isSearching = false);
                  if (!_hasLocationPermission) {
                    _showPermissionDialog();
                  }
                },
                onClear: () {
                  _controller.clear();
                  setState(() => _isSearching = false);
                },
                onTargetTap: () {
                  if (!_hasLocationPermission) {
                    _showPermissionDialog();
                  }
                },
                isSearching: _isSearching,
                hasPermission: _hasLocationPermission,
              ),
            ),
            Expanded(
              child: _isSearching ? _buildRecentSearches() : _buildLiveMap(techsAsync),
            ),
          ],
        ),
      ),
    ),);
  }

  Widget _buildLiveMap(AsyncValue<List<TechnicianModel>> techsAsync) {
    return techsAsync.when(
      data: (techs) {
        return Stack(
          children: [
            // MOCK MAP BACKGROUND - Bản đồ vệ tinh TP.HCM thực tế
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1544974226-53189db3f579?q=80&w=2000&auto=format&fit=crop'), // Ảnh đô thị nhìn từ trên cao giống Google Map
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.1), // Phủ mờ nhẹ
              ),
            ),
            
            // SIMULATED MARKERS - Rải tại các vị trí Quận 1, Quận 3, Quận 10 (TP.HCM)
            ...techs.asMap().entries.map((entry) {
              final index = entry.key;
              final tech = entry.value;
              
              // Tọa độ giả lập để khớp với ảnh nền đô thị
              final positions = [
                {'top': 150.0, 'left': 120.0, 'area': 'Quận 1'},
                {'top': 320.0, 'left': 240.0, 'area': 'Quận 7'},
                {'top': 280.0, 'left': 60.0, 'area': 'Quận 10'},
                {'top': 480.0, 'left': 180.0, 'area': 'Bình Thạnh'},
                {'top': 550.0, 'left': 80.0, 'area': 'Tân Bình'},
              ];
              
              final pos = positions[index % positions.length];
              
              return Positioned(
                top: pos['top'] as double,
                left: pos['left'] as double,
                child: GestureDetector(
                  onTap: () => _showTechInfo(tech),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))
                          ],
                          border: Border.all(color: const Color(0xFF0056D2), width: 2.5),
                        ),
                        child: Icon(
                          _getIconData(tech.skills.isNotEmpty ? tech.skills.first : ''),
                          color: const Color(0xFF0056D2),
                          size: 28,
                        ),
                      ),
                      const Gap(4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0056D2),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8)
                          ],
                        ),
                        child: Text(
                          tech.name,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Các nút giả lập của Google Maps cho thật
            Positioned(
              right: 16, bottom: 200,
              child: Column(
                children: [
                  _buildMapAction(Icons.add),
                  const Gap(8),
                  _buildMapAction(Icons.remove),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _openProviders,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0056D2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4,
                    ),
                    child: const Text(
                      'View all',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF0056D2)),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildMapAction(IconData icon) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: Icon(icon, color: Colors.grey.shade700, size: 20),
    );
  }

  IconData _getIconData(String skill) {
    final s = skill.toLowerCase();
    if (s.contains('plumb')) return Icons.plumbing_rounded;
    if (s.contains('elect')) return Icons.electrical_services_rounded;
    if (s.contains('paint')) return Icons.format_paint_rounded;
    if (s.contains('clean')) return Icons.cleaning_services_rounded;
    if (s.contains('lock')) return Icons.lock_open_rounded;
    return Icons.build_rounded;
  }

  void _showTechInfo(TechnicianModel tech) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: Colors.blueAccent),
            const Gap(10),
            Text(tech.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Specialty: ${tech.skills.join(', ')}"),
            const Gap(8),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                Text(" ${tech.rating} • Verified Provider"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CLOSE"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/marketplace/${tech.uid}');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0056D2), foregroundColor: Colors.white),
            child: const Text("VIEW PROFILE"),
          ),
        ],
      ),
    );
  }


  String _getIconKey(String skill) {
    final s = skill.toLowerCase();
    if (s.contains('plumb')) return 'plumber';
    if (s.contains('elect')) return 'electrician';
    if (s.contains('paint')) return 'painter';
    if (s.contains('clean')) return 'cleaner';
    if (s.contains('lock')) return 'locksmith';
    return 'cleaner';
  }

  Widget _buildRecentSearches() {
    return Container(
      color: Colors.transparent,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        itemCount: _recentSearches.length + 1,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Recent Searches',
                style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 16, fontWeight: FontWeight.w800),
              ),
            );
          }
          final search = _recentSearches[index - 1];
          return ListTile(
            onTap: () {
              _controller.text = search;
              setState(() => _isSearching = false);
              _showPermissionDialog();
            },
            contentPadding: EdgeInsets.zero,
            title: Text(
              search,
              style: const TextStyle(color: Color(0xFF5C5C5C), fontSize: 15, fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
    );
  }
}

class _CitySearchBar extends StatelessWidget {
  const _CitySearchBar({
    required this.controller,
    required this.onTap,
    required this.onSubmitted,
    required this.onClear,
    required this.onTargetTap,
    required this.isSearching,
    required this.hasPermission,
  });

  final TextEditingController controller;
  final VoidCallback onTap;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onTargetTap;
  final bool isSearching;
  final bool hasPermission;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSearching ? const Color(0xFF2450A4) : Colors.transparent, width: 1.5),
        boxShadow: [
          if (!isSearching)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: TextField(
        controller: controller,
        onTap: onTap,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: 'Search Location',
          hintStyle: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 15, fontWeight: FontWeight.w500),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF5C5C5C)),
          suffixIcon: isSearching
              ? IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF2450A4)),
                  ),
                  onPressed: onClear,
                )
              : IconButton(
                  onPressed: onTargetTap,
                  icon: Icon(
                    hasPermission ? Icons.gps_fixed_rounded : Icons.gps_fixed_rounded, 
                    color: hasPermission ? const Color(0xFF0056D2) : const Color(0xFF5C5C5C),
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(color: Color(0xFF4D4D4D), fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllowOnce;
  final VoidCallback onAllowWhileUsing;
  final VoidCallback onDeny;

  const _LocationPermissionDialog({
    required this.onAllowOnce,
    required this.onAllowWhileUsing,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on_rounded, size: 40, color: Color(0xFF5C5C5C)),
            const Gap(16),
            const Text(
              'Allow "FixIt" to use your location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF5C5C5C)),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildDialogButton('Allow Once', onAllowOnce),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildDialogButton('Allow While Using FixIt', onAllowWhileUsing, isBold: true),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildDialogButton("Don't Allow", onDeny),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onTap, {bool isBold = false}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF2450A4),
            fontSize: 17,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
