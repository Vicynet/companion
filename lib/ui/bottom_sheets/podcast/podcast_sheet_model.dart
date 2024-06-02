import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:companion/app/app.locator.dart';
import 'package:companion/app/app.logger.dart';
import 'package:companion/enums/part_type.dart';
import 'package:companion/model/podcast_part.dart';
import 'package:companion/services/gemini_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PodcastSheetModel extends BaseViewModel {
  final _geminiService = locator<GeminiService>();
  final _dialogService = locator<DialogService>();
  final _logger = getLogger('PodcastSheetModel');

  final flutterTts = FlutterTts();
  final audioPlayer = AudioPlayer();

  Duration get totalDuration => _totalDuration;
  Duration _totalDuration = Duration.zero;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  Timer? _timer;
  double? get progress => _progress;
  double? _progress = 0.0;

  int? get totalLength => _totalLength;
  int? _totalLength = 0;

  bool get isPlaying => _isPlaying;
  bool _isPlaying = false;

  bool get isPaused => _isPaused;
  bool _isPaused = false;

  int get currentPartIndex => _currentPartIndex;
  int _currentPartIndex = 0;

  String? get podcastTitle => _podcastTitle;
  String? _podcastTitle;

  String? get podcastTheme => _podcastTheme;
  String? _podcastTheme;

  String? get podcastScript => _podcastScript;
  String? _podcastScript;

  List<PodcastPart> get podcastParts => _podcastParts;
  List<PodcastPart> _podcastParts = [];

  void generatePodcast() async {
    setBusy(true);
    try {
      var podcast = await _geminiService.generatePodcast();
      _logger.i('My Theme: ${podcast?.theme}');
      _logger.i('My Title: ${podcast?.title}');
      _logger.i(podcast?.script);
      if (podcast != null) {
        _podcastTheme = podcast.theme;
        _podcastTitle = podcast.title;
        _podcastScript = podcast.script;
        notifyListeners();
        _logger.i('Local Title: $_podcastTitle');
        _logger.i('Local Theme: $_podcastTheme');
        setBusy(false);
      }
      notifyListeners();
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        description: "Error fetching conversations",
      );
      notifyListeners();
    }
  }

  void startPlayback() async {
    initializePodcastParts();
    _estimateTotalDuration(_podcastScript);
    setCompletionHandler();
    setAudioCompletionHandler();
    if (_currentPartIndex < _podcastParts.length) {
      _isPlaying = true;
      _isPaused = false;
      _setStartHandler();
      _startTimer();
      await playCurrentPart();
    }
  }

  void _setStartHandler() {
    flutterTts.setStartHandler(() {
      if (_currentPartIndex == 0) {
        _progress = 0.0;
        _currentDuration = Duration.zero;
      }
    });
  }

  Future<void> playCurrentPart() async {
    if (_currentPartIndex < _podcastParts.length) {
      var currentPart = _podcastParts[_currentPartIndex];
      if (currentPart.type == PartType.musicIntro ||
          currentPart.type == PartType.musicOutro) {
        await _playMusic(currentPart.type);
      } else {
        await _speak(currentPart.text, currentPart.type);
      }
    }
  }

  void pausePlayback() {
    flutterTts.pause();
    audioPlayer.pause();
    _isPlaying = false;
    _isPaused = true;
    _stopTimer();
    notifyListeners();
  }

  void resumePlayback() async {
    if (_isPaused) {
      _isPlaying = true;
      _isPaused = false;
      _startTimer();
      await playCurrentPart();
      notifyListeners();
    }
  }

  void stopPlayback() {
    flutterTts.stop();
    audioPlayer.stop();
    _isPlaying = false;
    _isPaused = false;
    _currentPartIndex = 0;
    _stopTimer();
  }

  void setCompletionHandler() {
    flutterTts.setCompletionHandler(() {
      onPartComplete();
    });
  }

  void onPartComplete() {
    _currentPartIndex++;
    if (_currentPartIndex < _podcastParts.length) {
      playCurrentPart();
      notifyListeners();
    } else {
      stopPlayback();
      notifyListeners();
    }
  }

  void setAudioCompletionHandler() {
    audioPlayer.onPlayerComplete.listen((event) {
      onPartComplete();
      notifyListeners();
    });
  }

  Future<void> _speak(String script, PartType type) async {
    if (type == PartType.host) {
      await flutterTts.setVoice({"name": "en-AU-language", "locale": "en-AU"});
    } else if (type == PartType.coHost) {
      await flutterTts
          .setVoice({"name": "en-in-x-end-network", "locale": "en-IN"});
    } else {
      await flutterTts
          .setVoice({"name": "en-us-x-tpf-local", "locale": "en-US"});
    }
    await flutterTts.speak(script);
  }

  Future<void> _playMusic(PartType type) async {
    await audioPlayer.play(AssetSource('sound/intro.mp3'),
        mode: PlayerMode.mediaPlayer);
  }

  void _estimateTotalDuration(String? script) {
    int totalWords = script?.split(' ').length ?? ''.length;
    _totalLength = script?.length ?? ''.length;
    _totalDuration = Duration(seconds: (totalWords / 170 * 60).ceil()) +
        const Duration(seconds: 60);
    notifyListeners();
  }

  void _startTimer() {
    const tick = Duration(seconds: 1);
    _timer = Timer.periodic(tick, (Timer t) {
      if (_currentDuration < _totalDuration) {
        _currentDuration += tick;
        _progress = _currentDuration.inSeconds / _totalDuration.inSeconds;
        notifyListeners();
      } else {
        _isPlaying = false;
        _stopTimer();
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void initializePodcastParts() {
    _logger.i('Local Script: $_podcastScript');

    List<String> lines = _podcastScript!.split('\n');
    for (String line in lines) {
      if (line.startsWith('Title:')) {
        _logger.i('Starts with Title');
        _podcastParts.add(PodcastPart(
            text: line.replaceFirst('Title: ', ''),
            type: PartType.podcastTitle));
      } else if (line == 'Intro Music') {
        _logger.i('Intro Music');

        _podcastParts.add(PodcastPart(text: line, type: PartType.musicIntro));
      } else if (line == 'Outro Music') {
        _podcastParts.add(PodcastPart(text: line, type: PartType.musicOutro));
      } else if (line.startsWith('Host:')) {
        _podcastParts.add(PodcastPart(
            text: line.replaceFirst('Host: ', ''), type: PartType.host));
      } else if (line.startsWith('Co-Host:')) {
        _podcastParts.add(PodcastPart(
            text: line.replaceFirst('Co-Host: ', ''), type: PartType.coHost));
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.stop();
    _stopTimer();
    super.dispose();
  }
}
