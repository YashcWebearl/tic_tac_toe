import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  factory AudioHelper() => _instance;
  AudioHelper._internal();

  late SoLoud _soLoud;
  bool _isSoundOn = true;

  AudioSource? _makeMove;
  AudioSource? _buttonClick;
  AudioSource? _lose;
  AudioSource? _money;
  AudioSource? _win;
  SoundHandle? _winHandle;
  SoundHandle? _loseHandle;

  SoundHandle? _playingBackground;

  Future<void> initialize() async {
    print('sound fetch00000000000000');
    _soLoud = SoLoud.instance;
    print('sound fetch44444444444444');
    if (_soLoud.isInitialized) return;
    print('sound fetch11111111111');

    await _soLoud.init();
    _makeMove = await _soLoud.loadAsset('assets/music/Xplace.mp3');
    _buttonClick = await _soLoud.loadAsset('assets/music/button_click.mp3');
    _lose = await _soLoud.loadAsset('assets/music/Lose.mp3');
    _money = await _soLoud.loadAsset('assets/music/Money.mp3');
    _win = await _soLoud.loadAsset('assets/music/Win.mp3');

    await _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    print('sound fetch222222222222');
    _isSoundOn = prefs.getBool('sound_on') ?? true;
  }

  Future<void> toggleSound() async {
    _isSoundOn = !_isSoundOn;
    print('sound fetch33333333333');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_on', _isSoundOn);
  }

  bool get isSoundOn => _isSoundOn;

  void playButtonClick() async {
    if (_isSoundOn && _buttonClick != null) {
      await _soLoud.play(_buttonClick!);
    }
  }


  void playMoneySound() async {
    if (_isSoundOn && _money != null) {
      await _soLoud.play(_money!);
    }
  }

  // void playWinSound() async {
  //   if (_isSoundOn && _win != null) {
  //     await _soLoud.play(_win!);
  //   }
  // }
  // void playLoseSound() async {
  //   if (_isSoundOn && _lose != null) {
  //     await _soLoud.play(_lose!);
  //   }
  // }
  void playWinSound() async {
    if (_isSoundOn && _win != null) {
      _winHandle = await _soLoud.play(_win!);
    }
  }

  void playLoseSound() async {
    if (_isSoundOn && _lose != null) {
      _loseHandle = await _soLoud.play(_lose!);
    }
  }
  void stopWinOrLoseSound() {
    if (_winHandle != null) {
      _soLoud.stop(_winHandle!);
      _winHandle = null;
    }
    if (_loseHandle != null) {
      _soLoud.stop(_loseHandle!);
      _loseHandle = null;
    }
  }

  // void playMakeMove() async {
  //   if (_isSoundOn && _makeMove != null) {
  //     await _soLoud.play(_makeMove!);
  //   }
  // }
  void playMakeMove() async {
    if (_isSoundOn && _makeMove != null) {
      _playingBackground = await _soLoud.play(_makeMove!);
      _soLoud.setProtectVoice(_playingBackground!, true);
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (_playingBackground != null) {
      _soLoud.fadeVolume(_playingBackground!, 0.0, const Duration(milliseconds: 500));
    }
  }

  void dispose() {
    _soLoud.deinit();
  }
}





// import 'package:flutter/cupertino.dart';
// import 'package:flutter_soloud/flutter_soloud.dart';
//
// class AudioHelper {
//   static final AudioHelper _instance = AudioHelper._internal();
//   factory AudioHelper() => _instance;
//   AudioHelper._internal();
//   late SoLoud _soLoud;
//
//   AudioSource? _makeMove;
//   AudioSource? _buttonClick;
//   AudioSource? _lose;
//   AudioSource? _money;
//   AudioSource? _win;
//
//   SoundHandle? _playingBackground;
//
//   Future<void> initialize() async {
//     print('sound fetch11111111111');
//     _soLoud = SoLoud.instance;
//     if (_soLoud.isInitialized) return;
//
//     try {
//       print('sound fetch22222222');
//       await _soLoud.init();
//
//       // Load assets from the music folder
//       _makeMove = await _soLoud.loadAsset('assets/music/Xplace2.mp3');
//       _buttonClick = await _soLoud.loadAsset('assets/music/button_click.mp3');
//       _lose = await _soLoud.loadAsset('assets/music/Lose.mp3');
//       _money = await _soLoud.loadAsset('assets/music/Money.mp3');
//       _win = await _soLoud.loadAsset('assets/music/Win.mp3');
//     } catch (e) {
//       debugPrint('Error initializing audio assets: $e');
//     }
//   }
//
//   void playBackgroundMusic() async {
//     if (_makeMove == null) {
//       await initialize();
//     }
//     if (_makeMove != null) {
//       _playingBackground = await _soLoud.play(_makeMove!);
//       _soLoud.setProtectVoice(_playingBackground!, true);
//     }
//   }
//
//   Future<void> stopBackgroundMusic() async {
//     if (_playingBackground != null) {
//       _soLoud.fadeVolume(_playingBackground!, 0.0, const Duration(milliseconds: 500));
//     }
//   }
//
//   void playButtonClick() async {
//     if (_buttonClick != null) await _soLoud.play(_buttonClick!);
//   }
//
//   void playLoseSound() async {
//     if (_lose != null) await _soLoud.play(_lose!);
//   }
//
//   void playMoneySound() async {
//     if (_money != null) await _soLoud.play(_money!);
//   }
//
//   void playWinSound() async {
//     if (_win != null) await _soLoud.play(_win!);
//   }
//
//   void dispose() {
//     _soLoud.deinit(); // optional cleanup
//   }
// }