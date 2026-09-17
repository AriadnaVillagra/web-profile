// frontend/lib/features/tamagotchi_cat/domain/tamagotchi_controller.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/games/game_rule.dart';
import '../../../../core/services/portfolio_access_service.dart';

class TamagotchiController extends ChangeNotifier implements GameRule {
  double hunger = 0.3;
  double happiness = 0.4;

  bool _isWon = false;
  bool _isGameOver = false;

  Timer? _timer;
  int _secondsRemaining = 30; // Tiempo límite de inactividad/desafío

  TamagotchiController() {
    _startTimer();
  }

  int get secondsRemaining => _secondsRemaining;

  @override
  bool get isWon => _isWon;

  @override
  bool get isGameOver => _isGameOver;

  @override
  String get statusMessage {
    if (_isGameOver) {
      return '💀 ¡EL MICHI MURIÓ DE ABURRIMIENTO!';
    }
    if (PortfolioAccessService().isUnlocked) {
      return '😻 ¡MICHI FELIZ! ACCESO CONCEDIDO';
    }
    if (hunger < 0.4) {
      return '¡EL MICHI TIENE HAMBRE!';
    }
    if (happiness < 0.4) {
      return '¡EL MICHI QUIERE MIMOS!';
    }
    return '¡TIEMPO: $_secondsRemaining S!';
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isWon || _isGameOver) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        // Si el jugador no interactúa, sus métricas decaen gradualmente
        hunger = (hunger - 0.02).clamp(0.0, 1.0);
        happiness = (happiness - 0.02).clamp(0.0, 1.0);

        // Verificamos si alguna barra llegó a 0 inmediatamente
        _checkGameOver();
        notifyListeners();
      } else {
        // Se acabó el tiempo -> DERROTA
        _triggerGameOver();
      }
    });
  }

  void _checkGameOver() {
    if (hunger <= 0.0 || happiness <= 0.0) {
      _triggerGameOver();
    }
  }

  void _triggerGameOver() {
    _isGameOver = true;
    _timer?.cancel();
    notifyListeners();
  }

  void feed() {
    if (_isGameOver || _isWon) return;

    hunger = (hunger + 0.35).clamp(0.0, 1.0);
    happiness = (happiness + 0.15).clamp(0.0, 1.0);
    checkWinCondition();
    notifyListeners();
  }

  void pet() {
    if (_isGameOver || _isWon) return;

    happiness = (happiness + 0.25).clamp(0.0, 1.0);
    checkWinCondition();
    notifyListeners();
  }

  @override
  bool checkWinCondition() {
    if (hunger >= 0.8 && happiness >= 0.8) {
      _isWon = true;
      _timer?.cancel();
      PortfolioAccessService().unlockPortfolio('Tamagotchi Michi');
      return true;
    }
    return false;
  }

  @override
  void resetGame() {
    hunger = 0.3;
    happiness = 0.4;
    _isWon = false;
    _isGameOver = false;
    _startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
