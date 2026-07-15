import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/technician_model.dart';

class TechnicianMapView extends StatefulWidget {
  final List<TechnicianModel> technicians;
  final Function(String techId) onTechTap;

  const TechnicianMapView({
    super.key,
    required this.technicians,
    required this.onTechTap,
  });

  @override
  State<TechnicianMapView> createState() => _TechnicianMapViewState();
}

class _TechnicianMapViewState extends State<TechnicianMapView> {
  Position? _currentPos;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    _determinePosition();
  }

  @override
  void didUpdateWidget(covariant TechnicianMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.technicians != widget.technicians) {
      setState(_updateMarkers);
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _currentPos = pos;
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    _markers.clear();

    // Add user marker
    if (_currentPos != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_pos'),
          position: LatLng(_currentPos!.latitude, _currentPos!.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Vị trí của bạn'),
        ),
      );
    }

    // Add technicians
    for (var tech in widget.technicians) {
      final lat = tech.latitude;
      final lng = tech.longitude;

      if (lat != null && lng != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(tech.uid),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              tech.isAvailable
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: tech.name,
              snippet: '${tech.rating}⭐ • ${tech.priceText}',
              onTap: () => widget.onTechTap(tech.uid),
            ),
          ),
        );
      }
    }
  }

  LatLng get _initialTarget {
    if (_currentPos != null) {
      return LatLng(_currentPos!.latitude, _currentPos!.longitude);
    }

    for (final tech in widget.technicians) {
      final lat = tech.latitude;
      final lng = tech.longitude;
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }

    return const LatLng(10.762622, 106.660172);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialTarget,
        zoom: 14,
      ),
      onMapCreated: (_) {},
      markers: _markers,
      myLocationEnabled: _currentPos != null,
      myLocationButtonEnabled: _currentPos != null,
      zoomControlsEnabled: false,
    );
  }
}
