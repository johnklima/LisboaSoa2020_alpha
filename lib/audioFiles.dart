import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
///
/// If this has an error run the terminal
/// flutter pub run build_runner build
///
///or (for a watcher)
///
/// flutter pub build_runner watch
part 'audioFiles.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
///
@JsonSerializable()
class AudioFiles{
  AudioFiles(this.guid, this.position, this.duration, this.location);

  String guid;
  String position;
  String duration;
  String location;

  factory AudioFiles.fromJson(Map<String, dynamic> json) => _$AudioFilesFromJson(json);

  Map<String, dynamic> toJson() => _$AudioFilesToJson(this);

/*
  AudioFiles.fromJson(Map<String, dynamic> json)
      : guid = json['guid'],
        position = json['position'],
        duration = json['duration'];

  Map<String, dynamic> toJson() =>
      {
        'guid': guid,
        'position': position,
        'duration': duration,
      };
 */
}