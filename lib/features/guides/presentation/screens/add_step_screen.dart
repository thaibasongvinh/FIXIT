import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/step_model.dart';
import '../providers/guide_provider.dart';

class AddStepScreen extends ConsumerStatefulWidget {
  final String guideId;

  const AddStepScreen({
    super.key,
    required this.guideId,
  });

  @override
  ConsumerState<AddStepScreen> createState() => _AddStepScreenState();
}

class _AddStepScreenState extends ConsumerState<AddStepScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();
  final _warning = TextEditingController();
  final _videoUrl = TextEditingController();
  final _picker = ImagePicker();
  final List<XFile> _images = [];
  XFile? _pickedVideo;

  int _duration = 5;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _warning.dispose();
    _videoUrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty || !mounted) return;
    setState(() => _images.addAll(files));
  }

  Future<void> _pickVideo() async {
    final file = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );
    if (file == null || !mounted) return;
    setState(() => _pickedVideo = file);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repository = ref.read(guideRepositoryProvider);
      final steps = await repository.watchSteps(widget.guideId).first;
      final nextOrder = steps.isEmpty ? 1 : steps.last.order + 1;

      final draftStep = StepModel(
        id: '',
        order: nextOrder,
        title: _title.text.trim(),
        content: _content.text.trim(),
        warningNote: _warning.text.trim(),
        videoUrl: _videoUrl.text.trim(),
        duration: _duration,
      );

      final stepId = await repository.addStep(widget.guideId, draftStep);

      final uploadedUrls = <String>[];
      if (_images.isNotEmpty) {
        for (final image in _images) {
          final bytes = await image.readAsBytes();
          final url = await repository.uploadStepImage(
            widget.guideId,
            stepId,
            bytes,
            image.name,
          );
          uploadedUrls.add(url);
        }
      }

      var finalVideoUrl = draftStep.videoUrl;
      if (_pickedVideo != null) {
        final videoBytes = await _pickedVideo!.readAsBytes();
        finalVideoUrl = await repository.uploadStepVideo(
          widget.guideId,
          stepId,
          videoBytes,
          _pickedVideo!.name,
        );
      }

      if (uploadedUrls.isNotEmpty || finalVideoUrl != draftStep.videoUrl) {
        await repository.updateStep(
          widget.guideId,
          draftStep.copyWith(
            id: stepId,
            imageUrls: uploadedUrls,
            videoUrl: finalVideoUrl,
          ),
        );
      }

      ref.invalidate(guideStepsProvider(widget.guideId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Da them buoc thanh cong')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Khong the them buoc: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Them buoc huong dan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Ten buoc *',
                  hintText: 'Vi du: Tat nguon thiet bi',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vui long nhap ten buoc'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _content,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Noi dung *',
                  alignLabelWithHint: true,
                  hintText: 'Mo ta chi tiet cach thao tac',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vui long nhap noi dung'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _warning,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Luu y canh bao',
                  hintText: 'Khong bat buoc',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoUrl,
                decoration: const InputDecoration(
                  labelText: 'Video URL',
                  hintText: 'Khong bat buoc',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _pickVideo,
                    icon: const Icon(Icons.video_file_outlined),
                    label: const Text('Upload video'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickedVideo == null
                          ? 'Chua chon video'
                          : _pickedVideo!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_pickedVideo != null)
                    IconButton(
                      onPressed: _saving
                          ? null
                          : () => setState(() => _pickedVideo = null),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Thoi gian uoc tinh: $_duration phut',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: _duration.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$_duration phut',
                onChanged: (v) => setState(() => _duration = v.round()),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _pickImages,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Them anh'),
                  ),
                  const SizedBox(width: 8),
                  Text('${_images.length} anh duoc chon'),
                ],
              ),
              if (_images.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images
                      .map((image) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(image.path),
                                  width: 86,
                                  height: 86,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -8,
                                right: -8,
                                child: InkWell(
                                  onTap: _saving
                                      ? null
                                      : () => setState(
                                            () => _images.remove(image),
                                          ),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Dang luu...' : 'Luu buoc'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
