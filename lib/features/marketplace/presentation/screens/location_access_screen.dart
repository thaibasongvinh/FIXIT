import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({
    super.key,
    this.title = 'Wiring Installation',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF005CB7),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2952A4),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Allow "FixIt" to use your location',
                style: TextStyle(
                  color: Color(0xFF525252),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We need to know your exact location so that The electrician can visit you easily.',
                style: TextStyle(
                  color: Color(0xFF686868),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 28),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset(
                  'assets/images/figma/location_access_map_crop.png',
                  width: double.infinity,
                  height: 164,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              _PermissionAction(
                label: 'Allow Once',
                onTap: () => context.push(
                  Uri(
                    path: '/marketplace/schedule-selection',
                    queryParameters: {'title': title},
                  ).toString(),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFDADADA)),
              _PermissionAction(
                label: 'Allow While Using FixIt',
                onTap: () => context.push(
                  Uri(
                    path: '/marketplace/schedule-selection',
                    queryParameters: {'title': title},
                  ).toString(),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFDADADA)),
              _PermissionAction(
                label: "Don't Allow",
                onTap: () => context.go('/marketplace'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.push(
                    Uri(
                      path: '/marketplace/location-details',
                      queryParameters: {'title': title},
                    ).toString(),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF005CB7),
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Fill Manually',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
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
}

class _PermissionAction extends StatelessWidget {
  const _PermissionAction({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF005CB7),
          minimumSize: const Size.fromHeight(56),
          shape: const RoundedRectangleBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
