import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  final int initialMinutes;
  final int initialExtraSeconds;
  final bool useBronstein;
  final bool notificationsSonores;
  final bool useSpacebar;

  const HomeScreen({
    super.key,
    this.initialMinutes = 3,
    this.initialExtraSeconds = 0,
    this.useBronstein = false,
    this.notificationsSonores = false,
    this.useSpacebar = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _secondsFirst = 0;
  int _secondsSecond = 0;
  int _extraSeconds = 0;
  Timer? _timer;
  bool _isFirstTimerActive = false;
  bool _isSecondTimerActive = false;
  bool _isGameStarted = false;
  bool _isPaused = false;
  DateTime? _lastSwitchTime;

  @override
  void initState() {
    super.initState();
    _secondsFirst = widget.initialMinutes * 60;
    _secondsSecond = widget.initialMinutes * 60;
    _extraSeconds = widget.initialExtraSeconds;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _switchTimer() {
    if (!widget.useSpacebar && _isPaused) return;
    setState(() {
      if (!_isGameStarted) {
        _isGameStarted = true;
        _isFirstTimerActive = true;
        _isSecondTimerActive = false;
        _isPaused = false;
        _startTimer(true);
      } else if (!_isPaused) {
        _isFirstTimerActive = !_isFirstTimerActive;
        _isSecondTimerActive = !_isSecondTimerActive;
        _applyBronsteinIfNeeded();
        _startTimer(_isFirstTimerActive);
      }
      _lastSwitchTime = DateTime.now();
    });
  }

  void _applyBronsteinIfNeeded() {
    if (widget.useBronstein && _lastSwitchTime != null) {
      Duration timeElapsed = DateTime.now().difference(_lastSwitchTime!);
      int elapsedSeconds = timeElapsed.inSeconds;
      if (_isFirstTimerActive && elapsedSeconds > 2) {
        setState(() {
          _secondsFirst += 2;
        });
      } else if (!_isSecondTimerActive && elapsedSeconds > 2) {
        setState(() {
          _secondsSecond += 2;
        });
      }
    }
  }

  void _startTimer(bool isFirst) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (isFirst && _secondsFirst > 0) {
          _secondsFirst--;
        } else if (!isFirst && _secondsSecond > 0) {
          _secondsSecond--;
        } else {
          timer.cancel();
          _isFirstTimerActive = false;
          _isSecondTimerActive = false;
          _isPaused = true;
        }
      });
    });
  }

  void _playTimer() {
    setState(() {
      if (!_isGameStarted) {
        _isGameStarted = true;
        _isFirstTimerActive = true;
        _isSecondTimerActive = false;
        _isPaused = false;
        _startTimer(true);
      } else if (_isPaused) {
        _isPaused = false;
        _startTimer(_isFirstTimerActive);
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _timer?.cancel();
      _isPaused = true;
      _isFirstTimerActive = false;
      _isSecondTimerActive = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _secondsFirst = widget.initialMinutes * 60;
      _secondsSecond = widget.initialMinutes * 60;
      _isFirstTimerActive = false;
      _isSecondTimerActive = false;
      _isGameStarted = false;
      _isPaused = false;
      _lastSwitchTime = null;
    });
  }

  Color _getContainerColor(bool isActive, int seconds) {
    if (seconds <= 0) return Colors.red;
    return isActive && !_isPaused ? Colors.green : Colors.grey[700]!;
  }

  Color _getTextColor(bool isActive, int seconds) {
    if (seconds <= 0) return Colors.white;
    return isActive && !_isPaused ? Colors.white : Colors.black;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double timerWidth = screenWidth * 0.4;
    final double timerHeight = screenHeight * 0.25;
    final double iconSize = screenWidth * 0.08;
    final double buttonWidth = screenWidth * 0.25;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space &&
            widget.useSpacebar) {
          _switchTimer();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color.fromARGB(230, 200, 200, 200),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.menu, color: Colors.black),
                          SizedBox(width: 8.0),
                          Text(
                            'CHESS CLOCK',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildTimeOption('Bullet', 1, 0),
                          _buildTimeOption('Blitz', 3, 2),
                          _buildTimeOption('Rapid', 5, 3),
                          _buildTimeOption('Rapid', 15, 10),
                          _buildTimeOption('Rapid', 25, 10),
                          _buildTimeOption('Custom', 0, 0),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: timerWidth * 2 + 20,
                          height: timerHeight + 50,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[800],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: timerWidth,
                                height: timerHeight,
                                decoration: BoxDecoration(
                                  color: _getContainerColor(
                                    _isFirstTimerActive,
                                    _secondsFirst,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatTime(_secondsFirst),
                                    style: TextStyle(
                                      fontSize: timerHeight * 0.3,
                                      fontWeight: FontWeight.bold,
                                      color: _getTextColor(
                                        _isFirstTimerActive,
                                        _secondsFirst,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: timerWidth,
                                height: timerHeight,
                                decoration: BoxDecoration(
                                  color: _getContainerColor(
                                    _isSecondTimerActive,
                                    _secondsSecond,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _formatTime(_secondsSecond),
                                    style: TextStyle(
                                      fontSize: timerHeight * 0.3,
                                      fontWeight: FontWeight.bold,
                                      color: _getTextColor(
                                        _isSecondTimerActive,
                                        _secondsSecond,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -20,
                          child: Container(
                            width: timerWidth * 2 + 20,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _pauseTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          minimumSize: Size(buttonWidth, 40),
                        ),
                        child: Text('Pause'),
                      ),
                      ElevatedButton(
                        onPressed: _switchTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          minimumSize: Size(buttonWidth, 40),
                        ),
                        child: Text('Turn 1: White To Play'),
                      ),
                      ElevatedButton(
                        onPressed: _resetTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          minimumSize: Size(buttonWidth, 40),
                        ),
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Press SPACE to pass turn',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        Icons.volume_up,
                        color: Colors.blueGrey[700],
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeOption(String label, int minutes, int increment) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _secondsFirst = minutes * 60;
            _secondsSecond = minutes * 60;
            _extraSeconds = increment;
            _isGameStarted = false;
            _isPaused = false;
            _timer?.cancel();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              minutes == widget.initialMinutes &&
                  increment == widget.initialExtraSeconds
              ? Colors.orange
              : Colors.grey[300],
          minimumSize: Size(60, 30),
        ),
        child: Text(
          '$label ${minutes == 0 ? '' : '$minutes'}${increment > 0 ? '+${increment}' : ''}',
        ),
      ),
    );
  }
}
