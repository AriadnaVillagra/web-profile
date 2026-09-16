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
      // 📐 1. TAMAÑO GENERAL DEL MARCO DEL CELULAR
      height: 420,
      width: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🎬 2. VIDEO (Al fondo)
          if (_isInitialized)
            // FractionallySizedBox escala el video dinámicamente sin recortarlo
            FractionallySizedBox(
              widthFactor: 2, // 💡 Cambia a 0.80 para achicar el video, o 0.95 para agrandarlo
              heightFactor: 0.92, // 💡 Cambia a 0.85 para achicar el video, o 0.95 para agrandarlo
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: FittedBox(
                  fit: BoxFit.contain, // 👈 Importante: contiene el video completo sin recortar
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

          // 📱 3. MARCO DEL CELULAR (Por encima)
          IgnorePointer(
            child: Image.asset('images/mobile_frame.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
