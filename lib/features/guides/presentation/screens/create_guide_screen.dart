import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/guide_metadata.dart';
import '../../domain/models/guide_model.dart';
import '../providers/guide_provider.dart';

class CreateGuideScreen extends ConsumerStatefulWidget {
  const CreateGuideScreen({super.key});

  @override
  ConsumerState<CreateGuideScreen> createState() => _CreateGuideScreenState();
}

class _CreateGuideScreenState extends ConsumerState<CreateGuideScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _device = TextEditingController();
  final _desc = TextEditingController();
  final _tools = TextEditingController();
  final _tags = TextEditingController();
  final _picker = ImagePicker();

  XFile? _coverImage;
  String _category = 'smartphone';
  String _difficulty = 'trung_binh';
  int _time = 30;
  bool _saving = false;
  bool _showPreview = false;

  @override
  void dispose() {
    _title.dispose();
    _device.dispose();
    _desc.dispose();
    _tools.dispose();
    _tags.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;
    setState(() => _coverImage = image);
  }

  Future<void> _submit() async {
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ban can dang nhap de tao huong dan')),
      );
      return;
    }

    final hasPermission = currentUser.role.name == 'technician' ||
        currentUser.role.name == 'admin';
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chi technician hoac admin moi duoc tao huong dan'),
        ),
      );
      return;
    }

    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repository = ref.read(guideRepositoryProvider);
      final tools = _parseCommaSeparated(_tools.text);
      final tags = _parseTags();
      final title = _title.text.trim();
      final device = _device.text.trim();
      final description = _desc.text.trim();

      final guide = GuideModel(
        id: '',
        title: title,
        description: description,
        device: device,
        category: _category,
        difficulty: _difficulty,
        authorId: currentUser.uid,
        authorName: currentUser.name,
        slug: buildGuideSlug(title, device),
        estimatedTime: _time,
        toolsRequired: tools,
        tags: tags,
        searchKeywords: buildGuideSearchKeywords(
          title: title,
          description: description,
          device: device,
          category: _category,
          tags: tags,
          toolsRequired: tools,
        ),
      );

      final guideId = await repository.createGuide(guide);

      if (_coverImage != null) {
        final bytes = await _coverImage!.readAsBytes();
        final coverUrl = await repository.uploadGuideCover(
          guideId,
          bytes,
          _coverImage!.name,
        );
        await repository.updateGuideCover(guideId, coverUrl);
      }

      ref.invalidate(guidesFeedNotifierProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tao huong dan thanh cong')),
      );
      context.go('/guides/detail/$guideId');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tao huong dan that bai: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final hasPermission = currentUser != null &&
        (currentUser.role.name == 'technician' ||
            currentUser.role.name == 'admin');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tao huong dan moi'),
        actions: [
          TextButton(
            onPressed: (_saving || !hasPermission) ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Dang'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasPermission)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .errorContainer
                        .withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Tai khoan hien tai khong co quyen tao huong dan.',
                  ),
                ),
              const Text(
                'Anh bia',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _saving ? null : _pickCoverImage,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: _coverImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 28),
                            SizedBox(height: 8),
                            Text('Chon anh bia'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_coverImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Ten huong dan *',
                  hintText: 'VD: Thay man hinh iPhone 14',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nhap ten huong dan'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _device,
                decoration: const InputDecoration(
                  labelText: 'Thiet bi *',
                  hintText: 'VD: iPhone 14, Dell XPS 13',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nhap ten thiet bi'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Danh muc',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['smartphone', 'laptop', 'xe_may', 'gia_dung', 'khac']
                    .map(
                      (category) => ChoiceChip(
                        label: Text(_categoryLabel(category)),
                        selected: _category == category,
                        onSelected: (_) => setState(() => _category = category),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              const Text('Do kho',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: ['de', 'trung_binh', 'kho', 'chuyen_gia']
                    .map(
                      (difficulty) => ChoiceChip(
                        label: Text(_difficultyLabel(difficulty)),
                        selected: _difficulty == difficulty,
                        onSelected: (_) =>
                            setState(() => _difficulty = difficulty),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Thoi gian uoc tinh: '),
                  Text(
                    '$_time phut',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _time.toDouble(),
                min: 5,
                max: 180,
                divisions: 35,
                label: '$_time phut',
                onChanged:
                    _saving ? null : (v) => setState(() => _time = v.round()),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mo ta (co ho tro format nhanh)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showPreview = !_showPreview),
                    icon:
                        Icon(_showPreview ? Icons.edit : Icons.remove_red_eye),
                    label: Text(_showPreview ? 'Sua' : 'Xem truoc'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_showPreview)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  constraints:
                      const BoxConstraints(minHeight: 150, maxHeight: 300),
                  child: MarkdownBody(
                      data:
                          _desc.text.isEmpty ? '*Chua co mo ta*' : _desc.text),
                )
              else ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: _saving ? null : () => _insertTemplate('## '),
                      child: const Text('Heading'),
                    ),
                    OutlinedButton(
                      onPressed:
                          _saving ? null : () => _insertTemplate('**in dam**'),
                      child: const Text('In dam'),
                    ),
                    OutlinedButton(
                      onPressed:
                          _saving ? null : () => _insertTemplate('\n- Buoc 1'),
                      child: const Text('Bullet'),
                    ),
                    OutlinedButton(
                      onPressed: _saving
                          ? null
                          : () => _insertTemplate('\n[Canh bao] '),
                      child: const Text('Canh bao'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _desc,
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Mo ta huong dan *',
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nhap mo ta' : null,
                  onChanged: (v) => setState(() {}),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _tools,
                decoration: const InputDecoration(
                  labelText: 'Dung cu can thiet',
                  hintText: 'Ngan cach bang dau phay: tua vit, kep, ...',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tags,
                decoration: const InputDecoration(
                  labelText: 'Tags tim kiem',
                  hintText: 'iphone, man hinh, lcd...',
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_saving || !hasPermission) ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Tao huong dan'),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sau khi tao ban co the them cac buoc chi tiet va anh minh hoa.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String value) => switch (value) {
        'smartphone' => 'Dien thoai',
        'laptop' => 'Laptop',
        'xe_may' => 'Xe may',
        'gia_dung' => 'Gia dung',
        _ => 'Khac',
      };

  String _difficultyLabel(String value) => switch (value) {
        'de' => 'De',
        'trung_binh' => 'Trung binh',
        'kho' => 'Kho',
        _ => 'Chuyen gia',
      };

  void _insertTemplate(String template) {
    final text = _desc.text;
    final selection = _desc.selection;
    if (!selection.isValid || selection.start < 0 || selection.end < 0) {
      _desc.text = '$text$template';
      _desc.selection = TextSelection.collapsed(offset: _desc.text.length);
      return;
    }

    final replaced =
        text.replaceRange(selection.start, selection.end, template);
    final cursor = selection.start + template.length;
    _desc.value = TextEditingValue(
      text: replaced,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }

  List<String> _parseTags() {
    final explicitTags = _parseCommaSeparated(_tags.text);
    final deviceTag = normalizeGuideText(_device.text);
    final categoryTag = normalizeGuideText(_categoryLabel(_category));
    return {
      ...explicitTags.map(normalizeGuideText),
      if (deviceTag.isNotEmpty) deviceTag,
      if (categoryTag.isNotEmpty) categoryTag,
    }.toList()
      ..sort();
  }

  List<String> _parseCommaSeparated(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
