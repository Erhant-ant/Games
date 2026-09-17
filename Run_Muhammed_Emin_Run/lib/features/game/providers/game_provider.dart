import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_similarity/string_similarity.dart';
import '../../../data/models/question.dart';
import '../../../data/repositories/questions_repository.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/shared_prefs_service.dart';
import '../../../core/services/firebase_service.dart';

enum LetterState { unanswered, current, correct, wrong }

class GameProvider extends ChangeNotifier {
  final List<Question> _gameQuestions = [];
  final Map<String, LetterState> _letterStates = {};
  int _currentIndex = 0;
  
  // Expose timer via ValueNotifier to prevent full widget tree rebuilds on every tick
  final ValueNotifier<int> timeLeftNotifier = ValueNotifier<int>(120);
  Timer? _timer;
  
  bool _isGameOver = false;
  bool _isNewHighScore = false;
  int _score = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  
  bool _hasUsedHint = false;
  bool _hasUsedTime = false;
  bool _hasUsedChange = false;

  QuestionCategory? _selectedCategory;
  QuestionCategory? get selectedCategory => _selectedCategory;
  
  int _earnedCoins = 0;
  int get earnedCoins => _earnedCoins;

  void startGame([QuestionCategory? category]) {
    _gameQuestions.clear();
    _letterStates.clear();
    _selectedCategory = category;
    
    final allQuestions = QuestionsRepository.getInitialQuestions();
    
    for (String letter in QuestionsRepository.alphabet) {
      _letterStates[letter] = LetterState.unanswered;
      List<Question> qs = allQuestions.where((q) => q.startingLetter == letter).toList();
      
      if (category != null) {
        final categoryQs = qs.where((q) => q.category == category).toList();
        if (categoryQs.isNotEmpty) {
          qs = categoryQs; // Use category questions if available
        }
      }
      
      if (qs.isNotEmpty) {
        qs.shuffle();
        _gameQuestions.add(qs.first);
      } else {
        _gameQuestions.add(Question(
          id: -1, 
          text: '$letter harfi ile başlayan soru bulunamadı.', 
          answer: 'PAS', 
          startingLetter: letter, 
          category: QuestionCategory.mixed
        ));
      }
    }
    
    _currentIndex = 0;
    _letterStates[_gameQuestions[_currentIndex].startingLetter] = LetterState.current;
    
    timeLeftNotifier.value = 120;
    _score = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _earnedCoins = 0;
    _isGameOver = false;
    _isNewHighScore = false;
    
    _hasUsedHint = false;
    _hasUsedTime = false;
    _hasUsedChange = false;
    
    _startTimer();
    notifyListeners();
  }

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  void pauseGame() {
    if (_isGameOver) return;
    _isPaused = true;
    notifyListeners();
  }

  void resumeGame() {
    if (_isGameOver) return;
    _isPaused = false;
    notifyListeners();
  }

  void quitGame() {
    _timer?.cancel();
    _isGameOver = true;
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (timeLeftNotifier.value > 0) {
        timeLeftNotifier.value--;
        AudioService().playTick();
        if (timeLeftNotifier.value <= 10 && SharedPrefsService.isVibrationEnabled) {
          HapticFeedback.lightImpact();
        }
      } else {
        endGame();
      }
    });
  }

  void endGame() {
    _timer?.cancel();
    _isGameOver = true;
    
    _earnedCoins = _correctCount * 10;
    
    if (_score > SharedPrefsService.highScore) {
      _isNewHighScore = true;
      SharedPrefsService.setHighScore(_score);
      _earnedCoins += 100;
    }
    
    SharedPrefsService.setCoins(SharedPrefsService.coins + _earnedCoins);
    
    // Update Stats
    SharedPrefsService.setTotalGamesPlayed(SharedPrefsService.totalGamesPlayed + 1);
    SharedPrefsService.setTotalCorrectAnswers(SharedPrefsService.totalCorrectAnswers + _correctCount);
    SharedPrefsService.setTotalWrongAnswers(SharedPrefsService.totalWrongAnswers + _wrongCount);
    
    // Liderlik Tablosuna Skor Gönder (Eğer Nickname belirlenmişse)
    final nickname = SharedPrefsService.nickname;
    if (nickname != null && nickname.isNotEmpty && _score > 0) {
      FirebaseService.submitScore(nickname, _score);
    }

    notifyListeners();
  }

  void answerQuestion(String input) {
    if (_isGameOver) return;
    
    Question currentQ = _gameQuestions[_currentIndex];
    String letter = currentQ.startingLetter;
    
    String formattedInput = input.trim().toLowerCase();
    String formattedAnswer = currentQ.answer.toLowerCase();
    
    double similarity = formattedInput.similarityTo(formattedAnswer);
    double threshold = formattedAnswer.length <= 4 ? 0.9 : 0.75;

    if (similarity >= threshold || formattedInput == formattedAnswer) {
      _letterStates[letter] = LetterState.correct;
      _score += 10;
      _correctCount++;
      AudioService().playCorrect();
      if (SharedPrefsService.isVibrationEnabled) HapticFeedback.mediumImpact();
    } else {
      _letterStates[letter] = LetterState.wrong;
      _wrongCount++;
      AudioService().playWrong();
      if (SharedPrefsService.isVibrationEnabled) HapticFeedback.heavyImpact();
    }
    
    _moveToNextUnanswered();
  }

  void passQuestion() {
    if (_isGameOver) return;
    String letter = _gameQuestions[_currentIndex].startingLetter;
    _letterStates[letter] = LetterState.unanswered; 
    _moveToNextUnanswered();
  }

  void _moveToNextUnanswered() {
    int startIndex = _currentIndex;
    do {
      _currentIndex = (_currentIndex + 1) % _gameQuestions.length;
      if (_currentIndex == startIndex && _letterStates[_gameQuestions[_currentIndex].startingLetter] != LetterState.unanswered) {
        endGame();
        return;
      }
    } while (_letterStates[_gameQuestions[_currentIndex].startingLetter] != LetterState.unanswered);
    
    _letterStates[_gameQuestions[_currentIndex].startingLetter] = LetterState.current;
    notifyListeners();
  }

  List<Question> get gameQuestions => _gameQuestions;
  Question? get currentQuestion => _gameQuestions.isNotEmpty ? _gameQuestions[_currentIndex] : null;
  Map<String, LetterState> get letterStates => _letterStates;
  int get score => _score;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  bool get isGameOver => _isGameOver;
  bool get isNewHighScore => _isNewHighScore;
  
  bool get canUseHint => SharedPrefsService.hintCount > 0 && !_hasUsedHint;
  bool get canUseTime => SharedPrefsService.timeCount > 0 && !_hasUsedTime;
  bool get canUseChange => SharedPrefsService.changeCount > 0 && !_hasUsedChange;

  String? useHintJoker() {
    if (!canUseHint || _isGameOver || currentQuestion == null) return null;
    _hasUsedHint = true;
    SharedPrefsService.setHintCount(SharedPrefsService.hintCount - 1);
    notifyListeners();
    
    String answer = currentQuestion!.answer;
    if (answer.length <= 2) return answer.substring(0, 1);
    return answer.substring(0, 2);
  }

  void useTimeJoker() {
    if (!canUseTime || _isGameOver) return;
    _hasUsedTime = true;
    SharedPrefsService.setTimeCount(SharedPrefsService.timeCount - 1);
    timeLeftNotifier.value += 10;
    notifyListeners();
  }

  void useChangeQuestionJoker() {
    if (!canUseChange || _isGameOver || currentQuestion == null) return;
    _hasUsedChange = true;
    SharedPrefsService.setChangeCount(SharedPrefsService.changeCount - 1);
    
    String letter = currentQuestion!.startingLetter;
    final allQuestions = QuestionsRepository.getInitialQuestions().where((q) => q.startingLetter == letter).toList();
    
    if (allQuestions.length > 1) {
      allQuestions.shuffle();
      Question newQ = allQuestions.firstWhere((q) => q.id != currentQuestion!.id, orElse: () => allQuestions.first);
      _gameQuestions[_currentIndex] = newQ;
    } else {
      passQuestion();
    }
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    timeLeftNotifier.dispose();
    super.dispose();
  }
}
