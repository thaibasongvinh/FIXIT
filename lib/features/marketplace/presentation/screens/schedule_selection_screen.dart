import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduleSelectionScreen extends StatefulWidget {
  final String title;
  const ScheduleSelectionScreen({super.key, required this.title});

  @override
  State<ScheduleSelectionScreen> createState() => _ScheduleSelectionScreenState();
}

class _ScheduleSelectionScreenState extends State<ScheduleSelectionScreen> {
  DateTime selectedDate = DateTime(2024, 11, 13);
  String? selectedTime = '10:00';

  final List<String> amSlots = ['09:00', '10:00', '11:00', '12:00'];
  final List<String> pmSlots = ['01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00'];

  @override
  Widget build(BuildContext context) {
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
          widget.title,
          style: const TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2025),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),
                    const Gap(32),
                    const Text(
                      'Select Hours',
                      style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(16),
                    const Text('AM', style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 13, fontWeight: FontWeight.w500)),
                    const Gap(12),
                    _buildTimeGrid(amSlots),
                    const Gap(20),
                    const Text('PM', style: TextStyle(color: Color(0xFF8E8E8E), fontSize: 13, fontWeight: FontWeight.w500)),
                    const Gap(12),
                    _buildTimeGrid(pmSlots),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      Uri(
                        path: '/marketplace/booking-summary',
                        queryParameters: {
                          'serviceTitle': widget.title,
                          'categoryName': widget.title.split(' ').first,
                          'image': 'assets/images/Electricity Meter.png', // Fallback for mock
                        },
                      ).toString(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0056D2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeGrid(List<String> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = selectedTime == slot;
        return InkWell(
          onTap: () => setState(() => selectedTime = slot),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0056D2) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFEEEEEE)),
            ),
            child: Text(
              slot,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2450A4),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
