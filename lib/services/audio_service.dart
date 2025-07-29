import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  late AudioPlayer _bgmPlayer;     // for background music
  late AudioPlayer _sfxPlayer;     // for sound effects

  AudioService._internal() {
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
  }

  Future<void> init() async {
    await _bgmPlayer.setAsset('assets/audio/the-cutest-bunny.mp3');
    _bgmPlayer.setLoopMode(LoopMode.one);
  }

  void playBgm() => _bgmPlayer.play();
  void pauseBgm() => _bgmPlayer.pause();
  void stopBgm() => _bgmPlayer.stop();

  Future<void> playCorrectSound() async {
    await _sfxPlayer.setAsset('assets/sounds/correct.mp3');
    _sfxPlayer.play();
  }

  Future<void> playWrongSound() async {
    await _sfxPlayer.setAsset('assets/sounds/wrong.mp3');
    _sfxPlayer.play();
  }
}
