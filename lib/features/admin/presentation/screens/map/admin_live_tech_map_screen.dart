import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fixit/features/admin/presentation/providers/admin_provider.dart';

class AdminLiveTechMapScreen extends ConsumerStatefulWidget {
  const AdminLiveTechMapScreen({super.key});

  @override
  ConsumerState<AdminLiveTechMapScreen> createState() => _AdminLiveTechMapScreenState();
}

class _AdminLiveTechMapScreenState extends ConsumerState<AdminLiveTechMapScreen> {
  GoogleMapController? _controller;
  final LatLng _initialCenter = const LatLng(10.762622, 106.660172); // Mặc định ở TP.HCM

  @override
  Widget build(BuildContext context) {
    final techsAsync = ref.watch(onlineTechsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.black87 : Colors.white,
            child: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 16), onPressed: () => Navigator.pop(context)),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: isDark ? Colors.black87 : Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Text('LIVE TECHNICIANS', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
        ),
        centerTitle: true,
      ),
      body: techsAsync.when(
        data: (techs) {
          final markers = techs.map((t) => Marker(
            markerId: MarkerId(t['userId'] ?? 'unknown'),
            position: LatLng(t['lat'] ?? 0.0, t['lng'] ?? 0.0),
            infoWindow: InfoWindow(title: t['fullName'] ?? 'Technician', snippet: t['specialty'] ?? 'Available'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          )).toSet();

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialCenter, zoom: 12),
            onMapCreated: (controller) => _controller = controller,
            markers: markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            style: isDark ? _darkMapStyle : null,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Map Error: $e')),
      ),
    );
  }

  final String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#212121"}]},
    {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#212121"}]},
    {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#757575"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]}
  ]
  ''';
}
