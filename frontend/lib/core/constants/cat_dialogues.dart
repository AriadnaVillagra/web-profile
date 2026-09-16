// lib/core/constants/cat_dialogues.dart

enum GameType { intro, snake, memory, ahorcado, tamagotchi, hub }

class CatDialogues {
  static List<String> getDialoguesFor(GameType type) {
    switch (type) {
      case GameType.intro:
        return [
          "Ah...",
          "Otra persona acá...",
          "Bienvenido a la web de mi humana.",
          "Si querés ver sus proyectos vas a tener que ganar un juego.",
          "Yo solo soy un gato.",
          "Bueno...",
          "En realidad soy un .png",
          "No importa...",
        ];
      case GameType.snake:
        return [
          "¿Snake? Qué clásico tan aburrido...",
          "No te comas tu propia cola, por favor.",
          "Si perdés acá, de verdad cuestiono tus habilidades.",
        ];
      case GameType.memory:
        return [
          "Juego de memoria...",
          "A ver si te acordás dónde dejaste las cartas.",
          "Espero que tengas mejor memoria que un pez dorado.",
        ];
      case GameType.ahorcado:
        return [
          "El ahorcado.",
          "Adiviná la palabra antes de que se acabe el tiempo.",
          "Cuidado con errarle a las vocales.",
        ];
      case GameType.tamagotchi:
        return [
          "Genial, tenés que cuidar a otro gato.",
          "No me des de comer nada raro.",
          "Manteneme con vida si querés ver el portfolio.",
        ];
      case GameType.hub:
        return [
          "Elegí un juego...",
          "Ganá uno para desbloquear el portfolio.",
          "No tengo todo el día.",
        ];
    }
  }
}
