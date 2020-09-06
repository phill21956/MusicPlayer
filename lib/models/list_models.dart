import 'dart:typed_data';

class TrackModel {
  final String trackName;
  final String albumName;
  final Uint8List imagebytes;
  final String trackLocation;

  TrackModel(
      {this.trackName = '',
      this.albumName = '',
      this.imagebytes = null,
      this.trackLocation});
}
