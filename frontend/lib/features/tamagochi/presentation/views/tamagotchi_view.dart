// frontend/lib/features/tamagotchi/presentation/views/tamagotchi_view.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/cat_dialogues.dart';
import '../../../../core/services/portfolio_access_service.dart';
import '../../../../core/theme/neobrutalism_theme.dart';
import '../../../../core/widgets/neo_nav_buttons.dart';
import '../../../../core/widgets/wallpaper.dart';
import '../../../portfolio/presentation/views/portfolio_view.dart';
import '../../domain/tamagotchi_controller.dart';

class TamagotchiView extends StatefulWidget {
  const TamagotchiView({super.key});

  @override
  State<TamagotchiView> createState() => _TamagotchiViewState();
}

class _TamagotchiViewState extends State<TamagotchiView>
    with TickerProviderStateMixin {
  final TamagotchiController _cat = TamagotchiController();
  late final AnimationController _lottieController;

  late List<String> _dialogues;
  int _dialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _dialogues = CatDialogues.getDialoguesFor(GameType.tamagotchi);
    _cat.addListener(_onStateChange);
  }

  void _onStateChange() {
    setState(() {});

    if (PortfolioAccessService().isUnlocked) {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PortfolioView()),
        );
      });
    }
  }

  void _nextDialogue() {
    setState(() {
      _dialogueIndex = (_dialogueIndex + 1) % _dialogues.length;
    });
  }

  void _feed() {
    _cat.feed();
    _playInteractionAnimation();
  }

  void _pet() {
    _cat.pet();
    _playInteractionAnimation();
  }

  void _playInteractionAnimation() {
    if (!PortfolioAccessService().isUnlocked && !_cat.isGameOver) {
      _lottieController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _cat.removeListener(_onStateChange);
    _cat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isGameWon = PortfolioAccessService().isUnlocked;
    final bool isGameOver = _cat.isGameOver;

    String catText = _dialogues[_dialogueIndex];
    if (isGameWon) {
      catText = "¡Me salvaste la vida! Redirigiendo al portfolio...";
    } else if (isGameOver) {
      catText = "Te dormiste y pasaron cosas... 💀";
    }

    return Wallpaper(
      text: catText, // <-- Cambiado de displayedText a text
      onTap: _nextDialogue,
      groundHeightFactor: 0.20, // Suelo reducido para mayor espacio vertical
      catHeight: 130, // Tamaño compacto para el gato
      bubbleHeight: 75, // Altura fija de viñeta
      child: Stack(
        children: [
          // Header Superior con Botón de Retroceso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              NeoBackButton(),
              Text(
                'TAMAGOTCHI HUB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: NeoColors.border,
                ),
              ),
              SizedBox(width: 48),
            ],
          ),

          // Cuerpo Principal del Tamagotchi
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Oreja Izquierda
                        Positioned(
                          top: -24,
                          left: 24,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: NeoColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              border: NeoStyle.border(width: 3.5),
                            ),
                          ),
                        ),
                        // Oreja Derecha
                        Positioned(
                          top: -24,
                          right: 24,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: NeoColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              border: NeoStyle.border(width: 3.5),
                            ),
                          ),
                        ),
                        // Chasis Neobrutalista
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: NeoColors.primary,
                            borderRadius: BorderRadius.circular(40),
                            border: NeoStyle.border(width: 4),
                            boxShadow: NeoStyle.hardShadow(
                              offset: const Offset(6, 6),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Pantalla LCD
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isGameOver
                                      ? const Color(0xFFE57373)
                                      : const Color(0xFF9EBC9F),
                                  borderRadius: BorderRadius.circular(16),
                                  border: NeoStyle.border(width: 3),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      _cat.statusMessage.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Lottie o Gráfico de Derrota
                                    SizedBox(
                                      height: 90,
                                      width: 90,
                                      child: isGameOver
                                          ? const Center(
                                              child: Text(
                                                '💀',
                                                style: TextStyle(fontSize: 50),
                                              ),
                                            )
                                          : (isGameWon
                                                ? Lottie.asset(
                                                    'assets/animations/plankton_evol.json',
                                                    fit: BoxFit.contain,
                                                  )
                                                : Lottie.asset(
                                                    'assets/animations/plankton_tongue.json',
                                                    controller:
                                                        _lottieController,
                                                    fit: BoxFit.contain,
                                                    onLoaded: (composition) {
                                                      _lottieController
                                                              .duration =
                                                          composition.duration;
                                                    },
                                                  )),
                                    ),

                                    const SizedBox(height: 8),
                                    _buildLcdStat('HUNGER', _cat.hunger),
                                    const SizedBox(height: 4),
                                    _buildLcdStat('HAPPY ', _cat.happiness),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Botones de interacción
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildArcadeButton(
                                    label: 'A: FEED',
                                    color: NeoColors.accent,
                                    onPressed: _feed,
                                  ),
                                  _buildArcadeButton(
                                    label: 'B: PET',
                                    color: NeoColors.secondary,
                                    onPressed: _pet,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay de Game Over cuando expira el Timer de 30s
          if (isGameOver)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: NeoStyle.border(width: 3.5),
                      boxShadow: NeoStyle.hardShadow(
                        offset: const Offset(6, 6),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '¡TE QUEDASTE DORMIDO! 💀',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'El gato se aburrió de esperar y no podés ver el portafolio.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _cat.resetGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: NeoColors.cardBg,
                            foregroundColor: NeoColors.border,
                            elevation: 0,
                            side: const BorderSide(
                              width: 3,
                              color: NeoColors.border,
                            ),
                          ),
                          child: const Text(
                            'REINTENTAR',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLcdStat(String label, double value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: const Color(0xFF86A387),
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArcadeButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: NeoStyle.border(width: 3.5),
              boxShadow: NeoStyle.hardShadow(offset: const Offset(3, 3)),
            ),
            child: const Center(
              child: Icon(Icons.touch_app, color: NeoColors.border, size: 22),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
