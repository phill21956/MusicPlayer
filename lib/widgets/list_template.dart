import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_player/ui/track_page.dart';
import '../models/list_models.dart';
import 'package:audiotagger/audiotagger.dart';

class ListTemplate extends StatefulWidget {
  final TrackModel trackModel;
  ListTemplate(this.trackModel);

  @override
  _ListTemplateState createState() => _ListTemplateState();
}

class _ListTemplateState extends State<ListTemplate> {
  Audiotagger tagger = new Audiotagger();

  String trackName = '';

  String albumName = '';

  Uint8List trackImageBytes;

  void getMetaData() async {
    final Map fileDetails =
        await tagger.readTagsAsMap(path: widget.trackModel.trackLocation);
    setState(() {
      trackName =
          fileDetails['title'] == null || fileDetails['title'].trim().isEmpty
              ? 'UNKNOWN'
              : fileDetails['title'];
      albumName =
          fileDetails['album'] == null || fileDetails['album'].trim().isEmpty
              ? 'UNTITLED'
              : fileDetails['album'];
    });
    trackImageBytes = await getTrackImage();
  }

  Future<Uint8List> getTrackImage() async {
    return await tagger.readArtwork(path: widget.trackModel.trackLocation);
  }

  @override
  void initState() {
    super.initState();
    trackName = '';
    albumName = '';
    getMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var track = new TrackModel(
            trackName: trackName,
            albumName: albumName,
            imagebytes: trackImageBytes,
            trackLocation: widget.trackModel.trackLocation);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TrackPage(track)));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(
                Icons.queue_music,
                color: Colors.grey[300],
              ),
              title: Text(
                trackName,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                albumName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[300],
                ),
              ),
              trailing: Container(
                margin: EdgeInsets.fromLTRB(80, 0, 0, 0),
                child: RaisedButton(
                  elevation: 3,
                  color: Colors.black12,
                  onPressed: () {},
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.grey[700],
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Divider(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
