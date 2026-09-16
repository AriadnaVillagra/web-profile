// frontend/lib/core/services/portfolio_access_service.dart

import 'package:flutter/material.dart';

class PortfolioAccessService extends ChangeNotifier {
  static final PortfolioAccessService _instance =
      PortfolioAccessService._internal();
  factory PortfolioAccessService() => _instance;
  PortfolioAccessService._internal();

  bool _isUnlocked = false;
  String? _unlockedByGame;

  bool get isUnlocked => _isUnlocked;
  String? get unlockedByGame => _unlockedByGame;

  /// Método invocado únicamente cuando un juego notifica que el usuario GANÓ.
  void unlockPortfolio(String gameName) {
    _isUnlocked = true;
    _unlockedByGame = gameName;
    notifyListeners();
  }

  /// Para pruebas o resetear la sesión.
  void lockPortfolio() {
    _isUnlocked = false;
    _unlockedByGame = null;
    notifyListeners();
  }
}
