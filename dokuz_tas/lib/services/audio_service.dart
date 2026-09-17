import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _placePlayer = AudioPlayer();
  final AudioPlayer _capturePlayer = AudioPlayer();
  final AudioPlayer _millPlayer = AudioPlayer();

  double _musicVolume = 1.0;
  double _sfxVolume = 1.0;

  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  static bool isTestMode = false;

  Future<void> init() async {
    if (isTestMode) return;
    
    try {
      // Load saved volumes
      final prefs = await SharedPreferences.getInstance();
      _sfxVolume = prefs.getDouble('sfxVolume') ?? 1.0;

      // Apply volumes
      _placePlayer.setVolume(_sfxVolume);
      _capturePlayer.setVolume(_sfxVolume);
      _millPlayer.setVolume(_sfxVolume);
      
      // Local Assets (Lichess standard sounds)
      await _placePlayer.setSource(AssetSource('audio/place.mp3'));
      await _capturePlayer.setSource(AssetSource('audio/capture.mp3'));
      await _millPlayer.setSource(AssetSource('audio/mill.mp3'));
      
      await _placePlayer.setPlayerMode(PlayerMode.lowLatency);
      await _capturePlayer.setPlayerMode(PlayerMode.lowLatency);
      await _millPlayer.setPlayerMode(PlayerMode.lowLatency);
    } catch (e) {
      print('AudioService init failed: $e');
    }
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume;
    await _placePlayer.setVolume(volume);
    await _capturePlayer.setVolume(volume);
    await _millPlayer.setVolume(volume);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sfxVolume', volume);
  }

  void playPlaceSound() {
    if (isTestMode || _sfxVolume == 0.0) return;
    HapticFeedback.lightImpact();
    _placePlayer.stop();
    _placePlayer.resume();
  }

  void playCaptureSound() {
    if (isTestMode || _sfxVolume == 0.0) return;
    HapticFeedback.heavyImpact();
    _capturePlayer.stop();
    _capturePlayer.resume();
  }

  void playMillSound() {
    if (isTestMode || _sfxVolume == 0.0) return;
    HapticFeedback.mediumImpact();
    _millPlayer.stop();
    _millPlayer.resume();
  }

  void playErrorSound() {
    if (isTestMode || _sfxVolume == 0.0) return;
    HapticFeedback.vibrate();
  }
}
