import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ServiceSelectionScreen extends StatelessWidget {
  final String categoryTitle;
  final String imageAsset;

  const ServiceSelectionScreen({
    super.key,
    required this.categoryTitle,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for sub-services based on category
    final Map<String, List<Map<String, String>>> categoryServices = {
      'Electrician service': [
        {'title': 'Wiring Installation', 'image': 'assets/images/Electricity Meter.png'},
        {'title': 'Electrical Repairs', 'image': 'assets/images/Electricity Meter.png'},
        {'title': 'Indoor Lighting Installation', 'image': 'assets/images/Electricity Meter.png'},
        {'title': 'Fixture Installation', 'image': 'assets/images/Electricity Meter.png'},
      ],
      'Cleaning service': [
        {'title': 'House Cleaning', 'image': 'assets/images/Cleaner Providers.png'},
        {'title': 'Office Cleaning', 'image': 'assets/images/Cleaner Providers.png'},
        {'title': 'Deep Cleaning', 'image': 'assets/images/Cleaner Providers.png'},
        {'title': 'Kitchen Cleaning', 'image': 'assets/images/Cleaner Providers.png'},
      ],
      'AC service': [
        {'title': 'AC Repairing', 'image': 'assets/images/Air Conditenior.png'},
        {'title': 'AC Installation', 'image': 'assets/images/Air Conditenior.png'},
        {'title': 'AC Uninstallation', 'image': 'assets/images/Air Conditenior.png'},
        {'title': 'AC Service', 'image': 'assets/images/Air Conditenior.png'},
      ],
      'Plumbing service': [
        {'title': 'Pipe Leakage', 'image': 'assets/images/Plumber Providers.png'},
        {'title': 'Tap Repair', 'image': 'assets/images/Plumber Providers.png'},
        {'title': 'Toilet Repair', 'image': 'assets/images/Plumber Providers.png'},
        {'title': 'Drain Cleaning', 'image': 'assets/images/Plumber Providers.png'},
      ],
      'Security service': [
        {'title': 'CCTV Installation', 'image': 'assets/images/CCTV.png'},
        {'title': 'Alarm System', 'image': 'assets/images/CCTV.png'},
        {'title': 'Door Lock Repair', 'image': 'assets/images/CCTV.png'},
        {'title': 'Biometric Access', 'image': 'assets/images/CCTV.png'},
      ],
      'Mover service': [
        {'title': 'House Moving', 'image': 'assets/images/Mover Providers.png'},
        {'title': 'Office Moving', 'image': 'assets/images/Mover Providers.png'},
        {'title': 'Furniture Moving', 'image': 'assets/images/Mover Providers.png'},
        {'title': 'Local Moving', 'image': 'assets/images/Mover Providers.png'},
      ],
      'Carpenter service': [
        {'title': 'Furniture Repair', 'image': 'assets/images/Carpenter Providers.png'},
        {'title': 'Door Installation', 'image': 'assets/images/Carpenter Providers.png'},
        {'title': 'Cabinet Repair', 'image': 'assets/images/Carpenter Providers.png'},
        {'title': 'Wood Polishing', 'image': 'assets/images/Carpenter Providers.png'},
      ],
      'Painting service': [
        {'title': 'House Painting', 'image': 'assets/images/Painter Providers.png'},
        {'title': 'Exterior Painting', 'image': 'assets/images/Painter Providers.png'},
        {'title': 'Interior Painting', 'image': 'assets/images/Painter Providers.png'},
        {'title': 'Wall Stenciling', 'image': 'assets/images/Painter Providers.png'},
      ],
    };

    final services = categoryServices[categoryTitle] ?? categoryServices['Electrician service']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2450A4), size: 22),
          onPressed: () => context.pop(),
        ),
        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        children: [
          // Featured Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryTitle,
                      style: const TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Image.asset(imageAsset, width: 64, height: 64, fit: BoxFit.contain),
                  ],
                ),
                const Gap(24),
                const Divider(color: Color(0xFFF5F5F5), thickness: 1.5, height: 1),
                const Gap(24),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFF2450A4), size: 20),
                    const Gap(8),
                    const Text(
                      '4.8 (76)',
                      style: TextStyle(
                        color: Color(0xFF2450A4),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '\$20/hour',
                      style: TextStyle(
                        color: Color(0xFF2450A4),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Time.png', width: 22, height: 22),
                    const Gap(32),
                    const Text(
                      '7:00AM',
                      style: TextStyle(
                        color: Color(0xFF2450A4),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      'To',
                      style: TextStyle(
                        color: Color(0xFF8E8E8E),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      '10:00PM',
                      style: TextStyle(
                        color: Color(0xFF2450A4),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(32),
          Text(
            'For what you need ${categoryTitle.split(' ').first}',
            style: const TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(20),
          // Sub-services list
          ...services.map((service) => _buildServiceItem(context, service['title']!, service['image']!)),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(image, width: 28, height: 28),
          ),
          const Gap(16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4D4D4D),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF2450A4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {
                context.push(
                  Uri(
                    path: '/marketplace/selected-service',
                    queryParameters: {
                      'serviceTitle': title,
                      'categoryName': categoryTitle.split(' ').first,
                      'image': image,
                    },
                  ).toString(),
                );
              },
              icon: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
