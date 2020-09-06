import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import '../models/list_models.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class TrackPage extends StatefulWidget {
  final TrackModel trackModel;
  TrackPage(this.trackModel);
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  IconData playIcon = Icons.play_arrow;
  bool playState = false;
  bool onClicked = false;
  int currentPosition;
  String currentDuration = '';
  String songDuration = '';
  AudioPlayer audioPlayer = AudioPlayer();
  double sliderValue = 0;
  double maxSliderValue = 0;
  bool isStarting = true;

  @override
  void initState() {
    super.initState();
    audioPlayer.onAudioPositionChanged.listen((event) async {
      currentPosition = event.inMilliseconds;
      setState(() {
        currentDuration = getTrackDuration(currentPosition);
        sliderValue = currentPosition / 1000;
      });
      var trackDuration = await audioPlayer.getDuration();
      if (isStarting) {
        maxSliderValue = trackDuration / 1000;
        isStarting = false;
      }

      setState(() {
        songDuration = getTrackDuration(trackDuration - currentPosition);
      });
    });
  }

  String getTrackDuration(int songDuration) {
    int songInSeconds = (songDuration / 1000).toInt();
    int songInMinutes = (songInSeconds / 60).toInt();
    int seconds = songInSeconds - (songInMinutes * 60);
    String str_minutes = songInMinutes.toString();
    String str_seconds = seconds.toString();
    if (str_minutes.length == 1) {
      str_minutes = '0$str_minutes';
    }
    if (str_seconds.length == 1) {
      str_seconds = '0$str_seconds';
    }
    return '$str_minutes:$str_seconds';
  }

  void play(String trackLocation) async {
    if (!onClicked) {
      await audioPlayer.play(trackLocation, isLocal: true);
      onClicked = true;
    }
  }

  void pause() {
    if (onClicked) {
      audioPlayer.pause();
      onClicked = false;
    }
  }

  void fastForward() {
    if (onClicked) {
      audioPlayer.getDuration().then((trackDuration) {
        if (5000 + currentPosition < trackDuration) {
          audioPlayer.seek(Duration(milliseconds: 10 + currentPosition));
        }
      });
    }
  }

  void rewind() {
    if (onClicked) {
      audioPlayer.getDuration().then((trackDuration) {
        if (currentPosition - 5000 > 0) {
          audioPlayer.seek(Duration(milliseconds: currentPosition - 5000));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (onClicked) {
            audioPlayer.stop();
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (onClicked) {
                            audioPlayer.stop();
                          }
                          Navigator.pop(context);
                        },
                        color: Colors.black12,
                        elevation: 3,
                        shape: CircleBorder(
                            side: BorderSide(
                          color: Colors.grey[700],
                        )),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey[400],
                          size: 12,
                        ),
                      ),
                      Text(
                        'PLAYING NOW',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        elevation: 3,
                        color: Colors.black12,
                        shape: CircleBorder(
                            side: BorderSide(
                          color: Colors.grey[700],
                        )),
                        child: Icon(
                          Icons.menu,
                          color: Colors.grey[400],
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      border: Border.all(
                        color: Colors.black,
                        width: 7,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: widget.trackModel.imagebytes == null
                          ? Image.asset(
                              'assets/cover.jpg',
                              width: 250,
                              height: 250,
                            )
                          : Image.memory(
                              widget.trackModel.imagebytes,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      widget.trackModel.trackName,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    // margin: EdgeInsets.fromLTRB(0, 30, 10, 0),
                    child: Text(
                      widget.trackModel.albumName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          currentDuration,
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[600]),
                        ),
                        Text(
                          songDuration,
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    child: Slider(
                        activeColor: Colors.amberAccent,
                        inactiveColor: Colors.black,
                        value: sliderValue,
                        max: maxSliderValue,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                            audioPlayer.seek(
                                Duration(milliseconds: (value * 1000).toInt()));
                          });
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(20),
                          color: Colors.black12,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.grey[400],
                          )),
                          onPressed: () {
                            rewind();
                          },
                          child: Icon(
                            Icons.fast_rewind,
                            color: Colors.white,
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.all(20),
                          color: Colors.deepOrange,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.black,
                          )),
                          onPressed: () {
                            if (playState) {
                              pause();
                              setState(() {
                                playIcon = (Icons.play_arrow);
                                playState = false;
                              });
                            } else {
                              play(widget.trackModel.trackLocation);
                              setState(() {
                                playIcon = (Icons.pause);
                                playState = true;
                              });
                            }
                          },
                          child: Icon(
                            playIcon,
                            color: Colors.white,
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.all(20),
                          color: Colors.black12,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.grey[400],
                          )),
                          onPressed: () {
                            fastForward();
                          },
                          child: Icon(
                            Icons.fast_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
