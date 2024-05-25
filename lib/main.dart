import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(StopwatchApp());

class StopwatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stopwatch',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StopwatchHomePage(),
    );
  }
}

class StopwatchHomePage extends StatefulWidget {
  @override
  _StopwatchHomePageState createState() => _StopwatchHomePageState();
}

class _StopwatchHomePageState extends State<StopwatchHomePage> {
  late Stopwatch _stopwatch;
  late Timer _timer;
  List<String> _recordedTimes = [];
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStopwatch() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
    _stopwatch.start();
  }

  void _pauseStopwatch() {
    _recordedTimes.add(_formatTime(_stopwatch.elapsedMilliseconds));
    _timer.cancel();
    _stopwatch.stop();
    setState(() {
      _isPaused = true;
    });
  }

  void _continueStopwatch() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {});
    });
    _stopwatch.start();
    setState(() {
      _isPaused = false;
    });
  }

  void _resetStopwatch() {
    _timer.cancel();
    _stopwatch.reset();
    _recordedTimes.clear();
    setState(() {
      _isPaused = false;
    });
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr:$hundredsStr";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'STOPWATCH',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: (_stopwatch.elapsedMilliseconds % 60000) / 60000,
                    strokeWidth: 10.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[800]!),
                    backgroundColor: Colors.teal[100],
                  ),
                ),
                Text(
                  _formatTime(_stopwatch.elapsedMilliseconds),
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: !_stopwatch.isRunning && !_isPaused
                      ? _startStopwatch
                      : _stopwatch.isRunning
                      ? _pauseStopwatch
                      : _continueStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _stopwatch.isRunning
                        ? Colors.blueGrey
                        : _isPaused
                        ? Colors.teal
                        : Colors.teal[700],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text(!_stopwatch.isRunning && !_isPaused
                      ? 'Start'
                      : _stopwatch.isRunning
                      ? 'Pause'
                      : 'Continue',
                    style: TextStyle(color: Colors.black),),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  child: Text('Reset', style: TextStyle(color: Colors.black),),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _recordedTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Lap ${index + 1}: ${_recordedTimes[index]}',
                      style: TextStyle(color: Colors.teal[800], fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
