import 'package:audioplayers/audioplayers.dart';
import 'shared_prefs_service.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  AudioService._internal();

  Future<void> init() async {
    // Set audio contexts if necessary
  }

  Future<void> playTick() async {
    if (SharedPrefsService.isSoundEnabled) {
      try {
        // Uncomment when actual audio files are added
        // await _sfxPlayer.play(AssetSource('audio/tick.mp3')); 
      } catch (e) {
        // Ignore if file doesn't exist
      }
    }
  }

  Future<void> playCorrect() async {
    if (SharedPrefsService.isSoundEnabled) {
      try {
        // Uncomment when actual audio files are added
        // await _sfxPlayer.play(AssetSource('audio/correct.mp3'));
      } catch (e) {
        // Ignore
      }
    }
  }

  Future<void> playWrong() async {
    if (SharedPrefsService.isSoundEnabled) {
      try {
        // Uncomment when actual audio files are added
        // await _sfxPlayer.play(AssetSource('audio/wrong.mp3'));
      } catch (e) {
        // Ignore
      }
    }
  }
}
