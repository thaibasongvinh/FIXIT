import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GuideVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;

  const GuideVideoPlayer({
    super.key,
    required this.url,
    this.autoPlay = false,
  });

  @override
  State<GuideVideoPlayer> createState() => _GuideVideoPlayerState();
}

class _GuideVideoPlayerState extends State<GuideVideoPlayer> {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoCtrl!.initialize();
      if (!mounted) return;

      final primaryColor = Theme.of(context).colorScheme.primary;

      _chewieCtrl = ChewieController(
        videoPlayerController: _videoCtrl!,
        autoPlay: widget.autoPlay,
        looping: false,
        aspectRatio: _videoCtrl!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        placeholder: Container(color: Colors.black),
        materialProgressColors: ChewieProgressColors(
          playedColor: primaryColor,
          handleColor: primaryColor,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white24,
        ),
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error loading video: $e');
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    _chewieCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white60, size: 40),
              SizedBox(height: 8),
              Text('Không thể tải video',
                  style: TextStyle(color: Colors.white60)),
            ],
          ),
        ),
      );
    }

    if (_chewieCtrl == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: _videoCtrl!.value.aspectRatio,
        child: Chewie(controller: _chewieCtrl!),
      ),
    );
  }
}
