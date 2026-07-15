import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1E), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.push('/chat'),
            child: const Text(
              'Live Chat',
              style: TextStyle(
                color: Color(0xFF0054A5),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Gap(12),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Gap(20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0054A5).withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Help.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.support_agent_rounded,
                        size: 80,
                        color: Color(0xFF0054A5),
                      ),
                    ),
                  ),
                ),
                const Gap(32),
                const Text(
                  'How can we assist you?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(8),
                Text(
                  'Our futuristic support team is here for you 24/7',
                  style: TextStyle(
                    color: const Color(0xFF1A1D1E).withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(40),
                _buildModernInput('Issue Title', _titleController, hint: 'What is the problem?'),
                const Gap(24),
                _buildModernInput('Description', _messageController, hint: 'Describe your issue in detail...', maxLines: 5),
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
                          color: const Color(0xFF0054A5).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your message has been sent')),
                        );
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Send Message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                ),
                const Gap(20),
                TextButton.icon(
                  onPressed: () => context.push('/chat'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0054A5)),
                  label: const Text(
                    'Start Live Chat',
                    style: TextStyle(
                      color: Color(0xFF0054A5),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernInput(String label, TextEditingController controller, {required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF1A1D1E).withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E9FF), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0054A5).withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Color(0xFF1A1D1E), fontSize: 16, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: const Color(0xFF1A1D1E).withOpacity(0.3), fontWeight: FontWeight.w500),
              contentPadding: const EdgeInsets.all(18),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
