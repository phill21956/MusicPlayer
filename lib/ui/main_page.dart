import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_player/ui/track_page.dart';
import '../widgets/list_template.dart';
import '../models/list_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:directory_picker/directory_picker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List<File> audioFiles;
  Color favBackground = Colors.grey[400];
  bool favState = false;
  String listStateText = 'Loading...';
  bool areFilesSelected = true;
  List<TrackModel> data = new List<TrackModel>();

  String audioFileDir;
  bool isStarting = true;

  Future<String> getAudioFilesDirectory() async {
    Directory root = await getExternalStorageDirectory();

    Directory dir =
        await DirectoryPicker.pick(context: context, rootDirectory: root);
    return dir.path;
  }

  void writeLocation() {}

  void getAudioFile(String directoryPath) {
    print(directoryPath);
    Directory audioDir = Directory(directoryPath);
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = audioDir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      print(path);
      if (path.endsWith('.mp3')) {
        _songs.add(entity);
      }
    }

    if (_songs == null) {
      setState(() {
        areFilesSelected = false;
        listStateText = 'No Files Selected';
      });
    } else {
      setState(() {
        data = _songs.map((file) {
          return new TrackModel(trackLocation: file.path);
        }).toList();
      });
    }
  }

  void checkIfFolderExist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    preferences.remove('path');
    audioFileDir = preferences.getString('path');

    if (audioFileDir == null) {
      print('Not Available');
      String folderPath = await getAudioFilesDirectory();
      if (folderPath != null) {
        preferences.setString('path', folderPath);
        print(folderPath);
        getAudioFile(folderPath);
      } else {
        print('object');
        print(audioFileDir);
        getAudioFile(audioFileDir);
        print('Available');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfFolderExist();
  }

  @override
  Widget build(BuildContext context) {
    //  var deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Text(
                  'Music - Player',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 3,
                      color: Colors.black12,
                      onPressed: () {
                        if (favState == true) {
                          setState(() {
                            favBackground = Colors.grey[400];
                            favState = false;
                          });
                        } else {
                          setState(() {
                            favBackground = Colors.red;
                            favState = true;
                          });
                        }
                      },
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.grey[700],
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: favBackground,
                        size: 15,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.asset(
                          'assets/cover.jpg',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    RaisedButton(
                      elevation: 3,
                      color: Colors.black12,
                      onPressed: () {},
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.grey[700],
                        ),
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              data != null
                  ? Container(
                      margin: EdgeInsets.fromLTRB(30, 20, 5, 0),
                      child: Column(
                        children: data
                            .map(
                              (item) => ListTemplate(item),
                            )
                            .toList(),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(30, 20, 5, 20),
                      child: Column(
                        children: <Widget>[
                          areFilesSelected
                              ? CircularProgressIndicator()
                              : SizedBox(),
                          Text(
                            listStateText,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
