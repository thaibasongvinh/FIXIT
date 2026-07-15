import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:fixit/l10n/app_localizations.dart';

import '../../providers/call_provider.dart';

class VoiceCallScreen extends ConsumerStatefulWidget {
  final String? name;
  final String? avatar;
  final String? callId;
  final bool isIncoming;

  const VoiceCallScreen({
    super.key, 
    this.name, 
    this.avatar, 
    this.callId,
    this.isIncoming = false,
  });

  @override
  ConsumerState<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends ConsumerState<VoiceCallScreen> {
  int _seconds = 0;
  Timer? _timer;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isIncoming) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                _buildHeader(l10n),
                const Spacer(flex: 3),
                _buildControls(l10n),
                const Gap(60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF010A1A),
        image: widget.avatar != null && widget.avatar!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(widget.avatar!),
                fit: BoxFit.cover,
                opacity: 0.3,
              )
            : null,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.black.withOpacity(0.4)),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 4),
            boxShadow: [
              BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 30, spreadRadius: 10)
            ]
          ),
          child: ClipOval(
            child: widget.avatar != null && widget.avatar!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.avatar!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const Icon(Icons.person, size: 60, color: Colors.white24),
                  )
                : const Icon(Icons.person, size: 60, color: Colors.white24),
          ),
        ),
        const Gap(24),
        Text(
          widget.name ?? 'Ẩn danh',
          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        const Gap(8),
        Text(
          widget.isIncoming ? l10n.incomingCall : l10n.calling,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        if (!widget.isIncoming) ...[
          const Gap(4),
          Text(
            _formatDuration(_seconds),
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _buildControls(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRoundButton(
                icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                label: l10n.mute,
                isActive: _isMuted,
                onTap: () => setState(() => _isMuted = !_isMuted),
              ),
              _buildRoundButton(
                icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                label: l10n.speaker,
                isActive: _isSpeakerOn,
                onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
              ),
              _buildRoundButton(
                icon: Icons.videocam_off_rounded,
                label: 'Video',
                isActive: false,
                onTap: () {},
              ),
            ],
          ),
          const Gap(60),
          widget.isIncoming ? _buildIncomingActionButtons() : _buildEndCallButton(),
        ],
      ),
    );
  }

  Widget _buildRoundButton({required IconData icon, required String label, required bool isActive, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isActive ? Colors.black : Colors.white, size: 28),
          ),
        ),
        const Gap(12),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEndCallButton() {
    return InkWell(
      onTap: () {
        if (widget.callId != null) {
          ref.read(callNotifierProvider.notifier).endCall(widget.callId!);
        }
        context.pop();
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          color: Color(0xFFFF5252),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0xFFFF5252), blurRadius: 20, spreadRadius: -5)],
        ),
        child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildIncomingActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            if (widget.callId != null) {
              ref.read(callNotifierProvider.notifier).rejectCall(widget.callId!);
            }
            context.pop();
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(color: Color(0xFFFF5252), shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.callId != null) {
              ref.read(callNotifierProvider.notifier).acceptCall(widget.callId!);
              _startTimer();
              // In real production, this would change state of the screen
            }
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(color: Color(0xFF00E676), shape: BoxShape.circle),
            child: const Icon(Icons.call_rounded, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }
}
