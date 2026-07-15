import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../providers/technician_provider.dart';
import '../widgets/technician_map_view.dart';
import '../widgets/technician_card.dart';

class TechnicianMapScreen extends ConsumerStatefulWidget {
  const TechnicianMapScreen({super.key});

  @override
  ConsumerState<TechnicianMapScreen> createState() => _TechnicianMapScreenState();
}

class _TechnicianMapScreenState extends ConsumerState<TechnicianMapScreen> {
  String? _selectedTechId;

  @override
  Widget build(BuildContext context) {
    final techsAsync = ref.watch(techniciansNotifierProvider);
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
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black87 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
              )
            ],
          ),
          child: Text(
            'Thợ quanh đây',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          techsAsync.when(
            data: (techs) => TechnicianMapView(
              technicians: techs,
              onTechTap: (id) {
                setState(() => _selectedTechId = id);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Lỗi tải bản đồ: $e')),
          ),
          
          if (_selectedTechId != null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton.small(
                      backgroundColor: Colors.redAccent,
                      onPressed: () => setState(() => _selectedTechId = null),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                  const Gap(8),
                  Consumer(
                    builder: (context, ref, child) {
                      final techDetail = ref.watch(technicianDetailProvider(_selectedTechId!));
                      return techDetail.when(
                        data: (tech) => tech != null 
                          ? TechnicianCard(tech: tech)
                          : const SizedBox.shrink(),
                        loading: () => const Card(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
