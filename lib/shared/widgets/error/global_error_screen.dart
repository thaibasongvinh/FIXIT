import 'package:flutter/material.dart';

class GlobalErrorScreen extends StatelessWidget {
  final FlutterErrorDetails details;

  const GlobalErrorScreen({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops! Đã có lỗi xảy ra',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chúng tôi rất tiếc về sự cố này. Đội ngũ kỹ thuật đã được thông báo và sẽ xử lý sớm nhất có thể.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Trong thực tế, có thể reload app hoặc quay về trang chủ
                  // Ở đây ta đơn giản là cố gắng quay lại nếu có thể
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A93E8),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Quay lại',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              ExpansionTile(
                title: const Text(
                  'Chi tiết lỗi (Dành cho nhà phát triển)',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        details.toString(),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
