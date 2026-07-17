import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _bgmPlayer;
  late AudioPlayer _sfxPlayer;

  Future<void> init() async {
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBGM(String assetPath) async {
    try {
      await _bgmPlayer.stop();
      // audioplayers expects paths relative to assets/ folder
      String cleanPath = assetPath.replaceFirst('assets/', '');
      await _bgmPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      // Don't spam the console if the developer hasn't added the audio files yet
      debugPrint("Audio notice: BGM $assetPath could not be played. (Ensure file exists in assets/audios/)");
    }
  }

  Future<void> stopBGM() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  Future<void> playSFX(String assetPath) async {
    try {
      await _sfxPlayer.stop();
      String cleanPath = assetPath.replaceFirst('assets/', '');
      await _sfxPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint("Audio notice: SFX $assetPath could not be played.");
    }
  }

  void setBGMVolume(double volume) {
    _bgmPlayer.setVolume(volume);
  }

  void setSFXVolume(double volume) {
    _sfxPlayer.setVolume(volume);
  }
}
