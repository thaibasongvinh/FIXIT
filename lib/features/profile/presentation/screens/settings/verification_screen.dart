import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../providers/verification_provider.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final _idController = TextEditingController();
  File? _frontImage;
  File? _backImage;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(image.path);
        } else {
          _backImage = File(image.path);
        }
      });
    }
  }

  void _showIdentityForm() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identity Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Gap(16),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Identity Number (CCCD/CMND)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const Gap(24),
              const Text('Identity Card Photos', style: TextStyle(fontWeight: FontWeight.bold)),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _buildImagePicker(
                      title: 'Front Side',
                      image: _frontImage,
                      onTap: () => _pickImage(true),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: _buildImagePicker(
                      title: 'Back Side',
                      image: _backImage,
                      onTap: () => _pickImage(false),
                    ),
                  ),
                ],
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Consumer(
                  builder: (context, ref, child) {
                    final status = ref.watch(verificationNotifierProvider);
                    return ElevatedButton(
                      onPressed: status.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0056D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: status.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit for Review', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker({required String title, File? image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
                  const Gap(8),
                  Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_idController.text.isEmpty || _frontImage == null || _backImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and upload both photos')),
      );
      return;
    }

    try {
      await ref.read(verificationNotifierProvider.notifier).submitIdentity(
            identityNumber: _idController.text,
            frontImage: _frontImage!,
            backImage: _backImage!,
          );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification submitted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final verifiedStatus = user?.verifiedStatus ?? 'unverified';

    String identityStatus = 'Verify';
    bool isIdentityVerified = false;
    bool isPending = false;

    if (verifiedStatus == 'approved') {
      identityStatus = 'Verified';
      isIdentityVerified = true;
    } else if (verifiedStatus == 'pending') {
      identityStatus = 'Pending Review';
      isPending = true;
    } else if (verifiedStatus == 'rejected') {
      identityStatus = 'Rejected - Re-verify';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2450A4)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Verification',
          style: TextStyle(
            color: Color(0xFF2450A4),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification methods',
              style: TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(24),
            _buildVerificationTile(
              icon: Icons.email_rounded,
              title: 'Email',
              status: 'Verified',
              isVerified: true,
            ),
            const Gap(16),
            _buildVerificationTile(
              icon: Icons.phone_rounded,
              title: 'Mobile number',
              status: 'Verified',
              isVerified: true,
            ),
            const Gap(16),
            _buildVerificationTile(
              icon: Icons.badge_rounded,
              title: 'Identity Card',
              status: identityStatus,
              isVerified: isIdentityVerified,
              onAction: isPending || isIdentityVerified ? null : _showIdentityForm,
            ),
            const Gap(16),
            _buildVerificationTile(
              icon: Icons.security_rounded,
              title: 'Google 2FA',
              status: 'Verify',
              isVerified: false,
              onAction: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationTile({
    required IconData icon,
    required String title,
    required String status,
    required bool isVerified,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0056D2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const Gap(16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5C5C5C),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (isVerified)
            Text(
              status,
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: onAction == null ? Colors.orange : const Color(0xFF2450A4),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
