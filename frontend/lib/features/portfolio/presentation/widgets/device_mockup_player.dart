import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DeviceMockupPlayer extends StatefulWidget {
  final String videoUrl;

  const DeviceMockupPlayer({super.key, required this.videoUrl});

  @override
  State<DeviceMockupPlayer> createState() => _DeviceMockupPlayerState();
}

class _DeviceMockupPlayerState extends State<DeviceMockupPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      width: 260,

      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isInitialized)
            Positioned(
              top: 14,
              bottom: 14,
              left: 13,
              right: 13,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset('images/mobile_frame.png', fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }
}
